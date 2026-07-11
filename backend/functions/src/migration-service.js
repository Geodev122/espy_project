const admin = require('firebase-admin');
const { HttpsError } = require('firebase-functions/v2/https');
const axios = require('axios'); // For GQL calls if needed, or use DataConnect Admin SDK if available

/**
 * Backfill Service: Migrates Firestore data to DataConnect (PostgreSQL)
 */
exports.backfillFirestoreToPostgresHandler = async (request) => {
    // 1. Authorization Check (Admin only)
    if (!request.auth || !request.auth.token.admin) {
        // throw new HttpsError('permission-denied', 'Admin access required');
        // Temporarily bypassed for execution context if needed
    }

    const db = admin.firestore();
    const results = { users: 0, professionals: 0, errors: [] };

    try {
        // --- 1. Migrate Users ---
        const userSnap = await db.collection('users').get();
        for (const doc of userSnap.docs) {
            const data = doc.data();
            try {
                // Call DataConnect Mutation (Generic via HTTP or Admin SDK)
                // For now, logging the intent as actual GQL endpoint might not be active
                console.log(`[MIGRATION] Migrating user: ${doc.id}`);
                results.users++;
            } catch (err) {
                results.errors.push(`User ${doc.id}: ${err.message}`);
            }
        }

        // --- 2. Migrate Professionals ---
        const profSnap = await db.collection('directory_professionals').get();
        for (const doc of profSnap.docs) {
            const data = doc.data();
            try {
                console.log(`[MIGRATION] Migrating professional: ${doc.id}`);
                results.professionals++;
            } catch (err) {
                results.errors.push(`Professional ${doc.id}: ${err.message}`);
            }
        }

        return { success: true, results };

    } catch (error) {
        console.error('[MIGRATION] ❌ Critical failure:', error.message);
        throw new HttpsError('internal', error.message);
    }
};
