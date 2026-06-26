const functions = require('firebase-functions');
const cors = require('cors')({
  origin: [
    'https://hope-bearer-award.web.app',
    'https://hope-bearer-award-support.web.app',
    'https://hopebearer-award.com',
    'http://localhost:3000',
    'http://localhost:5173'
  ],
  credentials: true
});

// Simple proxy function to handle CORS for membership payments
exports.membershipPaymentProxy = functions.https.onRequest(async (req, res) => {
  return cors(req, res, async () => {
    if (req.method === 'OPTIONS') {
      res.status(200).send();
      return;
    }

    if (req.method !== 'POST') {
      res.status(405).json({ error: 'Method not allowed' });
      return;
    }

    try {
      // Import the existing function
      const whishpay = require('./whishpay-functions');

      // Call the callable function directly with proper context
      const mockContext = { 
        auth: null,
        app: functions.app(), 
        eventId: 'proxy-' + Date.now(),
        eventType: 'https://googleapis.com/firebase/functions/v1/projects/hope-bearer-award/functions/membershipPaymentProxy',
        resource: 'functions',
        timestamp: new Date().toISOString()
      };

      const result = await whishpay.initiateMembershipPayment(req.body, mockContext);

      res.json(result);
    } catch (error) {
      console.error('Proxy error:', error);
      res.status(500).json({ 
        error: error.message || 'Internal server error',
        details: error.details || {}
      });
    }
  });
});