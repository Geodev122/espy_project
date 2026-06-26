const admin = require("firebase-admin");

function getWhishPayConfig() {
  return {
    apiUrl: process.env.WHISH_API_URL || 'https://api.whish.money/itel-service/api',
    channel: process.env.WHISHPAY_CHANNEL || process.env.WHISH_CHANNEL || '',
    secret: process.env.WHISHPAY_SECRET || process.env.WHISH_SECRET || '',
    websiteUrl: process.env.WHISHPAY_WEBSITE_URL || 'hopebearer-award.com',
    userAgent: 'Whish/1.0 (https://whish.money; support@whish.money)',
    baseUrl: process.env.SUPPORT_BASE_URL || 'https://hope-bearer-award-support.web.app',
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

async function initiateMembershipPaymentHandler(request) {
  const axios = require('axios');
  const config = getWhishPayConfig();
  const { membershipId, packageId, amount, customerEmail, membershipType } = request.data;
  const numericAmount = Number(amount);

  if (!config.channel || !config.secret) return { error: 'Not configured' };

  try {
    const externalId = parseInt(Date.now().toString().slice(-9)) + Math.floor(Math.random() * 1000);
    const callbackBaseUrl = `https://us-central1-${process.env.GCLOUD_PROJECT || 'hope-bearer-award'}.cloudfunctions.net`;

    const whishPayload = {
      amount: Number(numericAmount.toFixed(2)),
      currency: 'USD',
      invoice: `Membership recharge`,
      externalId: Number(externalId),
      successCallbackUrl: `${callbackBaseUrl}/membershipPaymentSuccess?membershipId=${membershipId}&packageId=${packageId}&externalId=${externalId}&type=${membershipType}`,
      failureCallbackUrl: `${callbackBaseUrl}/membershipPaymentFailure?membershipId=${membershipId}&packageId=${packageId}&externalId=${externalId}&type=${membershipType}`,
      successRedirectUrl: `${config.baseUrl}/#/directory/payment/return?status=success`,
      failureRedirectUrl: `${config.baseUrl}/#/directory/payment/return?status=failed`,
    };

    const response = await axios.post(`${config.apiUrl}/payment/whish`, whishPayload, { headers: getWhishHeaders(), timeout: 30000 });

    if (response.data && response.data.status === true) {
      await admin.database().ref(`directory_membership_transactions/${externalId}`).set({
        membershipId, packageId, amount: numericAmount, status: 'pending', createdAt: admin.database.ServerValue.TIMESTAMP,
      });
      return { success: true, collectUrl: response.data.data.collectUrl, externalId };
    }
    throw new Error('API Error');
  } catch (error) {
    return { error: error.message };
  }
}

async function membershipPaymentSuccessHandler(req, res) {
  const { externalId, membershipId, packageId } = req.query;
  const { fulfillMembership } = require('./src/membership-fulfillment');
  try {
    await fulfillMembership(membershipId, packageId, { transactionId: `whishpay_${externalId}`, method: 'whishpay' });
    await admin.database().ref(`directory_membership_transactions/${externalId}`).update({ status: 'completed', paidAt: admin.database.ServerValue.TIMESTAMP });
    res.status(200).send('OK');
  } catch (e) {
    res.status(500).send('Error');
  }
}

async function membershipPaymentFailureHandler(req, res) {
  const { externalId } = req.query;
  if (externalId) await admin.database().ref(`directory_membership_transactions/${externalId}`).update({ status: 'failed' });
  res.status(200).send('OK');
}

async function verifyWhishPaymentHandler(request) {
  const { transactionId } = request.data;
  const axios = require('axios');
  const config = getWhishPayConfig();
  const externalId = transactionId.replace('whishpay_', '');

  try {
    const response = await axios.post(`${config.apiUrl}/payment/collect/status`, { currency: 'USD', externalId: Number(externalId) }, { headers: getWhishHeaders(), timeout: 15000 });
    if (response.data && response.data.status === true) {
      return { success: true, status: response.data.data?.collectStatus };
    }
    return { success: false };
  } catch (e) {
    return { success: false };
  }
}

module.exports = {
  initiateMembershipPaymentHandler,
  membershipPaymentSuccessHandler,
  membershipPaymentFailureHandler,
  verifyWhishPaymentHandler
};
