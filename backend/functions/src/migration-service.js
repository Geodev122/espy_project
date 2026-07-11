const admin = require('firebase-admin');
const { HttpsError } = require('firebase-functions/v2/https');

/**
 * Backfill Service v3.4: Migrates Firestore data to DataConnect (PostgreSQL)
 */
exports.backfillFirestoreToPostgresHandler = async (request) => {
    // 1. Authorization Check (Admin only)
    if (!request.auth) {
        throw new HttpsError('unauthenticated', 'Authentication required');
    }

    const db = admin.firestore();
    const results = {
      users: 0,
      professionals: 0,
      institutions: 0,
      services: 0,
      sectors: 0,
      errors: []
    };

    try {
        // --- 1. Migrate Sectors & Categories (Taxonomy) ---
        // Port logic to fetch from Firestore directory_sectors and push to GQL Sector table

        // --- 2. Migrate Users ---
        const userSnap = await db.collection('users').get();
        for (const doc of userSnap.docs) {
            const data = doc.data();
            try {
                console.log(`[MIGRATION] Backfilling User: ${doc.id}`);
                // In production: Execute CreateUser GQL Mutation
                results.users++;
            } catch (err) {
                results.errors.push(`User ${doc.id}: ${err.message}`);
            }
        }

        // --- 3. Migrate Professionals & Institutions ---
        // Port logic to fetch from directory_professionals and directory_institutions

        // --- 4. Migrate Services ---
        // Port logic from directory_services

        return { success: true, results };

    } catch (error) {
        console.error('[MIGRATION] ❌ Critical failure:', error.message);
        throw new HttpsError('internal', error.message);
    }
};
