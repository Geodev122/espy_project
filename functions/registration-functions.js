/**
 * Cloud Functions for Professional & Service Provider Registration
 * Handles user creation, file uploads, payments, and email notifications
 */

const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { Storage } = require('@google-cloud/storage');
const nodemailer = require('nodemailer');
const { fulfillMembership } = require('./src/membership-fulfillment');

// Initialize Firebase Admin (if not already initialized)
if (!admin.apps.length) {
  admin.initializeApp();
}

const db = admin.firestore();
const rtdb = admin.database();
const storage = new Storage();
const bucket = storage.bucket(functions.config().storage.bucket);


// ====================================
// 1. PROFESSIONAL REGISTRATION FUNCTIONS
// ====================================

/**
 * Create Professional Account (Step 1)
 * Triggered after Firebase Auth user creation
 */
exports.createProfessionalAccount = functions.auth.user().onCreate(async (user) => {
  // Only run if triggered from professional registration
  const customClaims = user.customClaims || {};
  if (customClaims.registrationType !== 'professional') {
    return null;
  }

  const professionalId = `professional_${Date.now()}_${generateRandomString(8)}`;

  try {
    // Create professional document in unified collection in RTDB
    await rtdb.ref(`directory_professionals/${professionalId}`).set({
      professionalId,
      userId: user.uid,
      type: 'professional', // Unified type field
      role: 'professional',
      email: user.email,
      createdAt: admin.database.ServerValue.TIMESTAMP,
      profileStatus: 'incomplete', // Will be 'pending_approval' after step 4
      isPublic: false,
      isActive: false,
      // Nested structure for compatibility with Directory API
      profile_data: {
        email: user.email,
        name_en: '',
        name_ar: '',
        whatsapp: ''
      },
      admin_status: {
        is_approved: false,
        is_active: false
      }
    });

    // Update user record with professional reference in RTDB
    await rtdb.ref(`users/${user.uid}`).set({
      uid: user.uid,
      email: user.email,
      role: 'professional',
      professionalId,
      professionalRef: `/professionals/${professionalId}`,
      emailVerified: user.emailVerified,
      createdAt: admin.database.ServerValue.TIMESTAMP,
      isActive: true
    });

    // Log registration
    await logRegistration({
      userId: user.uid,
      email: user.email,
      role: 'professional',
      professionalId,
      registrationStep: 'step1',
      metadata: { accountCreated: true }
    });

    console.log(`Professional account created: ${professionalId}`);
    return { success: true, professionalId };
  } catch (error) {
    console.error('Error creating professional account:', error);
    throw new functions.https.HttpsError('internal', 'Failed to create professional account');
  }
});

/**
 * Update Professional Personal Info (Step 2)
 */
exports.updateProfessionalPersonalInfo = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { professionalId, fullNameEn, fullNameAr, whatsappPhone } = data;

  try {
    await rtdb.ref(`directory_professionals/${professionalId}`).update({
      personalInfo: {
        fullNameEn,
        fullNameAr,
        whatsappPhone
      },
      // Keep profile_data in sync for Directory API
      'profile_data/name_en': fullNameEn,
      'profile_data/name_ar': fullNameAr,
      'profile_data/whatsapp': whatsappPhone,
      updatedAt: admin.database.ServerValue.TIMESTAMP
    });

    // Update user display name
    await admin.auth().updateUser(context.auth.uid, {
      displayName: fullNameEn
    });

    await logRegistration({
      userId: context.auth.uid,
      role: 'professional',
      professionalId,
      registrationStep: 'step2',
      metadata: { personalInfoAdded: true }
    });

    return { success: true, message: 'Personal info updated' };
  } catch (error) {
    console.error('Error updating personal info:', error);
    throw new functions.https.HttpsError('internal', 'Failed to update personal info');
  }
});

/**
 * Upload Professional Files (Step 3)
 * Handles license and profile picture uploads
 */
exports.uploadProfessionalFiles = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { professionalId, fileType, fileName, fileData, mimeType } = data;
  // fileData should be base64 encoded

  try {
    const fileExtension = fileName.split('.').pop();
    const sanitizedFileName = `${fileType}_${Date.now()}.${fileExtension}`;
    const storagePath = `professionals/${professionalId}/${sanitizedFileName}`;

    // Upload file to Cloud Storage
    const file = bucket.file(storagePath);
    const buffer = Buffer.from(fileData, 'base64');

    await file.save(buffer, {
      metadata: {
        contentType: mimeType,
        metadata: {
          uploadedBy: context.auth.uid,
          professionalId,
          fileType
        }
      }
    });

    // Get public URL
    await file.makePublic();
    const publicUrl = `https://storage.googleapis.com/${bucket.name}/${storagePath}`;

    // Log file upload in RTDB
    await rtdb.ref('file_uploads').push({
      uploadId: `upload_${Date.now()}`,
      fileName,
      fileType,
      mimeType,
      fileSize: buffer.length,
      storagePath,
      storageUrl: `gs://${bucket.name}/${storagePath}`,
      publicUrl,
      userId: context.auth.uid,
      professionalId,
      uploadStatus: 'completed',
      virusScanStatus: 'pending',
      uploadedAt: admin.database.ServerValue.TIMESTAMP
    });

    return { 
      success: true, 
      fileUrl: publicUrl,
      storagePath 
    };
  } catch (error) {
    console.error('Error uploading file:', error);
    throw new functions.https.HttpsError('internal', 'Failed to upload file');
  }
});

/**
 * Update Professional Details (Step 3)
 */
exports.updateProfessionalDetails = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { 
    professionalId, 
    specialtyEn, 
    specialtyAr, 
    yearsOfExperience,
    licenseUrl,
    profilePictureUrl
  } = data;

  try {
    await rtdb.ref(`directory_professionals/${professionalId}`).update({
      professionalDetails: {
        specialtyEn,
        specialtyAr,
        yearsOfExperience: parseInt(yearsOfExperience),
        licenseUrl,
        profilePictureUrl
      },
      // Keep profile_data in sync
      'profile_data/category_name': specialtyEn,
      'profile_data/photo_url': profilePictureUrl,
      updatedAt: admin.database.ServerValue.TIMESTAMP
    });

    // Update user photo URL
    if (profilePictureUrl) {
      await admin.auth().updateUser(context.auth.uid, {
        photoURL: profilePictureUrl
      });
    }

    await logRegistration({
      userId: context.auth.uid,
      role: 'professional',
      professionalId,
      registrationStep: 'step3',
      metadata: { 
        professionalDetailsAdded: true,
        filesUploaded: 2
      }
    });

    return { success: true, message: 'Professional details updated' };
  } catch (error) {
    console.error('Error updating professional details:', error);
    throw new functions.https.HttpsError('internal', 'Failed to update professional details');
  }
});

/**
 * Update Practice Locations & Authorizations (Step 4)
 */
exports.updateProfessionalLocations = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { 
    professionalId, 
    practiceLocations,
    hasOnlineConsultation,
    authorizations
  } = data;

  try {
    await rtdb.ref(`directory_professionals/${professionalId}`).update({
      practiceLocations,
      hasOnlineConsultation,
      authorizations: {
        ...authorizations,
        acceptedAt: admin.database.ServerValue.TIMESTAMP
      },
      profileStatus: 'pending_approval', // Ready for approval after completing step 4
      // Sync with Directory API fields
      'profile_data/online_practice': hasOnlineConsultation,
      updatedAt: admin.database.ServerValue.TIMESTAMP
    });

    await logRegistration({
      userId: context.auth.uid,
      role: 'professional',
      professionalId,
      registrationStep: 'step4',
      metadata: { 
        locationsAdded: true,
        locationCount: practiceLocations.length,
        onlineConsultation: hasOnlineConsultation
      }
    });

    return { success: true, message: 'Practice locations updated' };
  } catch (error) {
    console.error('Error updating practice locations:', error);
    throw new functions.https.HttpsError('internal', 'Failed to update practice locations');
  }
});

// ====================================
// 2. SERVICE PROVIDER REGISTRATION FUNCTIONS
// ====================================

/**
 * Create Service Provider Account (Step 1)
 */
exports.createServiceProviderAccount = functions.auth.user().onCreate(async (user) => {
  const customClaims = user.customClaims || {};
  if (customClaims.registrationType !== 'service_provider') {
    return null;
  }

  const providerId = `provider_${Date.now()}_${generateRandomString(8)}`;

  try {
    await rtdb.ref(`directory_professionals/${providerId}`).set({
      providerId,
      userId: user.uid,
      type: 'institution', // Unified type field
      role: 'service_provider',
      email: user.email,
      createdAt: admin.database.ServerValue.TIMESTAMP,
      profileStatus: 'incomplete',
      isPublic: false,
      isActive: false,
      services: [],
      // Nested structure for compatibility with Directory API
      profile_data: {
        email: user.email,
        name_en: '',
        name_ar: '',
      },
      admin_status: {
        is_approved: false,
        is_active: false
      }
    });

    await rtdb.ref(`users/${user.uid}`).set({
      uid: user.uid,
      email: user.email,
      role: 'service_provider',
      providerId,
      providerRef: `/service_providers/${providerId}`,
      emailVerified: user.emailVerified,
      createdAt: admin.database.ServerValue.TIMESTAMP,
      isActive: true
    });

    await logRegistration({
      userId: user.uid,
      email: user.email,
      role: 'service_provider',
      providerId,
      registrationStep: 'step1',
      metadata: { accountCreated: true }
    });

    console.log(`Service provider account created: ${providerId}`);
    return { success: true, providerId };
  } catch (error) {
    console.error('Error creating service provider account:', error);
    throw new functions.https.HttpsError('internal', 'Failed to create service provider account');
  }
});

/**
 * Update Service Provider Info & Services (Step 2)
 */
exports.updateServiceProviderServices = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { 
    providerId, 
    organizationNameEn,
    organizationNameAr,
    services 
  } = data;

  try {
    // Add serviceId to each service
    const servicesWithIds = services.map(service => ({
      ...service,
      serviceId: `service_${Date.now()}_${generateRandomString(6)}`
    }));

    await rtdb.ref(`directory_professionals/${providerId}`).update({
      organizationInfo: {
        nameEn: organizationNameEn,
        nameAr: organizationNameAr
      },
      // Sync with profile_data
      'profile_data/name_en': organizationNameEn,
      'profile_data/name_ar': organizationNameAr,
      services: servicesWithIds,
      profileStatus: 'pending_approval',
      updatedAt: admin.database.ServerValue.TIMESTAMP
    });

    await logRegistration({
      userId: context.auth.uid,
      role: 'service_provider',
      providerId,
      registrationStep: 'step2',
      metadata: { 
        servicesAdded: true,
        serviceCount: services.length
      }
    });

    return { success: true, message: 'Services updated', services: servicesWithIds };
  } catch (error) {
    console.error('Error updating services:', error);
    throw new functions.https.HttpsError('internal', 'Failed to update services');
  }
});

// ====================================
// 3. PAYMENT PROCESSING
// ====================================

/**
 * Process Payment Success (Step 5 for Professionals, Step 3 for Service Providers)
 */
exports.processPaymentSuccess = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }

  const { 
    role, // 'professional' or 'service_provider'
    profileId, // professionalId or providerId
    packageId,
    packageName,
    amount,
    whishPayOrderId,
    whishPayPaymentRef,
    subscriptionMonths
  } = data;

  try {
    // Perform Unified Fulfillment (100% Native Firestore)
    const fulfillmentResult = await fulfillMembership(
      profileId,
      packageId,
      {
        transactionId: whishPayPaymentRef || `reg_${profileId}_${Date.now()}`,
        amount: amount,
        currency: 'LBP',
        method: 'whishpay'
      }
    );

    // Update the transaction record with WhishPay specifics (RTDB)
    await rtdb.ref(`directory_membership_transactions/${whishPayOrderId || profileId}`).set({
      userId: context.auth.uid,
      userEmail: context.auth.token.email,
      profileId,
      packageId,
      packageName: fulfillmentResult.packageName,
      amount,
      currency: 'LBP',
      paymentMethod: 'whishpay',
      paymentStatus: 'completed',
      whishPayOrderId,
      whishPayPaymentRef,
      createdAt: admin.database.ServerValue.TIMESTAMP,
      completedAt: admin.database.ServerValue.TIMESTAMP,
    });

    // Send confirmation email
    await sendPaymentConfirmationEmail({
      email: context.auth.token.email,
      role,
      packageName: fulfillmentResult.packageName,
      amount,
      transactionId: whishPayPaymentRef || whishPayOrderId,
      subscriptionEndDate: new Date() // Placeholder, email should be updated to use fulfillment result if possible
    });

    return { 
      success: true, 
      message: 'Payment processed successfully',
      redirectToDashboard: true
    };
  } catch (error) {
    console.error('Error processing payment:', error);
    throw new functions.https.HttpsError('internal', 'Failed to process payment: ' + error.message);
  }
});

// ====================================
// 4. UTILITY FUNCTIONS
// ====================================

/**
 * Generate random string for IDs
 */
function generateRandomString(length) {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  let result = '';
  for (let i = 0; i < length; i++) {
    result += chars.charAt(Math.floor(Math.random() * chars.length));
  }
  return result;
}

/**
 * Log registration activity
 */
async function logRegistration(data) {
  await rtdb.ref('registration_logs').push({
    ...data,
    timestamp: admin.database.ServerValue.TIMESTAMP
  });
}

/**
 * Send payment confirmation email
 */
async function sendPaymentConfirmationEmail(data) {
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: functions.config().email.user,
      pass: functions.config().email.password
    }
  });

  const mailOptions = {
    from: functions.config().email.from,
    to: data.email,
    subject: 'Payment Confirmation - Hope Bearer Award Directory',
    html: `
      <h2>Payment Successful!</h2>
      <p>Dear ${data.role === 'professional' ? 'Professional' : 'Service Provider'},</p>
      <p>Your payment has been successfully processed.</p>
      
      <h3>Payment Details:</h3>
      <ul>
        <li><strong>Package:</strong> ${data.packageName}</li>
        <li><strong>Amount:</strong> ${data.amount.toLocaleString()} LBP</li>
        <li><strong>Transaction ID:</strong> ${data.transactionId}</li>
        <li><strong>Subscription Valid Until:</strong> ${data.subscriptionEndDate.toLocaleDateString()}</li>
      </ul>
      
      <p>You can now access your dashboard and manage your profile.</p>
      
      <p><a href="https://hope-bearer-award.web.app/#/admin/dashboard" style="background-color: #4F46E5; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block;">Go to Dashboard</a></p>
      
      <p>To manage your subscription or turn off auto-renewal, visit your account settings.</p>
      
      <p>Thank you for joining Hope Bearer Award Directory!</p>
    `
  };

  await transporter.sendMail(mailOptions);
}

// ====================================
// 5. ADMIN APPROVAL FUNCTIONS
// ====================================

/**
 * Approve Professional/Service Provider Profile
 */
exports.approveProfile = functions.https.onCall(async (data, context) => {
  // Check if caller is admin
  if (!context.auth || !context.auth.token.admin) {
    throw new functions.https.HttpsError('permission-denied', 'Only admins can approve profiles');
  }

  try {
    const { profileId, role } = data;
    const collectionName = role === 'professional' ? 'directory_professionals' : 'directory_institutions';

    await rtdb.ref(`${collectionName}/${profileId}`).update({
      profileStatus: 'approved',
      'admin_status/is_approved': true, // Sync with Directory API
      approvedAt: admin.database.ServerValue.TIMESTAMP,
      approvedBy: context.auth.uid
    });

    // Data Connect removed — approval is now 100% native Firestore/RTDB.

    // Send confirmation email
    await sendApprovalEmail({
      email: data.email,
      name: data.name,
      role: role
    });

    return { success: true, message: 'Profile approved' };
  } catch (error) {
    console.error('Error approving profile:', error);
    throw new functions.https.HttpsError('internal', 'Failed to approve profile: ' + error.message);
  }
});

/**
 * Send profile approval email
 */
async function sendApprovalEmail(email, role) {
  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: functions.config().email.user,
      pass: functions.config().email.password
    }
  });

  const mailOptions = {
    from: functions.config().email.from,
    to: email,
    subject: 'Profile Approved - Hope Bearer Award Directory',
    html: `
      <h2>Congratulations! Your Profile Has Been Approved</h2>
      <p>Dear ${role === 'professional' ? 'Professional' : 'Service Provider'},</p>
      <p>We are pleased to inform you that your profile has been approved and is now live on the Hope Bearer Award Directory.</p>
      
      <p>Your profile is now visible to patients searching for ${role === 'professional' ? 'healthcare professionals' : 'services'} in your area.</p>
      
      <p><a href="https://hope-bearer-award.web.app/directory/" style="background-color: #10B981; color: white; padding: 12px 24px; text-decoration: none; border-radius: 6px; display: inline-block;">View Your Public Profile</a></p>
      
      <p>You can update your profile anytime from your dashboard.</p>
      
      <p>Thank you for being part of Hope Bearer Award!</p>
    `
  };

  await transporter.sendMail(mailOptions);
}

module.exports = {
  createProfessionalAccount: exports.createProfessionalAccount,
  updateProfessionalPersonalInfo: exports.updateProfessionalPersonalInfo,
  uploadProfessionalFiles: exports.uploadProfessionalFiles,
  updateProfessionalDetails: exports.updateProfessionalDetails,
  updateProfessionalLocations: exports.updateProfessionalLocations,
  createServiceProviderAccount: exports.createServiceProviderAccount,
  updateServiceProviderServices: exports.updateServiceProviderServices,
  processPaymentSuccess: exports.processPaymentSuccess,
  approveProfile: exports.approveProfile
};
