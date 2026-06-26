const admin = require('firebase-admin');

/**
 * Cloud Function Trigger Logic
 */
exports.onAnnouncementApprovedHandler = async (change, context) => {
    const beforeData = change.before.data();
    const afterData = change.after.data();
    const announcementId = context.params.announcementId;

    if (!beforeData || !afterData) {
      console.log('[Announcements] No before/after data found');
      return null;
    }

    // Only trigger when status changes to 'approved'
    if (beforeData.status === afterData.status || afterData.status !== 'approved') {
      return null;
    }

    console.log(`[Announcements] Triggered for announcementId: ${announcementId} (Status: approved)`);

    const db = admin.firestore();
    const title = afterData.title || 'New Announcement';
    const body = afterData.body || 'An update has been posted in the directory.';
    const imageUrl = afterData.image_url || afterData.imageUrl || '';
    const authorId = afterData.author_id || afterData.authorId;
    const authorName = afterData.author_name || afterData.authorName || 'Hope Directory';

    try {
      // 1. Fetch all visitors in directory_visitors
      const visitorsSnap = await db.collection('directory_visitors').get();
      console.log(`[Announcements] Found ${visitorsSnap.size} visitors to notify`);

      const visitorIds = [];
      const fcmTokens = [];

      visitorsSnap.forEach(docSnap => {
        const data = docSnap.data();
        const visitorId = docSnap.id;
        visitorIds.push(visitorId);

        // Collect FCM tokens (supporting fcmToken, pushToken, token, fcm_token)
        const token = data.fcmToken || data.pushToken || data.token || data.fcm_token;
        if (token && typeof token === 'string' && token.trim() !== '') {
          fcmTokens.push(token);
        }
      });

      // Remove duplicate tokens
      const uniqueTokens = [...new Set(fcmTokens)];
      console.log(`[Announcements] Unique FCM tokens found: ${uniqueTokens.length}`);

      // 2. Create in-app notifications for each visitor (fan-out)
      let batch = db.batch();
      let operationCount = 0;
      const batches = [];

      for (const visitorId of visitorIds) {
        const notifRef = db.collection('directory_visitor_notifications')
          .doc(visitorId)
          .collection('notifications')
          .doc();

        batch.set(notifRef, {
          type: 'announcement',
          announcement_id: announcementId,
          title: title,
          body: body,
          image_url: imageUrl,
          author_name: authorName,
          is_read: false,
          created_at: admin.firestore.FieldValue.serverTimestamp()
        });

        operationCount++;
        if (operationCount >= 400) {
          batches.push(batch);
          batch = db.batch();
          operationCount = 0;
        }
      }

      if (operationCount > 0) {
        batches.push(batch);
      }

      console.log(`[Announcements] Committing ${batches.length} notification batches...`);
      await Promise.all(batches.map(b => b.commit()));
      console.log(`[Announcements] Successfully wrote visitor in-app notifications`);

      // 3. Send FCM push notifications if tokens are available
      if (uniqueTokens.length > 0) {
        const payload = {
          notification: {
            title: title,
            body: body,
          },
          data: {
            announcementId: announcementId,
            type: 'announcement',
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
          }
        };

        if (imageUrl) payload.notification.imageUrl = imageUrl;

        try {
          const response = await admin.messaging().sendEachForMulticast({
            tokens: uniqueTokens,
            ...payload
          });
          console.log(`[Announcements] FCM multicast success: ${response.successCount} sent`);
        } catch (fcmErr) {
          console.error('[Announcements] Failed sending FCM multicast:', fcmErr);
        }
      }

      // 4. Notify the author
      if (authorId) {
        await db.collection('directory_notifications').add({
          user_id: authorId,
          title: 'Announcement Approved',
          body: `Your announcement "${title}" has been approved.`,
          type: 'announcement_approval',
          announcement_id: announcementId,
          is_read: false,
          created_at: admin.firestore.FieldValue.serverTimestamp()
        });
      }

      // 5. Update status
      await change.after.ref.update({
        published_at: admin.firestore.FieldValue.serverTimestamp()
      });

    } catch (error) {
      console.error(`[Announcements] Error:`, error);
    }

    return null;
};
