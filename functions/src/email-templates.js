const EVENT_DATE = 'March 13, 2027';
const EVENT_TIME = '7:00 PM';
const EVENT_DATETIME = `${EVENT_DATE} at ${EVENT_TIME}`;
const WHISH_LOGO_URL = 'https://firebasestorage.googleapis.com/v0/b/hope-bearer-award.firebasestorage.app/o/Site%20images%2F676d32a11708f11b333c681b_Whish%20Logo.svg?alt=media&token=5f3718a8-5da8-4dc5-b81b-da3a8c106ca5';

function buildPaymentLinkEmailHTML(data) {
  const { customerName, confirmationCode, amount, contribution, paymentLink, expiryDate } = data;
  const totalAmount = amount + contribution;

  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Complete Your Payment - Hope Bearer Award</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Georgia', serif; background-color: #F5F2EC;">
  <table cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #F5F2EC; padding: 40px 20px;">
    <tr>
      <td align="center">
        <table cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; width: 100%; background: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(78, 42, 42, 0.1);">

          <!-- Header -->
          <tr>
            <td style="background: linear-gradient(135deg, #4E2A2A 0%, #6B3838 100%); padding: 40px 30px; text-align: center;">
              <img src="https://firebasestorage.googleapis.com/v0/b/hope-bearer-award.firebasestorage.app/o/flower-of-hope.png?alt=media&token=24367784-04b9-4d7c-9ee0-40b3d62473d6"
                   alt="Hope Bearer Award"
                   width="80" height="80" style="display: block; margin: 0 auto 15px auto;" />
              <h1 style="margin: 0; color: #D4AF37; font-size: 26px; font-weight: bold;">Complete Your Payment</h1>
              <p style="margin: 10px 0 0 0; color: #F5F2EC; font-size: 15px;">The Night of Light - ${EVENT_DATE} at ${EVENT_TIME}</p>
            </td>
          </tr>

          <!-- Time-sensitive Banner -->
          <tr>
            <td style="background-color: #FFF3CD; padding: 15px 30px; border-left: 4px solid #F59E0B;">
              <table cellpadding="0" cellspacing="0" border="0" width="100%">
                <tr>
                  <td width="40" style="vertical-align: middle;">
                    <div style="width: 32px; height: 32px; background-color: #F59E0B; border-radius: 50%; text-align: center; line-height: 32px; color: white; font-size: 16px;">⏰</div>
                  </td>
                  <td style="padding-left: 12px; vertical-align: middle;">
                    <p style="margin: 0; color: #92400E; font-size: 14px; font-weight: bold;">Time-Sensitive: Payment Link Valid Until</p>
                    <p style="margin: 5px 0 0 0; color: #92400E; font-size: 16px; font-weight: bold;">${expiryDate}</p>
                  </td>
                </tr>
              </table>
            </td>
          </tr>

          <!-- Content -->
          <tr>
            <td style="padding: 40px 30px;">
              <p style="margin: 0 0 20px 0; font-size: 17px; color: #4E2A2A; line-height: 1.6;">Dear ${customerName},</p>

              <p style="margin: 0 0 25px 0; font-size: 15px; color: #666; line-height: 1.7;">
                Your seat reservation for the <strong style="color: #4E2A2A;">Hope Bearer Award Ceremony</strong> is confirmed!
                Please complete your payment within the next 8 hours to secure your seats.
              </p>

              <!-- Confirmation Code -->
              <table cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #F5F2EC; border-radius: 12px; margin: 25px 0;">
                <tr>
                  <td style="padding: 20px; text-align: center;">
                    <p style="margin: 0 0 8px 0; color: #666; font-size: 13px; text-transform: uppercase; letter-spacing: 1px;">Confirmation Code</p>
                    <p style="margin: 0; color: #4E2A2A; font-size: 28px; font-weight: bold; font-family: 'Courier New', monospace; letter-spacing: 2px;">${confirmationCode}</p>
                  </td>
                </tr>
              </table>

              <!-- Amount Due -->
              <table cellpadding="0" cellspacing="0" border="0" width="100%" style="background: linear-gradient(135deg, rgba(212, 175, 55, 0.1) 0%, rgba(245, 242, 236, 0.5) 100%); border: 2px solid #D4AF37; border-radius: 12px; margin: 25px 0;">
                <tr>
                  <td style="padding: 20px; text-align: center;">
                    <p style="margin: 0 0 8px 0; color: #666; font-size: 13px;">Total Amount Due</p>
                    <p style="margin: 0; color: #4E2A2A; font-size: 36px; font-weight: bold;">$${totalAmount.toFixed(2)} USD</p>
                    ${contribution > 0 ? `<p style="margin: 8px 0 0 0; color: #22C55E; font-size: 13px;">Includes $${contribution.toFixed(2)} charitable contribution</p>` : ''}
                  </td>
                </tr>
              </table>

              <!-- Pay Now Button with Whish Logo -->
              <table cellpadding="0" cellspacing="0" border="0" width="100%" style="margin: 30px 0;">
                <tr>
                  <td align="center">
                    <a href="${paymentLink}"
                       style="display: inline-block; background: linear-gradient(135deg, #22C55E 0%, #16A34A 100%); color: #ffffff; text-decoration: none; padding: 18px 50px; border-radius: 10px; font-size: 18px; font-weight: bold; box-shadow: 0 4px 15px rgba(34, 197, 94, 0.4);">
                      Pay Now with Whish
                    </a>
                  </td>
                </tr>
                <tr>
                  <td align="center" style="padding-top: 15px;">
                    <img src="${WHISH_LOGO_URL}" alt="Powered by Whish" width="100" style="display: block; margin: 10px auto;" />
                    <p style="margin: 0; font-size: 13px; color: #666;">
                      Or copy this link: <a href="${paymentLink}" style="color: #D4AF37; word-break: break-all;">${paymentLink}</a>
                    </p>
                  </td>
                </tr>
              </table>

              <!-- Important Notice -->
              <table cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #FEF2F2; border-left: 4px solid #EF4444; border-radius: 8px; margin: 25px 0;">
                <tr>
                  <td style="padding: 15px 20px;">
                    <p style="margin: 0 0 8px 0; color: #991B1B; font-size: 14px; font-weight: bold;">⚠️ Important</p>
                    <p style="margin: 0; color: #991B1B; font-size: 13px; line-height: 1.6;">
                      If payment is not completed by <strong>${expiryDate}</strong>, your reservation will be automatically cancelled and seats released.
                    </p>
                  </td>
                </tr>
              </table>

              <!-- Signature -->
              <p style="margin: 30px 0 0 0; font-size: 15px; color: #666; line-height: 1.6;">
                We look forward to welcoming you to this historic evening!
              </p>
              <p style="margin: 15px 0 0 0; font-size: 15px; font-style: italic; color: #999;">
                Warm regards,<br/>
                <strong style="color: #4E2A2A;">The Hope Bearer Award Team</strong>
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="background-color: #F5F2EC; padding: 25px 30px; text-align: center; border-top: 2px solid #D4AF37;">
              <p style="margin: 0 0 8px 0; font-size: 14px; color: #4E2A2A; font-weight: bold;">Hope Bearer Award</p>
              <p style="margin: 0 0 12px 0; font-size: 12px; color: #666;">
                The Night of Light | ${EVENT_DATE} at ${EVENT_TIME}<br/>
                UNESCO Palace Theater, Beirut, Lebanon
              </p>
              <p style="margin: 0; font-size: 12px; color: #666;">
                Need help? <a href="mailto:info@hopebearer-award.com" style="color: #D4AF37; text-decoration: none;">info@hopebearer-award.com</a> | +961 76 701 865
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `;
}

function buildVIPDonationNotificationEmail(donationData) {
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: Georgia, serif; line-height: 1.6; color: #333; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(135deg, #4E2A2A 0%, #6B3838 100%); color: white; padding: 30px; text-align: center; border-radius: 10px 10px 0 0; }
    .content { background: #F5F2EC; padding: 30px; border-radius: 0 0 10px 10px; }
    .info-row { margin: 15px 0; padding: 15px; background: white; border-radius: 8px; }
    .label { font-weight: bold; color: #4E2A2A; }
    .value { color: #666; }
    .amount { font-size: 32px; font-weight: bold; color: #22C55E; text-align: center; margin: 20px 0; }
    .recognition { background: #D4AF37; color: white; padding: 15px; border-radius: 8px; margin: 20px 0; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 style="margin: 0;">🎉 New VIP Donation!</h1>
      <p style="margin: 10px 0 0 0; opacity: 0.9;">Hope Bearer Award - The Night of Light</p>
    </div>

    <div class="content">
      <div class="amount">$${donationData.donationAmount.toFixed(2)} USD</div>

      <div class="info-row">
        <div class="label">Donation ID:</div>
        <div class="value">${donationData.donationId}</div>
      </div>

      <div class="info-row">
        <div class="label">Donor Name:</div>
        <div class="value">${donationData.donorName}</div>
      </div>

      <div class="info-row">
        <div class="label">Email:</div>
        <div class="value">${donationData.donorEmail}</div>
      </div>

      ${donationData.donorPhone ? `
      <div class="info-row">
        <div class="label">Phone:</div>
        <div class="value">${donationData.donorPhone}</div>
      </div>
      ` : ''}

      <div class="recognition">
        <div class="label" style="color: white;">Recognition Preference:</div>
        <div style="font-size: 18px; margin-top: 10px;">
          ${donationData.recognitionType === 'live' ? '🎤 Acknowledge Live on Stage' :
            donationData.recognitionType === 'letter' ? '✉️ Thank You Letter Only' :
            '🤫 Anonymous Donation'}
        </div>
        ${donationData.recognitionType !== 'anonymous' ? `
        <div style="margin-top: 10px;">
          <strong>${donationData.organizationType === 'organization' ? 'Organization' : 'Individual'}:</strong>
          ${donationData.recognitionName}
        </div>
        ` : ''}
      </div>

      <div class="info-row">
        <div class="label">Timestamp:</div>
        <div class="value">${new Date().toLocaleString('en-US', {
          dateStyle: 'full',
          timeStyle: 'long'
        })}</div>
      </div>

      <p style="margin-top: 30px; padding: 20px; background: #E0F2FE; border-radius: 8px; border-left: 4px solid #0369A1;">
        <strong>Action Required:</strong> Please follow up with the donor and process their recognition preference accordingly.
      </p>
    </div>
  </div>
</body>
</html>
  `;
}

function buildBookingConfirmationEmailHTML(data) {
  const {
    firstName,
    familyName,
    confirmationCode,
    totalSeats,
    totalAmount,
    seatingLevelName,
    bookingDate,
    reservationExpiresAt,
  } = data;

  const bookingDateStr = bookingDate instanceof Date ?
    bookingDate.toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' }) :
    'N/A';

  const expiryDateStr = reservationExpiresAt instanceof Date ?
    reservationExpiresAt.toLocaleDateString('en-US', {
      weekday: 'short',
      year: 'numeric',
      month: 'short',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit'
    }) :
    'N/A';

  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <style>
    body { font-family: Georgia, serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
    .container { max-width: 600px; margin: 0 auto; padding: 20px; }
    .header { background: linear-gradient(135deg, #4E2A2A 0%, #6B3838 100%); color: white; padding: 40px 30px; text-align: center; border-radius: 10px 10px 0 0; }
    .header h1 { margin: 0 0 10px 0; font-size: 28px; }
    .header p { margin: 0; opacity: 0.9; font-size: 16px; }
    .content { background: #F5F2EC; padding: 30px; border-radius: 0 0 10px 10px; }
    .confirmation-box { background: #D4AF37; color: #4E2A2A; padding: 25px; border-radius: 10px; text-align: center; margin: 20px 0; }
    .confirmation-code { font-size: 32px; font-weight: bold; font-family: 'Courier New', monospace; letter-spacing: 3px; margin: 10px 0; }
    .info-row { margin: 15px 0; padding: 15px; background: white; border-radius: 8px; display: flex; justify-content: space-between; }
    .label { font-weight: bold; color: #4E2A2A; }
    .value { color: #666; }
    .warning-box { background: #FEF3C7; border: 2px solid #F59E0B; border-radius: 8px; padding: 20px; margin: 20px 0; }
    .warning-box strong { color: #92400E; }
    .button { display: inline-block; background: #4E2A2A; color: white; padding: 15px 30px; text-decoration: none; border-radius: 8px; font-weight: bold; margin: 20px 0; }
    .footer { text-align: center; padding: 20px; color: #666; font-size: 12px; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1>🎉 Booking Confirmed!</h1>
      <p>Hope Bearer Award - The Night of Light</p>
    </div>

    <div class="content">
      <p>Dear ${firstName} ${familyName},</p>

      <p>Thank you for your booking! Your reservation has been confirmed.</p>

      <div class="confirmation-box">
        <div style="font-size: 14px; opacity: 0.8;">Your Confirmation Code</div>
        <div class="confirmation-code">${confirmationCode}</div>
        <div style="font-size: 12px; opacity: 0.8; margin-top: 5px;">Save this code for reference</div>
      </div>

      <div class="info-row">
        <span class="label">Seating Level:</span>
        <span class="value">${seatingLevelName}</span>
      </div>

      <div class="info-row">
        <span class="label">Total Seats:</span>
        <span class="value">${totalSeats}</span>
      </div>

      <div class="info-row">
        <span class="label">Total Amount:</span>
        <span class="value">$${totalAmount.toFixed(2)} USD</span>
      </div>

      <div class="info-row">
        <span class="label">Booking Date:</span>
        <span class="value">${bookingDateStr}</span>
      </div>

      <div class="warning-box">
        <strong>⏰ Important: Complete Your Payment</strong>
        <p style="margin: 10px 0 0 0;">Your reservation expires on <strong>${expiryDateStr}</strong>. Please complete your payment before this time to secure your seats.</p>
        <p style="margin: 10px 0 0 0;">To complete payment, visit your booking page using your confirmation code or click the payment link in your checkout page.</p>
      </div>

      <div style="background: #E0F2FE; border-radius: 8px; padding: 20px; margin: 20px 0;">
        <h3 style="margin: 0 0 10px 0; color: #0369A1;">📅 Event Details</h3>
        <p style="margin: 5px 0;"><strong>Date:</strong> February 13, 2026</p>
        <p style="margin: 5px 0;"><strong>Time:</strong> 7:00 PM (Doors open at 6:30 PM)</p>
        <p style="margin: 5px 0;"><strong>Venue:</strong> UNESCO Palace, Beirut, Lebanon</p>
      </div>

      <p style="margin-top: 30px;">If you have any questions, please contact us at <a href="mailto:ceo@hopebearer-award.com">ceo@hopebearer-award.com</a></p>

      <p style="margin-top: 20px;">We look forward to seeing you at The Night of Light!</p>

      <p style="margin-top: 30px; font-style: italic;">Warm regards,<br>The Hope Bearer Award Team</p>
    </div>

    <div class="footer">
      <p>Hope Bearer Award | hopebearer-award.com</p>
      <p>This is an automated message. Please do not reply to this email.</p>
    </div>
  </div>
</body>
</html>
  `;
}

function generateTicketHTML(data) {
  const {
    confirmationCode,
    attendeeName,
    email,
    seatNumber,
    seatingLevel,
    ticketNumber,
    totalTickets,
    qrCodeDataURL,
  } = data;

  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>E-Ticket - Hope Bearer Award</title>
  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body {
      font-family: 'Georgia', serif;
      background: linear-gradient(135deg, #F5F2EC 0%, #E8E4D9 100%);
      padding: 20px;
    }
    .ticket-container {
      max-width: 600px;
      margin: 0 auto;
      background: white;
      border-radius: 16px;
      overflow: hidden;
      box-shadow: 0 10px 40px rgba(78, 42, 42, 0.2);
    }
    .ticket-header {
      background: linear-gradient(135deg, #4E2A2A 0%, #6B3838 100%);
      padding: 30px;
      text-align: center;
    }
    .ticket-title { color: #D4AF37; font-size: 24px; font-weight: bold; margin-bottom: 5px; }
    .ticket-subtitle { color: #F5F2EC; font-size: 14px; }
    .ticket-body { padding: 30px; }
    .admit-section {
      text-align: center;
      padding: 20px;
      background: linear-gradient(135deg, rgba(212, 175, 55, 0.1) 0%, rgba(245, 242, 236, 0.3) 100%);
      border-radius: 12px;
      border: 2px solid #D4AF37;
      margin-bottom: 25px;
    }
    .admit-title { font-size: 24px; color: #4E2A2A; font-weight: bold; }
    .attendee-name { font-size: 28px; color: #4E2A2A; font-weight: bold; margin: 20px 0 5px 0; text-align: center; }
    .attendee-email { font-size: 13px; color: #666; text-align: center; margin-bottom: 20px; }
    .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin-bottom: 25px; }
    .detail-box { padding: 15px; background: #F5F2EC; border-radius: 10px; text-align: center; }
    .detail-label { font-size: 11px; color: #666; text-transform: uppercase; letter-spacing: 1px; margin-bottom: 5px; }
    .detail-value { font-size: 18px; color: #4E2A2A; font-weight: bold; }
    .qr-section { text-align: center; padding: 25px; border: 2px solid #D4AF37; border-radius: 12px; margin-bottom: 25px; }
    .qr-code { width: 180px; height: 180px; margin: 0 auto 10px auto; }
    .qr-instruction { font-size: 12px; color: #666; }
    .confirmation-code {
      text-align: center;
      padding: 15px;
      background: linear-gradient(135deg, #D4AF37 0%, #F59E0B 100%);
      border-radius: 10px;
      margin-bottom: 20px;
    }
    .code-label { font-size: 11px; color: #4E2A2A; font-weight: bold; margin-bottom: 5px; }
    .code-value { font-size: 22px; color: #4E2A2A; font-weight: bold; font-family: 'Courier New', monospace; letter-spacing: 2px; }
    .event-info { background: #F5F2EC; padding: 20px; border-radius: 10px; margin-bottom: 20px; }
    .event-row { display: flex; justify-content: space-between; padding: 8px 0; border-bottom: 1px solid rgba(78, 42, 42, 0.1); }
    .event-row:last-child { border-bottom: none; }
    .event-label { color: #666; font-size: 13px; }
    .event-value { color: #4E2A2A; font-size: 13px; font-weight: bold; }
    .ticket-footer {
      background: #F5F2EC;
      padding: 20px;
      text-align: center;
      border-top: 2px solid #D4AF37;
    }
    .ticket-number { font-size: 12px; color: #666; margin-top: 10px; }
    @media print {
      body { background: white; padding: 0; }
      .ticket-container { box-shadow: none; }
    }
  </style>
</head>
<body>
  <div class="ticket-container">
    <div class="ticket-header">
      <h1 class="ticket-title">HOPE BEARER AWARD</h1>
      <p class="ticket-subtitle">The Night of Light - Inaugural Ceremony</p>
    </div>
    <div class="ticket-body">
      <div class="admit-section">
        <h2 class="admit-title">ADMIT ONE</h2>
      </div>
      <p class="attendee-name">${attendeeName}</p>
      <p class="attendee-email">${email}</p>
      <div class="detail-grid">
        <div class="detail-box">
          <p class="detail-label">Seat Number</p>
          <p class="detail-value">${seatNumber}</p>
        </div>
        <div class="detail-box">
          <p class="detail-label">Seating Level</p>
          <p class="detail-value">${seatingLevel}</p>
        </div>
      </div>
      <div class="qr-section">
        <img src="${qrCodeDataURL}" alt="QR Code" class="qr-code" />
        <p class="qr-instruction">Present this QR code at the entrance for check-in</p>
      </div>
      <div class="confirmation-code">
        <p class="code-label">CONFIRMATION CODE</p>
        <p class="code-value">${confirmationCode}</p>
      </div>
      <div class="event-info">
        <div class="event-row">
          <span class="event-label">Date</span>
          <span class="event-value">Friday, ${EVENT_DATE}</span>
        </div>
        <div class="event-row">
          <span class="event-label">Time</span>
          <span class="event-value">${EVENT_TIME} (Doors 6:30 PM)</span>
        </div>
        <div class="event-row">
          <span class="event-label">Venue</span>
          <span class="event-value">UNESCO Palace Theater</span>
        </div>
        <div class="event-row">
          <span class="event-label">Location</span>
          <span class="event-value">Beirut, Lebanon</span>
        </div>
      </div>
    </div>
    <div class="ticket-footer">
      <p style="font-size: 12px; color: #4E2A2A; font-weight: bold;">Hope Bearer Award</p>
      <p style="font-size: 11px; color: #666; margin-top: 5px;">hopebearer-award.com</p>
      <p class="ticket-number">Ticket ${ticketNumber} of ${totalTickets}</p>
    </div>
  </div>
</body>
</html>
  `;
}

function buildTicketsDeliveredEmailHTML(data) {
  const {
    firstName,
    familyName,
    confirmationCode,
    totalSeats,
    seatingLevelName,
    seatNumbers,
    attendees,
    ticketUrls,
  } = data;

  const attendeesList = attendees.map((a, i) => `
    <tr>
      <td style="padding: 12px 15px; border-bottom: 1px solid #E5E7EB;">
        <strong style="color: #4E2A2A;">${a.name}</strong><br/>
        <span style="font-size: 12px; color: #666;">${a.email}</span>
      </td>
      <td style="padding: 12px 15px; border-bottom: 1px solid #E5E7EB; text-align: center;">
        <span style="font-family: 'Courier New', monospace; font-weight: bold; color: #4E2A2A;">${a.seatNumber}</span>
      </td>
      <td style="padding: 12px 15px; border-bottom: 1px solid #E5E7EB; text-align: center;">
        <a href="${ticketUrls[i]}" style="display: inline-block; padding: 8px 16px; background: #D4AF37; color: #4E2A2A; text-decoration: none; border-radius: 6px; font-size: 12px; font-weight: bold;">View Ticket</a>
      </td>
    </tr>
  `).join('');

  return `
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Your Tickets - Hope Bearer Award</title>
</head>
<body style="margin: 0; padding: 0; font-family: 'Georgia', serif; background-color: #F5F2EC;">
  <table cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #F5F2EC; padding: 40px 20px;">
    <tr>
      <td align="center">
        <table cellpadding="0" cellspacing="0" border="0" style="max-width: 600px; width: 100%; background: #ffffff; border-radius: 16px; overflow: hidden; box-shadow: 0 4px 20px rgba(78, 42, 42, 0.1);">

          <!-- Header -->
          <tr>
            <td style="background: linear-gradient(135deg, #22C55E 0%, #16A34A 100%); padding: 40px 30px; text-align: center;">
              <div style="width: 80px; height: 80px; background: white; border-radius: 50%; margin: 0 auto 15px auto; display: flex; align-items: center; justify-content: center;">
                <span style="font-size: 40px;">🎟️</span>
              </div>
              <h1 style="margin: 0; color: #ffffff; font-size: 28px; font-weight: bold;">Your Tickets Are Ready!</h1>
              <p style="margin: 10px 0 0 0; color: rgba(255,255,255,0.9); font-size: 15px;">The Night of Light - ${EVENT_DATETIME}</p>
            </td>
          </tr>

          <!-- Confirmation Banner -->
          <tr>
            <td style="background-color: #D4AF37; padding: 15px 30px; text-align: center;">
              <p style="margin: 0; color: #4E2A2A; font-size: 12px; text-transform: uppercase; letter-spacing: 1px;">Confirmation Code</p>
              <p style="margin: 5px 0 0 0; color: #4E2A2A; font-size: 24px; font-weight: bold; font-family: 'Courier New', monospace; letter-spacing: 2px;">${confirmationCode}</p>
            </td>
          </tr>

          <!-- Content -->
          <tr>
            <td style="padding: 40px 30px;">
              <p style="margin: 0 0 20px 0; font-size: 17px; color: #4E2A2A; line-height: 1.6;">Dear ${firstName} ${familyName},</p>

              <p style="margin: 0 0 25px 0; font-size: 15px; color: #666; line-height: 1.7;">
                Great news! Your payment has been confirmed and your e-tickets for the <strong style="color: #4E2A2A;">Hope Bearer Award Ceremony</strong> are ready.
                You'll find all ${totalSeats} ticket(s) below.
              </p>

              <!-- Tickets Table -->
              <table cellpadding="0" cellspacing="0" border="0" width="100%" style="border: 2px solid #D4AF37; border-radius: 12px; overflow: hidden; margin: 25px 0;">
                <tr style="background: linear-gradient(135deg, rgba(212, 175, 55, 0.2) 0%, rgba(245, 242, 236, 0.5) 100%);">
                  <th style="padding: 15px; text-align: left; font-size: 13px; color: #4E2A2A; font-weight: bold;">Attendee</th>
                  <th style="padding: 15px; text-align: center; font-size: 13px; color: #4E2A2A; font-weight: bold;">Seat</th>
                  <th style="padding: 15px; text-align: center; font-size: 13px; color: #4E2A2A; font-weight: bold;">Ticket</th>
                </tr>
                ${attendeesList}
              </table>

              <!-- Event Details -->
              <table cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #F5F2EC; border-radius: 12px; margin: 25px 0;">
                <tr>
                  <td style="padding: 20px;">
                    <h3 style="margin: 0 0 15px 0; color: #4E2A2A; font-size: 16px;">Event Details</h3>
                    <table cellpadding="8" cellspacing="0" border="0" width="100%" style="font-size: 14px;">
                      <tr>
                        <td style="color: #666; width: 40%;">📅 Date:</td>
                        <td style="color: #4E2A2A; font-weight: bold;">Friday, ${EVENT_DATE}</td>
                      </tr>
                      <tr>
                        <td style="color: #666;">⏰ Time:</td>
                        <td style="color: #4E2A2A; font-weight: bold;">${EVENT_TIME} (Doors 6:30 PM)</td>
                      </tr>
                      <tr>
                        <td style="color: #666;">📍 Venue:</td>
                        <td style="color: #4E2A2A; font-weight: bold;">UNESCO Palace Theater, Beirut</td>
                      </tr>
                      <tr>
                        <td style="color: #666;">🎫 Seating:</td>
                        <td style="color: #4E2A2A; font-weight: bold;">${seatingLevelName}</td>
                      </tr>
                    </table>
                  </td>
                </tr>
              </table>

              <!-- Instructions -->
              <table cellpadding="0" cellspacing="0" border="0" width="100%" style="background-color: #E0F2FE; border: 2px solid #0369A1; border-radius: 10px; margin: 25px 0;">
                <tr>
                  <td style="padding: 20px;">
                    <p style="margin: 0 0 10px 0; color: #0C4A6E; font-size: 15px; font-weight: bold;">📱 On the Day of the Event:</p>
                    <ul style="margin: 0; padding-left: 20px; color: #0C4A6E; font-size: 14px; line-height: 1.8;">
                      <li>Have your e-ticket ready on your phone or printed</li>
                      <li>Present the QR code at the entrance for quick check-in</li>
                      <li>Doors open at 5:30 PM - arrive early for best experience</li>
                      <li>Dress code: Black-tie optional</li>
                    </ul>
                  </td>
                </tr>
              </table>

              <p style="margin: 30px 0 0 0; font-size: 15px; color: #666; line-height: 1.6;">
                We're excited to see you at this historic celebration of hope and resilience!
              </p>
              <p style="margin: 15px 0 0 0; font-size: 15px; font-style: italic; color: #999;">
                Warm regards,<br/>
                <strong style="color: #4E2A2A;">The Hope Bearer Award Team</strong>
              </p>
            </td>
          </tr>

          <!-- Footer -->
          <tr>
            <td style="background-color: #F5F2EC; padding: 25px 30px; text-align: center; border-top: 2px solid #D4AF37;">
              <p style="margin: 0 0 8px 0; font-size: 14px; color: #4E2A2A; font-weight: bold;">Hope Bearer Award</p>
              <p style="margin: 0 0 12px 0; font-size: 12px; color: #666;">
                The Night of Light | ${EVENT_DATETIME}
              </p>
              <p style="margin: 0; font-size: 12px; color: #666;">
                Questions? <a href="mailto:info@hopebearer-award.com" style="color: #D4AF37; text-decoration: none;">info@hopebearer-award.com</a>
              </p>
            </td>
          </tr>
        </table>
      </td>
    </tr>
  </table>
</body>
</html>
  `;
}

module.exports = {
  buildPaymentLinkEmailHTML,
  buildVIPDonationNotificationEmail,
  buildBookingConfirmationEmailHTML,
  generateTicketHTML,
  buildTicketsDeliveredEmailHTML,
  EVENT_DATE,
  EVENT_TIME,
  EVENT_DATETIME,
  WHISH_LOGO_URL
};
