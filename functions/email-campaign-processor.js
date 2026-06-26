const admin = require('firebase-admin');

/**
 * Email Campaign Queue Processor Handler
 */
exports.processEmailQueueHandler = async (snapshot, context, getTransporter) => {
    const emailId = context.params.emailId;
    const emailData = snapshot.val();
    const rtdb = admin.database();

    console.log(`[EMAIL_QUEUE] Processing email ${emailId}`);

    try {
        if (!emailData.to || !emailData.subject || !emailData.htmlContent) {
            throw new Error('Missing fields');
        }

        const mailOptions = {
            from: emailData.from || 'Hope Bearer Award <ceo@hopebearer-award.com>',
            to: emailData.to,
            subject: emailData.subject,
            html: emailData.htmlContent,
        };

        const transporter = getTransporter();
        await transporter.sendMail(mailOptions);

        await snapshot.ref.update({
            status: 'sent',
            sentAt: admin.database.ServerValue.TIMESTAMP
        });

        if (emailData.campaignId) {
            await rtdb.ref(`emailCampaigns/${emailData.campaignId}`).update({
                sentCount: admin.database.ServerValue.increment(1),
                updatedAt: admin.database.ServerValue.TIMESTAMP
            });
        }

        return true;
    } catch (error) {
        console.error(`[EMAIL_QUEUE] Error:`, error);
        await snapshot.ref.update({
            status: 'failed',
            error: error.message
        });
        return false;
    }
};
