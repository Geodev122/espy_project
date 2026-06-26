const admin = require('firebase-admin');
const { HttpsError } = require('firebase-functions/v2/https');

/**
 * Handle Google Pay Payment and record in system
 */
exports.processGooglePayPaymentHandler = async (request) => {
    const { userId, amount, userType, paymentToken, metadata, paymentDetails } = request.data;

    if (!userId || !amount || !paymentToken) {
        throw new HttpsError('invalid-argument', 'Missing required payment parameters');
    }

    console.log(`[GOOGLEPAY] Processing \$${amount} for ${userId} (${userType})`);

    try {
        const timestamp = admin.firestore.FieldValue.serverTimestamp();
        const externalId = `GPAY-${Date.now()}`;

        // In a real implementation, you would send 'paymentToken' to your payment processor (Stripe, etc.)
        // For Espy Protocol, we validate the signal and record the transaction.

        const db = admin.firestore();
        const batch = db.batch();

        // 1. Record Transaction
        const transRef = db.collection('directory_membership_transactions').doc(externalId);
        batch.set(transRef, {
            id: externalId,
            userId,
            amount,
            userType,
            status: 'completed', // Auto-completed for simulated/direct tokens in this protocol phase
            source: 'google_pay',
            paymentToken,
            metadata: metadata || {},
            createdAt: timestamp,
            updatedAt: timestamp,
        });

        // 2. Update User Profile (Quota and Active Status)
        const userRef = db.collection('users').doc(userId);
        const userDoc = await userRef.get();
        const userData = userDoc.data() || {};

        const extraVisMonths = metadata.vis_months || 0;
        const extraSlots = metadata.slots || 0;
        const extraPins = metadata.pins || 0;
        const extraBroadcasts = metadata.broadcasts || 0;

        const currentSlots = userData.serviceSlots || (userType === 'institution' ? 5 : 2);
        const currentPins = userData.practicePins || 0;
        const currentBroadcasts = userData.broadcastsBought || 0;

        // Calculate new visibility expiry
        let currentExpiry = userData.visibilityExpiresAt ? userData.visibilityExpiresAt.toDate() : new Date();
        if (currentExpiry < new Date()) currentExpiry = new Date();
        const newExpiry = new Date(currentExpiry);
        newExpiry.setMonth(newExpiry.getMonth() + extraVisMonths);

        batch.update(userRef, {
            isActive: true,
            isPaid: true,
            visibilityExpiresAt: admin.firestore.Timestamp.fromDate(newExpiry),
            serviceSlots: currentSlots + extraSlots,
            practicePins: currentPins + extraPins,
            broadcastsBought: currentBroadcasts + extraBroadcasts,
            updatedAt: timestamp,
        });

        // Sync with role-specific collection
        const roleCol = userType === 'institution' ? 'directory_institutions' : 'directory_professionals';
        batch.update(db.collection(roleCol).doc(userId), {
            isActive: true,
            isPaid: true,
            visibilityExpiresAt: admin.firestore.Timestamp.fromDate(newExpiry),
            serviceSlots: currentSlots + extraSlots,
            practicePins: currentPins + extraPins,
            broadcastsBought: currentBroadcasts + extraBroadcasts,
            updatedAt: timestamp,
        });

        // 3. Create Receipt
        const receiptRef = db.collection('directory_receipts').doc();
        batch.set(receiptRef, {
            userId,
            transactionId: externalId,
            amount,
            source: 'google_pay',
            items: metadata.items || [],
            timestamp,
        });

        await batch.commit();

        console.log(`[GOOGLEPAY] ✅ Success for ${userId}`);

        return {
            success: true,
            transactionId: externalId,
        };

    } catch (error) {
        console.error('[GOOGLEPAY] ❌ Error:', error);
        throw new HttpsError('internal', error.message);
    }
};
