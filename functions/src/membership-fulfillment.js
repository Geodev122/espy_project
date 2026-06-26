const admin = require('firebase-admin');

/**
 * Hope Support Suite — Unified Membership Fulfillment (V4.0 - Firestore Native)
 * ═══════════════════════════════════════════════════════════════
 * Handles membership activation across Firestore and RTDB.
 * Legacy DataConnect/Postgres support REMOVED.
 */

/**
 * Fulfills a membership purchase.
 * 
 * @param {string} uid - Firebase Auth UID
 * @param {string} packageId - Package ID from directory_packages
 * @param {object} paymentDetails - Payment info { transactionId, amount, method }
 */
async function fulfillMembership(uid, packageId, paymentDetails) {
  const rtdb = admin.database();
  const fs = admin.firestore();
  const now = new Date();

  console.log(`[Fulfillment] 🚀 Starting native fulfillment for UID: ${uid}, Package: ${packageId}`);

  try {
    // 1. Fetch the package or transaction data
    let pkg = null;
    let customUnits = null;
    let isTokenRecharge = false;

    if (packageId.startsWith('CUSTOM_COMPILATION') || packageId === 'token_recharge') {
       // Fetch transaction to get custom units or tokens
       const txnId = paymentDetails.transactionId.replace('whishpay_', '');
       const txnSnap = await rtdb.ref(`directory_membership_transactions/${txnId}`).once('value');
       if (txnSnap.exists()) {
         customUnits = txnSnap.val();
         isTokenRecharge = customUnits.type === 'token_recharge';
       }
       pkg = { name: isTokenRecharge ? 'Token Recharge' : 'Custom Compilation', duration_days: 30 };
    } else {
       const pkgDoc = await fs.collection('directory_packages').doc(packageId).get();
       if (pkgDoc.exists) {
         pkg = pkgDoc.data();
       } else {
         const pkgSnap = await rtdb.ref(`directory_packages/${packageId}`).once('value');
         if (pkgSnap.exists()) pkg = pkgSnap.val();
       }
    }

    if (!pkg) throw new Error(`Package ${packageId} not found in any database`);

    const durationDays = parseInt(pkg.duration_days || pkg.durationDays) || 30;
    const profileVisibility = customUnits ? true : !!(pkg.profile_visibility || pkg.profileVisibility);
    const serviceVisibilityCount = customUnits ? (Number(customUnits.serviceSlots) || 0) : (parseInt(pkg.service_visibility_count || pkg.serviceVisibilityCount || pkg.serviceSlots || 0));
    const practicePinsCountInput = customUnits ? (Number(customUnits.practicePins) || 0) : (parseInt(pkg.practice_pins || pkg.practicePins || 0));
    const broadcastsCountInput = customUnits ? (Number(customUnits.broadcasts) || Number(customUnits.broadcastsBought) || 0) : (parseInt(pkg.broadcasts || 0));

    // 2. Resolve User Profile in Firestore
    const roleRef = fs.collection('users').doc(uid);
    const roleSnap = await roleRef.get();
    const role = roleSnap.exists ? roleSnap.data().role : 'professional';

    const collectionName = role === 'institution' ? 'directory_institutions' : 'directory_professionals';
    const userDocRef = fs.collection(collectionName).doc(uid);
    const userDoc = await userDocRef.get();
    
    if (!userDoc.exists) {
       throw new Error(`Profile not found in ${collectionName} for UID: ${uid}`);
    }
    const userData = userDoc.data();
    const userType = role;

    // 3. Calculate Expiries
    // Note: The main account is active by default. Expiry only affects "Extra" elements.
    let profileVisibilityExpiry = null;
    const existingExpiry = userData.visibilityExpiresAt ?
        (userData.visibilityExpiresAt.toDate ? userData.visibilityExpiresAt.toDate() : new Date(userData.visibilityExpiresAt)) : null;

    if (existingExpiry && existingExpiry > now) {
      profileVisibilityExpiry = existingExpiry;
    }
    
    // Each visibility purchase adds 30 days to the "Extra" pool
    if (profileVisibility && durationDays > 0) {
      const base = profileVisibilityExpiry || now;
      profileVisibilityExpiry = new Date(base.getTime() + durationDays * 24 * 60 * 60 * 1000);
    }

    // 4. Calculate Service Slots & Practice Pins
    // These are cumulative.
    let serviceSlotsCount = (parseInt(userData.serviceSlots) || (role === 'institution' ? 5 : 2));
    let practicePinsCount = (parseInt(userData.practicePins) || 0);
    let broadcastsBought = (parseInt(userData.broadcastsBought) || 0);
    let walletBalance = (parseInt(userData.walletBalance) || 0);

    if (isTokenRecharge) {
      walletBalance += (customUnits && customUnits.tokens ? parseInt(customUnits.tokens) : 0);
    } else {
      serviceSlotsCount += serviceVisibilityCount;
      practicePinsCount += practicePinsCountInput;
      broadcastsBought += broadcastsCountInput;
    }

    // 5. Atomic Update Firestore & RTDB
    const profileUpdates = {
      membershipStatus: 'active',
      isApproved: true,
      verificationStatus: 'verified',
      isActive: true, // Ensure they stay active upon purchase
      membership_package_id: packageId,
      membership_package_name: pkg.name || pkg.name_en || 'Protocol Unit Top-up',
      serviceSlots: serviceSlotsCount,
      practicePins: practicePinsCount,
      broadcastsBought: broadcastsBought,
      walletBalance: walletBalance,
      last_purchase_date: now.toISOString(),
      updatedAt: admin.firestore.FieldValue.serverTimestamp()
    };
    
    if (profileVisibilityExpiry) {
      profileUpdates.visibilityExpiresAt = admin.firestore.Timestamp.fromDate(profileVisibilityExpiry);
      profileUpdates.profile_visibility_expiry = profileVisibilityExpiry.toISOString();
    }

    // Write to Firestore
    await userDocRef.update(profileUpdates);

    // Sync to Users collection
    await fs.collection('users').doc(uid).set({
      ...profileUpdates,
      hasProfile: true,
      role: userType,
    }, { merge: true });

    // Sync to RTDB (Legacy Support)
    const rtdbUpdates = { ...profileUpdates, updatedAt: admin.database.ServerValue.TIMESTAMP };
    if (rtdbUpdates.visibilityExpiresAt) {
      rtdbUpdates.visibilityExpiresAt = rtdbUpdates.visibilityExpiresAt.toMillis();
    }
    await rtdb.ref(`${collectionName}/${uid}`).update(rtdbUpdates);
    await rtdb.ref(`users/${uid}`).update({ ...rtdbUpdates, role: userType });

    // 5.5 Cleanup: Ensure they are removed from visitors if they are now a provider
    try {
      await fs.collection('directory_visitors').doc(uid).delete();
      await rtdb.ref(`directory_visitors/${uid}`).remove();
    } catch (cleanupErr) {
      console.warn(`[Fulfillment] Non-fatal cleanup error: ${cleanupErr.message}`);
    }

    // 6. Record Payment/Transaction (Unified)
    const txnId = paymentDetails.transactionId.replace('whishpay_', '');
    const paymentId = paymentDetails.transactionId || fs.collection('directory_membership_transactions').doc().id;
    const paymentData = {
      id: paymentId,
      invoiceNumber: txnId,
      userId: uid,
      professionalId: role === 'professional' ? uid : null,
      institutionId: role === 'institution' ? uid : null,
      role: role,
      countryId: userData.mainLocation?.countryId || userData.countryId || null,
      governorateId: userData.mainLocation?.governorateId || userData.governorateId || null,
      cityId: userData.mainLocation?.cityId || userData.cityId || null,
      sectorId: userData.sectorId || null,
      categoryId: userData.categoryId || null,
      packageId,
      packageName: pkg.name || pkg.name_en || 'Protocol Extension',
      amount: parseFloat(paymentDetails.amount || pkg.price || 0),
      currency: paymentDetails.currency || 'USD',
      paymentMethod: paymentDetails.method || 'whishpay',
      status: 'completed',
      isPaid: true,
      visibilityDays: durationDays,
      serviceSlots: serviceVisibilityCount,
      practicePins: practicePinsCountInput,
      broadcasts: broadcastsCountInput,
      createdAt: admin.firestore.FieldValue.serverTimestamp()
    };

    await fs.collection('directory_membership_transactions').doc(paymentId).set(paymentData, { merge: true });
    await fs.collection('payments').doc(paymentId).set(paymentData, { merge: true }); // Legacy sync

    console.log(`[Fulfillment] 🎉 100% Native Firestore fulfillment complete for ${uid}`);
    return {
        success: true,
        packageName: pkg.name || pkg.name_en,
        expiry: profileVisibilityExpiry
    };

  } catch (error) {
    console.error(`[Fulfillment] ❌ Native Fulfillment FAILED:`, error);
    throw error;
  }
}

module.exports = { fulfillMembership };
