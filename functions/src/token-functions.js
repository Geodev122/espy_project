const admin = require('firebase-admin');
const { HttpsError } = require('firebase-functions/v2/https');

/**
 * Spend tokens on a protocol element
 */
exports.spendTokensHandler = async (request) => {
    const { userId, itemId, cost, role } = request.data;

    if (!userId || !itemId || !cost) {
        throw new HttpsError('invalid-argument', 'Missing parameters');
    }

    const db = admin.firestore();
    const rtdb = admin.database();
    const userRef = db.collection('users').doc(userId);
    const roleCol = role === 'institution' ? 'directory_institutions' : 'directory_professionals';
    const roleRef = db.collection(roleCol).doc(userId);

    try {
        const result = await db.runTransaction(async (transaction) => {
            const userDoc = await transaction.get(userRef);
            if (!userDoc.exists) throw new Error(`Protocol error: User identity [${userId}] not synchronized.`);

            const roleDoc = await transaction.get(roleRef);
            if (!roleDoc.exists) throw new Error(`Protocol error: Account type profile not found in ${roleCol}.`);

            const data = userDoc.data();
            const balance = data.walletBalance || 0;

            if (balance < cost) {
                throw new Error('Insufficient token balance');
            }

            const updates = {
                walletBalance: balance - cost,
                tokensUsed: (data.tokensUsed || 0) + cost,
                updatedAt: admin.firestore.FieldValue.serverTimestamp(),
            };

            // Apply specific item benefits
            if (itemId === 'extra_pin') {
                updates.practicePins = (data.practicePins || 0) + 1;
            } else if (itemId === 'renew_pin' || itemId === 'renew_visibility') {
                let currentExpiry = data.visibilityExpiresAt ? data.visibilityExpiresAt.toDate() : new Date();
                if (currentExpiry < new Date()) currentExpiry = new Date();
                const newExpiry = new Date(currentExpiry.getTime() + 30 * 24 * 60 * 60 * 1000);
                updates.visibilityExpiresAt = admin.firestore.Timestamp.fromDate(newExpiry);
            } else if (itemId === 'extra_slot') {
                updates.serviceSlots = (data.serviceSlots || (role === 'institution' ? 5 : 2)) + 1;
            } else if (itemId === 'renew_slot') {
                // For global slot renewal, we can extend a general slot validity or handle per service.
                // Here we increment a general renewal counter or handle specific logic.
                // Assuming global slot renewal for now as per user requirement "renew current items bought".
                updates.serviceSlotsRenewed = (data.serviceSlotsRenewed || 0) + 1;
            } else if (itemId === 'broadcast') {
                updates.broadcastsBought = (data.broadcastsBought || 0) + 1;
            }

            transaction.update(userRef, updates);
            transaction.update(roleRef, updates);

            // Log to ledger
            const ledgerRef = db.collection('wallet_ledger').doc();
            transaction.set(ledgerRef, {
                userId,
                type: 'debit',
                amount: cost,
                itemId,
                description: `Purchased: ${itemId.toUpperCase().replace('_', ' ')}`,
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
            });

            return { success: true, newBalance: updates.walletBalance };
        });

        // Sync to RTDB
        await rtdb.ref(`users/${userId}`).update({
            walletBalance: result.newBalance,
            updatedAt: admin.database.ServerValue.TIMESTAMP,
        });

        return result;

    } catch (error) {
        console.error('[TOKENS] ❌ Spending failed:', error.message);
        throw new HttpsError('internal', error.message);
    }
};

/**
 * Redeem a physical/digital recharge code
 */
exports.redeemRechargeCodeHandler = async (request) => {
    const { userId, code } = request.data;

    if (!userId || !code) {
        throw new HttpsError('invalid-argument', 'Missing userId or code');
    }

    const db = admin.firestore();
    const rtdb = admin.database();

    try {
        const result = await db.runTransaction(async (transaction) => {
            const cardRef = db.collection('recharge_cards').doc(code);
            const cardDoc = await transaction.get(cardRef);

            if (!cardDoc.exists) throw new Error('Invalid recharge code');

            const cardData = cardDoc.data();
            if (cardData.status !== 'active') throw new Error('Code already used or inactive');

            const userRef = db.collection('users').doc(userId);
            const userDoc = await transaction.get(userRef);
            if (!userDoc.exists) throw new Error('User not found');

            const userData = userDoc.data();

            // Role validation
            if (cardData.targetRole && cardData.targetRole !== 'any') {
                if (userData.role !== cardData.targetRole) {
                    throw new Error(`This code is only for ${cardData.targetRole.toUpperCase()} accounts`);
                }
            }

            const tokenValue = parseInt(cardData.tokenValue || 0);
            const extraPins = parseInt(cardData.extraPins || 0);
            const extraSlots = parseInt(cardData.extraSlots || 0);
            const broadcasts = parseInt(cardData.broadcasts || 0);

            const newBalance = (userData.walletBalance || 0) + tokenValue;

            // 1. Mark card as used
            transaction.update(cardRef, {
                status: 'used',
                redeemedBy: userId,
                redeemedAt: admin.firestore.FieldValue.serverTimestamp()
            });

            // 2. Update user assets
            const updates = {
                walletBalance: newBalance,
                practicePins: (userData.practicePins || 0) + extraPins,
                serviceSlots: (userData.serviceSlots || (userData.role === 'institution' ? 5 : 2)) + extraSlots,
                broadcastsBought: (userData.broadcastsBought || 0) + broadcasts,
                updatedAt: admin.firestore.FieldValue.serverTimestamp()
            };
            transaction.update(userRef, updates);

            const roleCol = userData.role === 'institution' ? 'directory_institutions' : 'directory_professionals';
            transaction.update(db.collection(roleCol).doc(userId), updates);

            // 3. Log to ledger
            const ledgerRef = db.collection('wallet_ledger').doc();
            transaction.set(ledgerRef, {
                userId,
                type: 'credit',
                amount: tokenValue,
                description: `Redeemed Code: ${code}`,
                timestamp: admin.firestore.FieldValue.serverTimestamp(),
            });

            return { success: true, added: tokenValue, newBalance };
        });

        // Sync to RTDB
        await rtdb.ref(`users/${userId}`).update({
            walletBalance: result.newBalance,
            updatedAt: admin.database.ServerValue.TIMESTAMP,
        });

        return result;

    } catch (error) {
        console.error('[TOKENS] ❌ Redemption failed:', error.message);
        throw new HttpsError('internal', error.message);
    }
};
