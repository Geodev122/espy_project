const admin = require("firebase-admin");
admin.initializeApp();

const functions = require('firebase-functions/v1');
const functionsV2 = require('firebase-functions/v2');

/**
 * ESPY PROTOCOL — CORE BACKEND
 * ────────────────────────────────────────────────────────────
 */

// --- Directory API ---
exports.directoryApi = functionsV2.https.onRequest(
    { timeoutSeconds: 120, memory: '512MiB', region: 'us-central1' },
    (req, res) => {
        const { app: directoryApp } = require('./directory-functions');
        return directoryApp(req, res);
    }
);

// --- Membership & Payments (v2) ---
exports.initiateMembershipPayment = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { initiateMembershipPaymentHandler } = require('./subdomain-whishpay');
    return initiateMembershipPaymentHandler(request);
});

exports.verifyWhishPayment = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { verifyWhishPaymentHandler } = require('./subdomain-whishpay');
    return verifyWhishPaymentHandler(request);
});

exports.processGooglePayPayment = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { processGooglePayPaymentHandler } = require('./googlepay-functions');
    return processGooglePayPaymentHandler(request);
});

exports.spendTokens = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { spendTokensHandler } = require('./src/token-functions');
    return spendTokensHandler(request);
});

exports.redeemRechargeCode = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { redeemRechargeCodeHandler } = require('./src/token-functions');
    return redeemRechargeCodeHandler(request);
});

exports.finalizeProfileApproval = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { finalizeProfileApprovalHandler } = require('./profile-functions');
    return finalizeProfileApprovalHandler(request);
});

// --- DataConnect Migration ---
exports.backfillFirestoreToPostgres = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { backfillFirestoreToPostgresHandler } = require('./src/migration-service');
    return backfillFirestoreToPostgresHandler(request);
});

// --- Legacy Webhooks (v2) ---
exports.membershipPaymentSuccess = functionsV2.https.onRequest({ region: 'us-central1' }, async (req, res) => {
    const { membershipPaymentSuccessHandler } = require('./subdomain-whishpay');
    return membershipPaymentSuccessHandler(req, res);
});

exports.membershipPaymentFailure = functionsV2.https.onRequest({ region: 'us-central1' }, async (req, res) => {
    const { membershipPaymentFailureHandler } = require('./subdomain-whishpay');
    return membershipPaymentFailureHandler(req, res);
});

// --- Email System ---
exports.sendEmail = functions.database.ref('/mail/{mailId}')
    .onCreate(async (snapshot, context) => {
        const { sendEmailHandler } = require('./src/email-handlers');
        return sendEmailHandler(snapshot, context);
    });

exports.testEmail = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { testEmailHandler } = require('./src/email-handlers');
    return testEmailHandler(request);
});

// --- Email Campaign Queue ---
exports.processEmailQueue = functions.database.ref('/emailCampaigns/{campaignId}/queue/{queueId}')
    .onCreate(async (snapshot, context) => {
        const { processEmailQueueHandler } = require('./email-campaign-processor');
        const { getTransporter } = require('./src/email-handlers');
        return processEmailQueueHandler(snapshot, context, getTransporter);
    });

// --- Hope Bearer Award (WhishPay) ---
exports.initiateWhishPayment = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { initiateWhishPaymentHandler } = require('./whishpay-functions');
    return initiateWhishPaymentHandler(request);
});

exports.whishSuccessCallback = functionsV2.https.onRequest({ region: 'us-central1' }, async (req, res) => {
    const { whishSuccessCallbackHandler } = require('./whishpay-functions');
    return whishSuccessCallbackHandler(req, res);
});

exports.whishFailureCallback = functionsV2.https.onRequest({ region: 'us-central1' }, async (req, res) => {
    const { whishFailureCallbackHandler } = require('./whishpay-functions');
    return whishFailureCallbackHandler(req, res);
});

// --- Ticket System ---
exports.autoGenerateTickets = functions.firestore.document('seatBookings/{bookingId}')
    .onUpdate(async (change, context) => {
        const { autoGenerateTicketsHandler } = require('./src/ticket-handlers');
        return autoGenerateTicketsHandler(change, context);
    });

exports.resendBookingConfirmation = functionsV2.https.onCall({ region: 'us-central1' }, async (request) => {
    const { resendBookingConfirmationHandler } = require('./src/ticket-handlers');
    return resendBookingConfirmationHandler(request);
});

// --- Announcements ---
exports.onAnnouncementApproved = functions.firestore.document('directory_announcements/{announcementId}')
    .onUpdate(async (change, context) => {
        const announcementFunctions = require('./announcement-functions');
        return announcementFunctions.onAnnouncementApprovedHandler(change, context);
    });

// --- Maintenance ---
exports.checkExpiringSubscriptions = functions.pubsub.schedule('every 24 hours').onRun((context) => { 
    console.log('Check Expiring Subscriptions (Placeholder)');
    return null;
});
