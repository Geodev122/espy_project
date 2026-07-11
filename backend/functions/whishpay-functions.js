const admin = require('firebase-admin');

function getWhishPayConfig() {
  const envConfig = {
    channel: process.env.WHISHPAY_CHANNEL,
    secret: process.env.WHISHPAY_SECRET,
    environment: process.env.WHISHPAY_ENVIRONMENT,
    website_url: process.env.WHISHPAY_WEBSITE_URL,
    base_url: process.env.WHISHPAY_BASE_URL,
  };

  const isProduction = envConfig.environment !== 'sandbox';
  return {
    apiUrl: isProduction ? 'https://api.whish.money/itel-service/api' : 'https://api.sandbox.whish.money/itel-service/api',
    channel: envConfig.channel || '',
    secret: envConfig.secret || '',
    websiteUrl: envConfig.website_url || 'hopebearer-award.com',
    userAgent: 'Whish/1.0 (https://whish.money; support@whish.money)',
    baseUrl: envConfig.base_url || 'https://hopebearer-award.com',
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

exports.initiateWhishPaymentHandler = async (request) => {
  console.log('=== WHISH PAYMENT INITIATION (v1.4) ===');
  const data = request.data;
  const config = getWhishPayConfig();
  const rtdb = admin.database();
  const axios = require('axios');

  if (!config.channel || !config.secret) throw new Error('Not configured');

  const { bookingId, confirmationCode, amount, contribution } = data;

  try {
    const externalId = Date.now();
    const totalAmount = parseFloat(amount) + parseFloat(contribution || 0);
    const callbackBaseUrl = `https://us-central1-${process.env.GCLOUD_PROJECT || 'hope-bearer-award'}.cloudfunctions.net`;

    const whishPayload = {
      amount: totalAmount.toString(),
      currency: 'USD',
      invoice: `Hope Bearer Award (${confirmationCode})`,
      externalId: externalId,
      successCallbackUrl: `${callbackBaseUrl}/whishSuccessCallback?bookingId=${bookingId}&code=${confirmationCode}&externalId=${externalId}`,
      failureCallbackUrl: `${callbackBaseUrl}/whishFailureCallback?bookingId=${bookingId}&code=${confirmationCode}&externalId=${externalId}`,
      successRedirectUrl: `${config.baseUrl}/#/booking/payment-success?code=${confirmationCode}&txn=${externalId}`,
      failureRedirectUrl: `${config.baseUrl}/#/booking/payment-failed?code=${confirmationCode}&error=payment_declined`,
    };

    const response = await axios.post(`${config.apiUrl}/payment/whish`, whishPayload, { headers: getWhishHeaders(), timeout: 30000 });

    if (response.data && response.data.status === true && response.data.data?.collectUrl) {
      const collectUrl = response.data.data.collectUrl;
      await rtdb.ref(`paymentTransactions/${externalId}`).set({
        bookingId, confirmationCode, amount: totalAmount, externalId, status: 'pending', collectUrl, createdAt: admin.database.ServerValue.TIMESTAMP,
      });
      await rtdb.ref(`seatBookings/${bookingId}`).update({
        paymentExternalId: externalId, paymentCollectUrl: collectUrl, updatedAt: admin.database.ServerValue.TIMESTAMP,
      });
      return { success: true, collectUrl, externalId };
    }
    throw new Error(response.data?.dialog?.message || 'API Error');
  } catch (error) {
    console.error('[WHISH] Error:', error.message);
    throw new Error(error.message);
  }
};

exports.whishSuccessCallbackHandler = async (req, res) => {
  console.log('=== WHISH SUCCESS CALLBACK ===');
  const { bookingId, externalId } = req.query;
  const config = getWhishPayConfig();
  const rtdb = admin.database();
  const axios = require('axios');

  try {
    const statusResponse = await axios.post(`${config.apiUrl}/payment/collect/status`, { currency: 'USD', externalId: parseInt(externalId) }, { headers: getWhishHeaders(), timeout: 15000 });
    const collectStatus = statusResponse.data?.data?.collectStatus;

    if (collectStatus === 'success') {
      await rtdb.ref(`paymentTransactions/${externalId}`).update({ status: 'success', completedAt: admin.database.ServerValue.TIMESTAMP });
      await rtdb.ref(`seatBookings/${bookingId}`).update({ paymentStatus: 'validated', status: 'confirmed', paymentCompletedAt: admin.database.ServerValue.TIMESTAMP });
      return res.status(200).send('OK');
    }
    return res.status(400).send('Not success');
  } catch (error) {
    return res.status(500).send('Error');
  }
};

exports.whishFailureCallbackHandler = async (req, res) => {
  const { bookingId, externalId, error: errorMsg } = req.query;
  const rtdb = admin.database();
  if (externalId) await rtdb.ref(`paymentTransactions/${externalId}`).update({ status: 'failed', errorMessage: errorMsg });
  if (bookingId) await rtdb.ref(`seatBookings/${bookingId}`).update({ paymentStatus: 'rejected' });
  return res.status(200).send('OK');
};
