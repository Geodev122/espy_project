/**
 * Hope Support Suite — Directory Cloud Functions (V5.0 - DECONSTRUCTED)
 * ═══════════════════════════════════════════════════════════════
 * 
 * Express app now strictly handles legacy webhooks and complex external syncs.
 * All other logic moved to direct Firestore SDK or discrete onCall functions.
 */

const functions = require('firebase-functions/v2');
const admin = require('firebase-admin');
const express = require('express');
const axios = require('axios');

// Import Fulfillment Logic
const { fulfillMembership } = require('./src/membership-fulfillment');

const db = admin.firestore();
const rtdb = admin.database();

const app = express();
app.use(express.json({ limit: '50mb' }));

// ============================================================
// CORS MIDDLEWARE
// ============================================================
const ALLOWED_ORIGINS = [
  'https://support.hopebearer-award.com',
  'https://hopebearer-award.com',
  'https://www.hopebearer-award.com',
  'https://hope-bearer-award-support.web.app',
  'https://hope-bearer-award-support.firebaseapp.com',
  'http://localhost:5173',
  'http://localhost:4173',
];

app.use((req, res, next) => {
  const origin = req.headers.origin;
  if (origin && ALLOWED_ORIGINS.includes(origin)) {
    res.set('Access-Control-Allow-Origin', origin);
  } else {
    res.set('Access-Control-Allow-Origin', ALLOWED_ORIGINS[0]);
  }
  res.set('Vary', 'Origin');
  res.set('Access-Control-Allow-Methods', 'GET, POST, PUT, PATCH, DELETE, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type, Authorization');
  if (req.method === 'OPTIONS') return res.status(204).send('');
  next();
});

// ============================================================
// LEGACY WEBHOOKS & CALLBACKS
// ============================================================

/**
 * WhishPay Membership Success Webhook
 * Used for server-to-server activation after payment.
 */
app.get('/api/whishpay/membership/success', async (req, res) => {
  try {
    const { membershipId, packageId, externalId } = req.query;
    console.log(`[WHISH-WEBHOOK] Activating ${membershipId} for package ${packageId}`);

    await fulfillMembership(membershipId, packageId, {
      transactionId: `whishpay_${externalId}`,
      method: 'whishpay'
    });

    res.status(200).send('Activated');
  } catch (error) {
    console.error('[WHISH-WEBHOOK] Error:', error.message);
    res.status(500).send('Failed');
  }
});

/**
 * Master Metadata Sync (CSV/External Source)
 * Complex logic required for bulk validation and atomic writes.
 */
app.post("/api/admin/sync/metadata", async (req, res) => {
  // Ported to secure onCall function in future step if needed
  res.status(501).send("Use direct Firestore SDK or onCall functions for data management.");
});

// Remaining GET endpoints are now DEPRECATED.
// The PWA and Flutter app use direct Firestore listeners.

app.use((req, res) => {
  res.status(410).json({
    error: "Endpoint Deprecated",
    message: "This Express API is deconstructed. Use direct Firestore SDK or modular Cloud Functions."
  });
});

module.exports = { app };
