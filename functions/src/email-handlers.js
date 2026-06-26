const functions = require('firebase-functions/v1');
const functionsV2 = require('firebase-functions/v2');
const admin = require('firebase-admin');

const getTransporter = () => {
    const nodemailer = require('nodemailer');
    return nodemailer.createTransport({
        service: 'gmail',
        auth: {
            user: 'geo.elnajjar@gmail.com',
            pass: process.env.GMAIL_APP_PASSWORD
        },
        pool: true,
        maxConnections: 5,
        maxMessages: 100,
        rateDelta: 1000,
        rateLimit: 5
    });
};

exports.getTransporter = getTransporter;

exports.sendEmailHandler = async (snapshot, context) => {
    const mailData = snapshot.val();
    const mailId = context.params.mailId;
    const rtdb = admin.database();

    console.log('=== EMAIL TRIGGER FIRED ===', mailId);

    try {
        if (!mailData.to) throw new Error('Missing recipient');

        const toAddresses = Array.isArray(mailData.to) ? mailData.to : [mailData.to];
        let ccAddresses = mailData.cc ? (Array.isArray(mailData.cc) ? mailData.cc : [mailData.cc]) : [];

        if (!ccAddresses.includes('ceo@hopebearer-award.com')) {
            ccAddresses.push('ceo@hopebearer-award.com');
        }

        const mailOptions = {
            from: '"Hope Bearer Award" <geo.elnajjar@gmail.com>',
            to: toAddresses.join(', '),
            cc: ccAddresses.filter(e => e && e.includes('@')).join(', '),
            subject: mailData.message.subject,
            html: mailData.message.html,
            text: mailData.message.text || mailData.message.html.replace(/<[^>]*>/g, ''),
        };

        const info = await getTransporter().sendMail(mailOptions);

        await snapshot.ref.update({
            status: 'sent',
            sentAt: admin.database.ServerValue.TIMESTAMP,
            messageId: info.messageId
        });

        if (mailData.bookingId) {
            await rtdb.ref(`seatBookings/${mailData.bookingId}`).update({
                emailStatus: 'sent',
                emailSentAt: admin.database.ServerValue.TIMESTAMP
            });
        }

        return { success: true };
    } catch (error) {
        console.error('❌ EMAIL FAILED', error.message);
        await snapshot.ref.update({
            status: 'error',
            error: error.message,
            erroredAt: admin.database.ServerValue.TIMESTAMP
        });
        return { success: false, error: error.message };
    }
};

exports.testEmailHandler = async (request) => {
    const { to, subject, message } = request.data;
    try {
        const info = await getTransporter(process).sendMail({
            from: '"Hope Bearer Award" <geo.elnajjar@gmail.com>',
            to: to || 'rosaryco.cg@gmail.com',
            subject: subject || 'Test Email',
            html: message || '<h1>Test</h1>'
        });
        return { success: true, messageId: info.messageId };
    } catch (error) {
        throw new functionsV2.https.HttpsError('internal', error.message);
    }
};
