const admin = require("firebase-admin");
const { HttpsError } = require("firebase-functions/v2/https");

/**
 * Cloud Function: finalizeProfileApproval
 * Performs an atomic update when an admin approves a professional/institution.
 */
exports.finalizeProfileApprovalHandler = async (request) => {
  // 1. Verify Superadmin
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentication required");
  }

  const SUPERADMIN_EMAILS = ['geo.elnajjar@gmail.com', 'ceo@hopebearer-award.com'];
  const isAdmin = request.auth.token.admin === true ||
                  request.auth.token.role === 'admin' ||
                  SUPERADMIN_EMAILS.includes(request.auth.token.email);

  if (!isAdmin) {
    throw new HttpsError("permission-denied", "Superadmin access required");
  }

  const { id, isApproved, reason } = request.data;
  if (!id) throw new HttpsError("invalid-argument", "Missing profile ID");

  const db = admin.firestore();
  const batch = db.batch();

  try {
    const profRef = db.collection('directory_professionals').doc(id);
    const userRef = db.collection('users').doc(id);
    const logRef = db.collection('directory_admin_logs').doc();

    const timestamp = admin.firestore.FieldValue.serverTimestamp();

    // Update Professional Profile
    batch.update(profRef, {
      isApproved: !!isApproved,
      status: isApproved ? 'Approved' : 'Rejected',
      verificationStatus: isApproved ? 'verified' : 'rejected',
      updatedAt: timestamp
    });

    // Sync with User Global Profile
    batch.set(userRef, {
      isVerified: !!isApproved,
      hasProfile: true,
      updatedAt: timestamp
    }, { merge: true });

    // Record Audit Log
    batch.set(logRef, {
      action: isApproved ? 'APPROVE_PROFILE' : 'REJECT_PROFILE',
      entityId: id,
      entityType: 'professional',
      adminUid: request.auth.uid,
      adminEmail: request.auth.token.email,
      reason: reason || null,
      timestamp: timestamp
    });

    await batch.commit();

    return { success: true };
  } catch (error) {
    console.error("[PROFILE-FUNCTIONS] Approval Error:", error);
    throw new HttpsError("internal", error.message);
  }
};
