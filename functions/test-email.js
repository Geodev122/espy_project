const nodemailer = require('nodemailer');

console.log('?? Testing Gmail App Password...\n');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'geo.elnajjar@gmail.com',
    pass: 'kzav nuks sjop fkwk'
  }
});

const mailOptions = {
  from: '"Hope Bearer Award TEST" <geo.elnajjar@gmail.com>',
  to: 'geo.elnajjar@gmail.com', // Send to self for testing
  cc: 'ceo@hopebearer-award.com',
  subject: '? Test Email - Gmail App Password Verification',
  html: `
    <div style="font-family: Arial, sans-serif; padding: 20px; background-color: #f5f2ec;">
      <div style="background-color: white; padding: 30px; border-radius: 10px; max-width: 600px; margin: 0 auto;">
        <h1 style="color: #4E2A2A;">? Success!</h1>
        <p style="font-size: 16px; color: #666;">
          If you're reading this, the Gmail App Password (<code>kzav nuks sjop fkwk</code>) is working correctly!
        </p>
        <hr style="border: none; border-top: 2px solid #D4AF37; margin: 20px 0;">
        <h2 style="color: #4E2A2A;">Configuration Details:</h2>
        <ul style="color: #666; line-height: 1.8;">
          <li><strong>Email Account:</strong> geo.elnajjar@gmail.com</li>
          <li><strong>App Password:</strong> kzav nuks sjop fkwk</li>
          <li><strong>Sender:</strong> Hope Bearer Award &lt;geo.elnajjar@gmail.com&gt;</li>
          <li><strong>CC:</strong> ceo@hopebearer-award.com</li>
          <li><strong>Status:</strong> ? WORKING</li>
        </ul>
        <hr style="border: none; border-top: 2px solid #D4AF37; margin: 20px 0;">
        <p style="font-size: 14px; color: #999;">
          Test conducted on: ${new Date().toLocaleString()}<br>
          This is an automated test from the Hope Bearer Award email system.
        </p>
      </div>
    </div>
  `,
  text: `
? Success!

If you're reading this, the Gmail App Password (kzav nuks sjop fkwk) is working correctly!

Configuration Details:
- Email Account: geo.elnajjar@gmail.com
- App Password: kzav nuks sjop fkwk
- Sender: Hope Bearer Award <geo.elnajjar@gmail.com>
- CC: ceo@hopebearer-award.com
- Status: ? WORKING

Test conducted on: ${new Date().toLocaleString()}
This is an automated test from the Hope Bearer Award email system.
  `
};

console.log('?? Attempting to send test email...');
console.log('From:', mailOptions.from);
console.log('To:', mailOptions.to);
console.log('CC:', mailOptions.cc);
console.log('\nPlease wait...\n');

transporter.sendMail(mailOptions, (error, info) => {
  if (error) {
    console.log('? ERROR - Gmail App Password is NOT working!\n');
    console.log('????????????????????????????????????????');
    console.log('Error Code:', error.code);
    console.log('Error Message:', error.message);
    console.log('Error Command:', error.command);
    console.log('????????????????????????????????????????\n');
    
    // Provide specific guidance based on error code
    if (error.code === 'EAUTH') {
      console.log('?? FIX REQUIRED:\n');
      console.log('The app password is invalid or expired.');
      console.log('\nSteps to fix:');
      console.log('1. Go to: https://myaccount.google.com/apppasswords');
      console.log('2. Delete the old "Hope Bearer Award Website" entry');
      console.log('3. Create a new app password:');
      console.log('   - App: Mail');
      console.log('   - Device: Other (Custom name)');
      console.log('   - Name: Hope Bearer Award Website');
      console.log('4. Click Generate and copy the 16-character password');
      console.log('5. Update functions/index.js line 22 with new password');
      console.log('6. Run: firebase deploy --only functions');
      console.log('7. Run this test again: node test-email.js\n');
    } else if (error.code === 'ETIMEDOUT' || error.code === 'ECONNECTION') {
      console.log('?? FIX REQUIRED:\n');
      console.log('Network connection issue.');
      console.log('\nSteps to fix:');
      console.log('1. Check your internet connection');
      console.log('2. Check if firewall is blocking port 587');
      console.log('3. Try again in a few minutes\n');
    } else {
      console.log('?? FIX REQUIRED:\n');
      console.log('Unexpected error. Check error details above.');
      console.log('You may need to regenerate the app password.\n');
    }
    
    process.exit(1);
  } else {
    console.log('? SUCCESS - Gmail App Password is WORKING!\n');
    console.log('????????????????????????????????????????');
    console.log('Message ID:', info.messageId);
    console.log('Response:', info.response);
    console.log('????????????????????????????????????????\n');
    console.log('?? CHECK YOUR EMAIL:\n');
    console.log('1. Check geo.elnajjar@gmail.com inbox');
    console.log('2. Check ceo@hopebearer-award.com inbox (if forwarding set up)');
    console.log('3. Look for subject: "? Test Email - Gmail App Password Verification"\n');
    console.log('? The email system is ready for production use!');
    console.log('   - Booking confirmations will work');
    console.log('   - Bulk emails will work');
    console.log('   - CEO will receive CC on all emails\n');
    
    process.exit(0);
  }
});
