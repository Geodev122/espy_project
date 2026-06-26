/**
 * Directory WhishPay Functions - Dedicated for Hope Support Suite Subdomain
 * Handles membership payments for professionals and institutions
 */
const functions = require('firebase-functions');
const admin = require('firebase-admin');
const axios = require('axios');

// Get Firestore instance
// Get Database instance
const rtdb = admin.database();

function getWhishPayConfig() {
  // Try environment variables first, fall back to deprecated functions.config()
  const envConfig = {
    channel: process.env.WHISHPAY_CHANNEL,
    secret: process.env.WHISHPAY_SECRET,
    environment: process.env.WHISHPAY_ENVIRONMENT,
    website_url: process.env.WHISHPAY_WEBSITE_URL,
    base_url: process.env.WHISHPAY_BASE_URL,
    success_url: process.env.WHISHPAY_SUCCESS_URL,
    cancel_url: process.env.WHISHPAY_CANCEL_URL,
  };

  // Fallback to legacy config if env vars not available
  const legacyConfig = functions.config().whishpay || {};
  const config = {
    channel: envConfig.channel || legacyConfig.channel || '',
    secret: envConfig.secret || legacyConfig.secret || '',
    environment: envConfig.environment || legacyConfig.environment || 'sandbox',
    website_url: envConfig.website_url || legacyConfig.website_url || 'hope-bearer-award-support.web.app',
    base_url: envConfig.base_url || legacyConfig.base_url || 'https://hope-bearer-award-support.web.app',
    success_url: envConfig.success_url || legacyConfig.success_url || 'https://hope-bearer-award-support.web.app/#/directory/payment/return?status=success',
    cancel_url: envConfig.cancel_url || legacyConfig.cancel_url || 'https://hope-bearer-award-support.web.app/#/directory/payment/return?status=cancelled',
  };

  const isProduction = config.environment !== 'sandbox';
  return {
    apiUrl: isProduction ? 'https://api.whish.money/itel-service/api' : 'https://api.sandbox.whish.money/itel-service/api',
    channel: config.channel,
    secret: config.secret,
    websiteUrl: config.website_url,
    userAgent: 'Whish/1.0 (https://hope-bearer-award-support.web.app; support@hopebearer-award.com)',
    baseUrl: config.base_url,
    successUrl: config.success_url,
    cancelUrl: config.cancel_url,
  };
}

function getWhishHeaders() {
  const config = getWhishPayConfig();
  return {
    'Content-Type': 'application/json',
    'channel': config.channel,
    'secret': config.secret,
    'websiteUrl': config.websiteUrl,
    'User-Agent': config.userAgent,
  };
}

/**
 * Initiate Directory Membership Payment
 * Specifically designed for Hope Support Suite subdomain membership payments
 */
exports.initiateDirectoryPayment = functions.https.onCall(async (data, context) => {
  console.log('[Directory WhishPay] Payment initiation request:', JSON.stringify(data, null, 2));
  
  const config = getWhishPayConfig();
  if (!config.channel || !config.secret) {
    throw new functions.https.HttpsError('failed-precondition', 'WhishPay not configured');
  }

  // Validate required fields for membership payments
  if (!data.amount || !data.packageId || !data.customerEmail) {
    throw new functions.https.HttpsError('invalid-argument', 'Missing required fields: amount, packageId, customerEmail');
  }

  const {
    amount,
    currency = 'USD',
    customerEmail,
    customerName,
    customerPhone = '',
    packageId,
    packageName = 'Membership Package',
    membershipType = 'professional',
    professionalId,
    institutionId,
    successUrl,
    cancelUrl
  } = data;

  try {
    // WhishPay requires externalId as a NUMBER (not string).
    // IMPORTANT: Date.now() is too large for some 32-bit systems/indices.
    // We'll use a 32-bit safe integer (last 9 digits of timestamp + random).
    const externalId = parseInt(Date.now().toString().slice(-9)) + Math.floor(Math.random() * 1000);
    const uid = professionalId || institutionId;
    
    // Build callback URLs for Whish server notifications (GET requests)
    const projectId = process.env.GCLOUD_PROJECT || 'hope-bearer-award';
    const functionRegion = 'us-central1';
    const callbackBaseUrl = `https://${functionRegion}-${projectId}.cloudfunctions.net`;

    // Build redirect URLs for user browser after payment
    const successRedirect = successUrl || `${config.baseUrl}/#/directory/payment/return?status=success&professional_id=${uid}&package_id=${packageId}&role=${membershipType}`;
    const failureRedirect = cancelUrl || `${config.baseUrl}/#/directory/payment/return?status=cancelled&professional_id=${uid}&role=${membershipType}`;

    // Whish API payload
    const payload = {
      amount: Number(amount).toFixed(2),
      currency: currency,
      invoice: `${packageName} - ${customerName}`,
      externalId: Number(externalId),
      // Server callbacks (Whish calls these via GET)
      successCallbackUrl: `${callbackBaseUrl}/directoryPaymentCallback?uid=${uid}&type=${membershipType}&packageId=${packageId}&externalId=${externalId}&status=success`,
      failureCallbackUrl: `${callbackBaseUrl}/directoryPaymentCallback?uid=${uid}&type=${membershipType}&packageId=${packageId}&externalId=${externalId}&status=failure`,
      // User redirects (browser redirects after payment)
      successRedirectUrl: successRedirect,
      failureRedirectUrl: failureRedirect,
    };

    console.log('[Directory WhishPay] Payload:', JSON.stringify(payload, null, 2));

    // Call Whish API
    const response = await axios.post(`${config.apiUrl}/payment/whish`, payload, {
      headers: getWhishHeaders(),
      timeout: 30000
    });

    console.log('[Directory WhishPay] Response:', JSON.stringify(response.data, null, 2));

    const { collectUrl, externalId: responseExternalId, invoice } = response.data;

    if (!collectUrl) {
      throw new functions.https.HttpsError('internal', 'Invalid response from payment provider');
    }

    // Store pending payment record in RTDB
    await rtdb.ref(`directory_pending_payments/${externalId}`).set({
      externalId: responseExternalId || externalId,
      uid: uid,
      packageId: packageId,
      packageName: packageName,
      membershipType: membershipType,
      amount: parseFloat(amount),
      currency: currency,
      customerEmail: customerEmail,
      customerName: customerName,
      customerPhone: customerPhone,
      status: 'pending',
      collectUrl: collectUrl,
      invoice: invoice,
      created_at: admin.database.ServerValue.TIMESTAMP
    });

    console.log('[Directory WhishPay] Pending payment record created in RTDB:', externalId);

    return {
      success: true,
      collectUrl: collectUrl,
      externalId: responseExternalId || externalId,
    };

  } catch (error) {
    console.error('[Directory WhishPay] Error:', error);
    
    let errorMessage = 'Payment initiation failed';
    if (error.response?.data?.message) {
      errorMessage = error.response.data.message;
    } else if (error.message) {
      errorMessage = error.message;
    }

    throw new functions.https.HttpsError('internal', errorMessage, {
      details: error.response?.data || {},
      originalError: error.message
    });
  }
});

/**
 * Directory Payment Callback Handler
 * Handles success/failure callbacks from Whish for membership payments
 */
exports.directoryPaymentCallback = functions.https.onRequest(async (req, res) => {
  console.log('[Directory WhishPay] Callback received:', JSON.stringify(req.query, null, 2));

  // Handle CORS
  res.set('Access-Control-Allow-Origin', '*');
  res.set('Access-Control-Allow-Methods', 'GET, POST, OPTIONS');
  res.set('Access-Control-Allow-Headers', 'Content-Type');

  if (req.method === 'OPTIONS') {
    return res.status(204).send('');
  }

  try {
    const { uid, type, packageId, externalId, status } = req.query;

    if (!uid || !externalId || !status) {
      console.error('[Directory WhishPay] Missing required parameters');
      return res.status(400).send('Missing required parameters');
    }

    // Update pending payment status in RTDB
    await rtdb.ref(`directory_pending_payments/${externalId}`).update({
      status: status === 'success' ? 'completed' : 'failed',
      callback_received_at: admin.database.ServerValue.TIMESTAMP
    });

    if (status === 'success') {
      console.log('[Directory WhishPay] Processing successful payment for:', uid);
      
      // Get package details from RTDB
      const packageSnap = await rtdb.ref(`directory_packages/${packageId}`).once('value');
      if (!packageSnap.exists()) {
        console.error(`[Directory WhishPay] Package not found: ${packageId}`);
        return res.status(404).send('Package not found');
      }

      const packageData = packageSnap.val();
      const durationDays = packageData.duration_days || 30;
      
      // Calculate subscription end date
      const now = new Date();
      const endDate = new Date(now.getTime() + (durationDays * 24 * 60 * 60 * 1000));

      // Create or update subscription in RTDB
      await rtdb.ref(`directory_subscriptions/${uid}`).set({
        user_id: uid,
        package_id: packageId,
        package_name: packageData.name || 'Unknown Package',
        status: 'active',
        start_date: admin.database.ServerValue.TIMESTAMP,
        end_date: endDate.getTime(),
        payment_external_id: externalId,
        features: packageData.features || [],
        listing_limit: packageData.listing_limit || 0,
        profile_visibility: packageData.profile_visibility || false,
        service_visibility: packageData.service_visibility || false,
        service_visibility_count: packageData.service_visibility_count || 0,
        updated_at: admin.database.ServerValue.TIMESTAMP
      });

      // Update visibility if applicable in RTDB
      if (packageData.profile_visibility) {
        await rtdb.ref(`directory_visibility/${uid}`).set({
          user_id: uid,
          is_visible: true,
          subscription_package_id: packageId,
          activated_at: admin.database.ServerValue.TIMESTAMP
        });
      }

      console.log(`[Directory WhishPay] Subscription activated in RTDB for user ${uid}`);
    }

    res.status(200).send('OK');

  } catch (error) {
    console.error('[Directory WhishPay] Callback error:', error);
    res.status(500).send('Internal server error');
  }
});