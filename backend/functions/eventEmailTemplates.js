// Event Email Templates System - JavaScript version for Cloud Functions
// Professional HTML email templates for event bookings with inline CSS

// Helper to get event title
const getEventTitle = (event) => {
  return typeof event.title === 'string' ? event.title : event.title.en;
};

// Helper to get event description
const getEventDescription = (event) => {
  return typeof event.description === 'string' ? event.description : event.description.en;
};

// Helper to get venue name
const getVenueName = (event) => {
  if (!event.venue?.name) return 'TBD';
  return typeof event.venue.name === 'string' ? event.venue.name : event.venue.name.en;
};

// Booking Confirmation Email
const generateBookingConfirmationEmail = (data) => {
  const { event, booking, recipientName } = data;
  const eventTitle = getEventTitle(event);
  const venueName = getVenueName(event);
  
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
    .container { max-width: 600px; margin: 0 auto; padding: 0; }
    .header { background: linear-gradient(135deg, #8B0000 0%, #D4AF37 100%); color: white; padding: 40px 20px; text-align: center; }
    .header h1 { margin: 0; font-size: 28px; }
    .content { background: white; padding: 30px 20px; }
    .success-icon { font-size: 48px; margin-bottom: 20px; }
    .ticket-box { background: #f9f9f9; border-left: 4px solid #D4AF37; padding: 20px; margin: 20px 0; border-radius: 5px; }
    .ticket-item { padding: 10px 0; border-bottom: 1px solid #eee; }
    .ticket-item:last-child { border-bottom: none; }
    .qr-code { text-align: center; margin: 30px 0; padding: 20px; background: #f9f9f9; border-radius: 10px; }
    .qr-code img { max-width: 300px; }
    .confirmation-code { font-size: 24px; font-weight: bold; color: #8B0000; font-family: monospace; margin-top: 10px; }
    .event-details { margin: 30px 0; }
    .detail-row { display: flex; padding: 12px 0; border-bottom: 1px solid #eee; }
    .detail-label { font-weight: bold; color: #666; min-width: 120px; }
    .detail-value { color: #333; }
    .price-table { width: 100%; margin: 20px 0; }
    .price-row { display: flex; justify-content: space-between; padding: 10px 0; }
    .price-total { font-size: 20px; font-weight: bold; color: #8B0000; border-top: 2px solid #D4AF37; padding-top: 15px; margin-top: 10px; }
    .checklist { background: #fff8dc; padding: 20px; border-radius: 5px; margin: 20px 0; }
    .checklist ul { margin: 10px 0; padding-left: 20px; }
    .footer { background: #f5f5f0; padding: 30px 20px; text-align: center; font-size: 14px; color: #666; }
    .button { display: inline-block; padding: 15px 40px; background: #8B0000; color: white; text-decoration: none; border-radius: 5px; margin: 20px 0; font-weight: bold; }
    .highlight { color: #D4AF37; font-weight: bold; }
    @media only screen and (max-width: 600px) {
      .detail-row { flex-direction: column; }
      .detail-label { margin-bottom: 5px; }
    }
  </style>
</head>
<body>
  <div class="container">
    <!-- Header -->
    <div class="header">
      <div class="success-icon">✓</div>
      <h1>Booking Confirmed!</h1>
      <p style="margin: 10px 0 0 0; font-size: 16px; opacity: 0.9;">Thank you for your registration</p>
    </div>
    
    <!-- Content -->
    <div class="content">
      <h2 style="color: #8B0000; margin-top: 0;">Hello ${recipientName},</h2>
      <p style="font-size: 16px; line-height: 1.8;">
        Your booking for <strong>${eventTitle}</strong> has been confirmed! We're excited to have you join us.
      </p>
      
      <!-- QR Code Section -->
      <div class="qr-code">
        <h3 style="color: #8B0000; margin-top: 0;">Your Event Ticket</h3>
        ${booking.qrCodeUrl ? `<img src="${booking.qrCodeUrl}" alt="QR Code" style="max-width: 300px; height: auto;" />` : '<p style="color: #666;">QR Code will be sent separately</p>'}
        <p style="color: #666; font-size: 14px; margin: 10px 0;">Show this QR code at the entrance</p>
        <div class="confirmation-code">${booking.confirmationCode}</div>
      </div>
      
      <!-- Tickets Booked -->
      <div class="ticket-box">
        <h3 style="color: #8B0000; margin-top: 0;">Your Tickets</h3>
        ${booking.tickets.map(ticket => `
          <div class="ticket-item">
            <strong>${ticket.quantity}x ${ticket.ticketName}</strong><br/>
            <span style="color: #666; font-size: 14px;">${booking.currency} ${ticket.price.toFixed(2)} each</span>
          </div>
        `).join('')}
      </div>
      
      <!-- Event Details -->
      <div class="event-details">
        <h3 style="color: #8B0000;">Event Details</h3>
        <div style="border-top: 2px solid #D4AF37; padding-top: 15px;">
          <div class="detail-row">
            <div class="detail-label">📅 Date</div>
            <div class="detail-value">${new Date(event.startDate).toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}</div>
          </div>
          <div class="detail-row">
            <div class="detail-label">🕐 Time</div>
            <div class="detail-value">${new Date(event.startDate).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}</div>
          </div>
          <div class="detail-row">
            <div class="detail-label">📍 Location</div>
            <div class="detail-value">${event.venue?.isVirtual ? 'Virtual Event - ' + (event.venue.virtualPlatform || 'Online') : venueName}</div>
          </div>
          ${event.venue?.isVirtual ? '' : `
          <div class="detail-row">
            <div class="detail-label">🏢 Address</div>
            <div class="detail-value">${event.venue?.address || ''}, ${event.venue?.city ? (typeof event.venue.city === 'string' ? event.venue.city : event.venue.city.en) : ''}</div>
          </div>
          `}
        </div>
      </div>
      
      <!-- Payment Summary -->
      <div class="price-table">
        <h3 style="color: #8B0000;">Payment Summary</h3>
        <div class="price-row">
          <span>Subtotal</span>
          <span>${booking.currency} ${booking.subtotal.toFixed(2)}</span>
        </div>
        ${booking.discount > 0 ? `
        <div class="price-row" style="color: #28a745;">
          <span>Discount</span>
          <span>-${booking.currency} ${booking.discount.toFixed(2)}</span>
        </div>
        ` : ''}
        <div class="price-row">
          <span>Tax</span>
          <span>${booking.currency} ${booking.tax.toFixed(2)}</span>
        </div>
        <div class="price-row price-total">
          <span>Total Paid</span>
          <span>${booking.currency} ${booking.totalAmount.toFixed(2)}</span>
        </div>
      </div>
      
      <!-- What to Bring -->
      <div class="checklist">
        <h3 style="color: #8B0000; margin-top: 0;">📋 What to Bring</h3>
        <ul style="line-height: 2;">
          <li>This confirmation email (digital or printed)</li>
          <li>Valid photo ID</li>
          ${event.venue?.isVirtual ? '<li>Stable internet connection</li>' : '<li>Arrive 15 minutes early for check-in</li>'}
        </ul>
      </div>
      
      ${event.venue?.isVirtual ? `
      <div style="background: #e3f2fd; padding: 20px; border-radius: 5px; border-left: 4px solid #2196f3;">
        <h4 style="color: #1976d2; margin-top: 0;">🌐 Virtual Event Access</h4>
        <p style="margin: 10px 0;">You will receive the virtual event link 30 minutes before the start time.</p>
      </div>
      ` : ''}
      
      <p style="margin-top: 30px; font-size: 14px; color: #666;">
        Need help? Contact us at <a href="mailto:${event.organizerEmail}" style="color: #8B0000;">${event.organizerEmail}</a>
      </p>
    </div>
    
    <!-- Footer -->
    <div class="footer">
      <p style="margin: 5px 0;">This is an automated confirmation email.</p>
      <p style="margin: 5px 0;">You'll receive a reminder 24 hours before the event.</p>
      <p style="margin: 20px 0 5px 0; color: #999; font-size: 12px;">
        Hope Bearer Award - Multipurpose Event Platform<br/>
        © ${new Date().getFullYear()} All Rights Reserved
      </p>
    </div>
  </div>
</body>
</html>
  `;
};

// Event Reminder Email (24 hours before)
const generateEventReminderEmail = (data) => {
  const { event, booking, recipientName } = data;
  const eventTitle = getEventTitle(event);
  const venueName = getVenueName(event);
  
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
    .container { max-width: 600px; margin: 0 auto; }
    .header { background: linear-gradient(135deg, #D4AF37 0%, #8B0000 100%); color: white; padding: 40px 20px; text-align: center; }
    .content { background: white; padding: 30px 20px; }
    .highlight-box { background: #fff8dc; border: 2px solid #D4AF37; padding: 20px; border-radius: 10px; margin: 20px 0; text-align: center; }
    .time-display { font-size: 36px; font-weight: bold; color: #8B0000; }
    .footer { background: #f5f5f0; padding: 20px; text-align: center; font-size: 14px; color: #666; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 style="margin: 0; font-size: 32px;">⏰ Event Tomorrow!</h1>
      <p style="margin: 10px 0 0 0; font-size: 18px;">Don't forget your upcoming event</p>
    </div>
    
    <div class="content">
      <h2 style="color: #8B0000;">Hello ${recipientName},</h2>
      <p style="font-size: 16px;">
        This is a friendly reminder that <strong>${eventTitle}</strong> is happening tomorrow!
      </p>
      
      <div class="highlight-box">
        <p style="margin: 0; font-size: 18px; color: #666;">Event starts at</p>
        <div class="time-display">${new Date(event.startDate).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}</div>
        <p style="margin: 5px 0 0 0; color: #666;">${new Date(event.startDate).toLocaleDateString('en-US', { weekday: 'long', month: 'long', day: 'numeric' })}</p>
      </div>
      
      <h3 style="color: #8B0000;">📍 Location</h3>
      <p style="font-size: 16px;">
        ${event.venue?.isVirtual ? 
          `<strong>Virtual Event</strong><br/>Platform: ${event.venue.virtualPlatform || 'Online'}<br/>${event.venue.virtualUrl ? `<a href="${event.venue.virtualUrl}" style="color: #8B0000;">Join Event</a>` : 'Link will be sent 30 minutes before start'}` :
          `<strong>${venueName}</strong><br/>${event.venue?.address || ''}<br/>${event.venue?.city ? (typeof event.venue.city === 'string' ? event.venue.city : event.venue.city.en) : ''}`
        }
      </p>
      
      <h3 style="color: #8B0000;">🎫 Your Confirmation Code</h3>
      <p style="font-size: 24px; font-family: monospace; font-weight: bold; color: #8B0000; text-align: center; background: #f9f9f9; padding: 15px; border-radius: 5px;">
        ${booking.confirmationCode}
      </p>
      
      <div style="background: #e8f5e9; padding: 20px; border-radius: 5px; margin: 20px 0;">
        <h4 style="color: #2e7d32; margin-top: 0;">✓ Quick Checklist</h4>
        <ul style="line-height: 2; margin: 0;">
          <li>Have your QR code/confirmation ready</li>
          <li>Bring a valid photo ID</li>
          ${event.venue?.isVirtual ? 
            '<li>Test your internet connection</li><li>Join 10 minutes early</li>' : 
            '<li>Plan to arrive 15 minutes early</li><li>Check parking options</li>'
          }
        </ul>
      </div>
      
      <p style="font-size: 14px; color: #666;">
        Questions? Contact <a href="mailto:${event.organizerEmail}" style="color: #8B0000;">${event.organizerEmail}</a>
      </p>
    </div>
    
    <div class="footer">
      <p>See you tomorrow! 🎉</p>
      <p style="font-size: 12px; color: #999;">Hope Bearer Award Event Platform</p>
    </div>
  </div>
</body>
</html>
  `;
};

// Cancellation Email
const generateCancellationEmail = (data) => {
  const { event, booking, recipientName } = data;
  const eventTitle = getEventTitle(event);
  
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
    .container { max-width: 600px; margin: 0 auto; }
    .header { background: linear-gradient(135deg, #757575 0%, #424242 100%); color: white; padding: 40px 20px; text-align: center; }
    .content { background: white; padding: 30px 20px; }
    .refund-box { background: #fff3cd; border-left: 4px solid #ffc107; padding: 20px; margin: 20px 0; }
    .footer { background: #f5f5f0; padding: 20px; text-align: center; font-size: 14px; color: #666; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 style="margin: 0;">Booking Cancelled</h1>
    </div>
    
    <div class="content">
      <h2 style="color: #757575;">Hello ${recipientName},</h2>
      <p style="font-size: 16px;">
        Your booking for <strong>${eventTitle}</strong> has been cancelled as requested.
      </p>
      
      <div style="background: #f5f5f5; padding: 15px; border-radius: 5px; margin: 20px 0;">
        <p style="margin: 5px 0;"><strong>Booking Code:</strong> ${booking.confirmationCode}</p>
        <p style="margin: 5px 0;"><strong>Total Amount:</strong> ${booking.currency} ${booking.totalAmount.toFixed(2)}</p>
      </div>
      
      ${booking.totalAmount > 0 ? `
      <div class="refund-box">
        <h3 style="color: #856404; margin-top: 0;">💰 Refund Information</h3>
        <p style="margin: 10px 0;">
          A refund of <strong>${booking.currency} ${booking.totalAmount.toFixed(2)}</strong> will be processed to your original payment method.
        </p>
        <p style="margin: 10px 0; font-size: 14px; color: #666;">
          Please allow 5-7 business days for the refund to appear in your account.
        </p>
      </div>
      ` : ''}
      
      <p style="font-size: 14px; color: #666; margin-top: 30px;">
        If you have any questions, please contact <a href="mailto:${event.organizerEmail}" style="color: #8B0000;">${event.organizerEmail}</a>
      </p>
    </div>
    
    <div class="footer">
      <p>We hope to see you at future events!</p>
      <p style="font-size: 12px; color: #999;">Hope Bearer Award Event Platform</p>
    </div>
  </div>
</body>
</html>
  `;
};

// Ticket Email (resend/download)
const generateTicketEmail = (data) => {
  const { event, booking, recipientName } = data;
  const eventTitle = getEventTitle(event);
  
  return `
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <style>
    body { font-family: 'Helvetica Neue', Arial, sans-serif; line-height: 1.6; color: #333; margin: 0; padding: 0; }
    .container { max-width: 600px; margin: 0 auto; }
    .header { background: linear-gradient(135deg, #8B0000 0%, #D4AF37 100%); color: white; padding: 40px 20px; text-align: center; }
    .content { background: white; padding: 30px 20px; }
    .ticket-box { border: 3px dashed #D4AF37; padding: 30px; margin: 20px 0; text-align: center; background: #fffef7; }
    .qr-large { max-width: 400px; margin: 20px auto; }
    .button { display: inline-block; padding: 15px 40px; background: #8B0000; color: white; text-decoration: none; border-radius: 5px; margin: 10px; font-weight: bold; }
    .footer { background: #f5f5f0; padding: 20px; text-align: center; font-size: 14px; color: #666; }
  </style>
</head>
<body>
  <div class="container">
    <div class="header">
      <h1 style="margin: 0;">🎫 Your Event Ticket</h1>
      <p style="margin: 10px 0 0 0; font-size: 16px;">${eventTitle}</p>
    </div>
    
    <div class="content">
      <h2 style="color: #8B0000; text-align: center;">Hello ${recipientName}!</h2>
      
      <div class="ticket-box">
        ${booking.qrCodeUrl ? `
        <div class="qr-large">
          <img src="${booking.qrCodeUrl}" alt="Event Ticket QR Code" style="max-width: 100%; height: auto;" />
        </div>
        ` : '<p style="color: #666;">QR Code Generation Pending</p>'}
        
        <p style="font-size: 28px; font-weight: bold; color: #8B0000; font-family: monospace; margin: 20px 0;">
          ${booking.confirmationCode}
        </p>
        
        <p style="color: #666; margin: 10px 0;">
          Show this QR code at the event entrance
        </p>
        
        ${booking.pdfTicketUrl ? `
        <a href="${booking.pdfTicketUrl}" class="button" style="color: white;">
          📄 Download PDF Ticket
        </a>
        ` : ''}
        
        <button onclick="window.print()" class="button" style="background: #666; border: none; cursor: pointer;">
          🖨️ Print Ticket
        </button>
      </div>
      
      <div style="background: #f9f9f9; padding: 20px; border-radius: 5px; margin: 20px 0;">
        <h3 style="color: #8B0000; margin-top: 0;">Event Information</h3>
        <p style="margin: 5px 0;"><strong>Date:</strong> ${new Date(event.startDate).toLocaleDateString('en-US', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' })}</p>
        <p style="margin: 5px 0;"><strong>Time:</strong> ${new Date(event.startDate).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}</p>
        <p style="margin: 5px 0;"><strong>Tickets:</strong> ${booking.totalTickets}</p>
      </div>
      
      <div style="background: #e3f2fd; padding: 15px; border-radius: 5px; border-left: 4px solid #2196f3;">
        <p style="margin: 5px 0; font-size: 14px;">
          <strong>💡 Tip:</strong> Save this email or take a screenshot of your QR code for easy access at the event!
        </p>
      </div>
    </div>
    
    <div class="footer">
      <p>Looking forward to seeing you at the event! 🎉</p>
      <p style="font-size: 12px; color: #999;">Hope Bearer Award Event Platform</p>
    </div>
  </div>
</body>
</html>
  `;
};

// Export all template functions
module.exports = {
  bookingConfirmation: generateBookingConfirmationEmail,
  eventReminder: generateEventReminderEmail,
  cancellation: generateCancellationEmail,
  ticket: generateTicketEmail
};
