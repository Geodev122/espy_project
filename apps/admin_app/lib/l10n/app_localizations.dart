import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Espy'**
  String get appTitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'GET STARTED'**
  String get getStarted;

  /// No description provided for @alreadyMember.
  ///
  /// In en, this message translates to:
  /// **'ALREADY A MEMBER? SIGN IN'**
  String get alreadyMember;

  /// No description provided for @protocolRegistration.
  ///
  /// In en, this message translates to:
  /// **'REGISTRATION PROTOCOL'**
  String get protocolRegistration;

  /// No description provided for @tellUsAboutYourself.
  ///
  /// In en, this message translates to:
  /// **'TELL US ABOUT\nYOURSELF'**
  String get tellUsAboutYourself;

  /// No description provided for @legalFullName.
  ///
  /// In en, this message translates to:
  /// **'LEGAL FULL NAME'**
  String get legalFullName;

  /// No description provided for @whatsappContact.
  ///
  /// In en, this message translates to:
  /// **'WHATSAPP CONTACT'**
  String get whatsappContact;

  /// No description provided for @professionalExpertise.
  ///
  /// In en, this message translates to:
  /// **'PROFESSIONAL\nEXPERTISE'**
  String get professionalExpertise;

  /// No description provided for @tellNetworkAboutYou.
  ///
  /// In en, this message translates to:
  /// **'TELL THE NETWORK ABOUT YOU'**
  String get tellNetworkAboutYou;

  /// No description provided for @nodesOfPresence.
  ///
  /// In en, this message translates to:
  /// **'PINS OF\nPRESENCE'**
  String get nodesOfPresence;

  /// No description provided for @mainHub.
  ///
  /// In en, this message translates to:
  /// **'MAIN HUB (PRIMARY PIN)'**
  String get mainHub;

  /// No description provided for @setPin.
  ///
  /// In en, this message translates to:
  /// **'SET PIN'**
  String get setPin;

  /// No description provided for @secondaryPresenceNodes.
  ///
  /// In en, this message translates to:
  /// **'SECONDARY PINS'**
  String get secondaryPresenceNodes;

  /// No description provided for @membershipTier.
  ///
  /// In en, this message translates to:
  /// **'MEMBERSHIP\nTIER'**
  String get membershipTier;

  /// No description provided for @payWithWhish.
  ///
  /// In en, this message translates to:
  /// **'PAY WITH WHISHPAY'**
  String get payWithWhish;

  /// No description provided for @almostThere.
  ///
  /// In en, this message translates to:
  /// **'ALMOST THERE'**
  String get almostThere;

  /// No description provided for @verificationIntegrity.
  ///
  /// In en, this message translates to:
  /// **'Your profile will undergo verification to maintain the integrity of the network.'**
  String get verificationIntegrity;

  /// No description provided for @submitForReview.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT FOR REVIEW'**
  String get submitForReview;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get continueText;

  /// No description provided for @sector.
  ///
  /// In en, this message translates to:
  /// **'SECTOR'**
  String get sector;

  /// No description provided for @professionalSector.
  ///
  /// In en, this message translates to:
  /// **'PROFESSIONAL SECTOR'**
  String get professionalSector;

  /// No description provided for @institutionSector.
  ///
  /// In en, this message translates to:
  /// **'INSTITUTION SECTOR'**
  String get institutionSector;

  /// No description provided for @selectSector.
  ///
  /// In en, this message translates to:
  /// **'SELECT SECTOR'**
  String get selectSector;

  /// No description provided for @specialization.
  ///
  /// In en, this message translates to:
  /// **'SPECIALIZATION'**
  String get specialization;

  /// No description provided for @institutionName.
  ///
  /// In en, this message translates to:
  /// **'INSTITUTION NAME'**
  String get institutionName;

  /// No description provided for @registrationNumber.
  ///
  /// In en, this message translates to:
  /// **'LICENSE / REGISTRATION #'**
  String get registrationNumber;

  /// No description provided for @missionDepartments.
  ///
  /// In en, this message translates to:
  /// **'MISSION &\nDEPARTMENTS'**
  String get missionDepartments;

  /// No description provided for @aboutInstitution.
  ///
  /// In en, this message translates to:
  /// **'ABOUT THE INSTITUTION'**
  String get aboutInstitution;

  /// No description provided for @departments.
  ///
  /// In en, this message translates to:
  /// **'DEPARTMENTS (Comma separated)'**
  String get departments;

  /// No description provided for @hubLocations.
  ///
  /// In en, this message translates to:
  /// **'HUB LOCATIONS'**
  String get hubLocations;

  /// No description provided for @primaryFacilityLocation.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY FACILITY LOCATION'**
  String get primaryFacilityLocation;

  /// No description provided for @protocolTier.
  ///
  /// In en, this message translates to:
  /// **'PROTOCOL\nTIER'**
  String get protocolTier;

  /// No description provided for @welcomeToNetwork.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO\nTHE NETWORK'**
  String get welcomeToNetwork;

  /// No description provided for @selectMission.
  ///
  /// In en, this message translates to:
  /// **'SELECT MISSION'**
  String get selectMission;

  /// No description provided for @displayName.
  ///
  /// In en, this message translates to:
  /// **'DISPLAY NAME'**
  String get displayName;

  /// No description provided for @whatsappOptional.
  ///
  /// In en, this message translates to:
  /// **'WHATSAPP (OPTIONAL)'**
  String get whatsappOptional;

  /// No description provided for @yourCareObjectives.
  ///
  /// In en, this message translates to:
  /// **'YOUR CARE\nOBJECTIVES'**
  String get yourCareObjectives;

  /// No description provided for @howCanWeHelp.
  ///
  /// In en, this message translates to:
  /// **'TELL US HOW WE CAN HELP'**
  String get howCanWeHelp;

  /// No description provided for @readyToExplore.
  ///
  /// In en, this message translates to:
  /// **'READY TO EXPLORE'**
  String get readyToExplore;

  /// No description provided for @profileSet.
  ///
  /// In en, this message translates to:
  /// **'Your profile is set. You can now access verified PINs and care protocols.'**
  String get profileSet;

  /// No description provided for @enterSuite.
  ///
  /// In en, this message translates to:
  /// **'ENTER SUITE'**
  String get enterSuite;

  /// No description provided for @definePresence.
  ///
  /// In en, this message translates to:
  /// **'DEFINE YOUR\nPRESENCE'**
  String get definePresence;

  /// No description provided for @visitor.
  ///
  /// In en, this message translates to:
  /// **'VISITOR'**
  String get visitor;

  /// No description provided for @visitorDesc.
  ///
  /// In en, this message translates to:
  /// **'Seeking support, care, and connection.'**
  String get visitorDesc;

  /// No description provided for @professional.
  ///
  /// In en, this message translates to:
  /// **'PROFESSIONAL'**
  String get professional;

  /// No description provided for @professionalDesc.
  ///
  /// In en, this message translates to:
  /// **'Verified specialist offering care PINs.'**
  String get professionalDesc;

  /// No description provided for @institution.
  ///
  /// In en, this message translates to:
  /// **'INSTITUTION'**
  String get institution;

  /// No description provided for @institutionDesc.
  ///
  /// In en, this message translates to:
  /// **'Hospitals, clinics, or support centers.'**
  String get institutionDesc;

  /// No description provided for @theProtocol.
  ///
  /// In en, this message translates to:
  /// **'THE PROTOCOL'**
  String get theProtocol;

  /// No description provided for @createIdentity.
  ///
  /// In en, this message translates to:
  /// **'CREATE IDENTITY'**
  String get createIdentity;

  /// No description provided for @accessPortal.
  ///
  /// In en, this message translates to:
  /// **'ACCESS PORTAL'**
  String get accessPortal;

  /// No description provided for @registeringAs.
  ///
  /// In en, this message translates to:
  /// **'REGISTERING AS'**
  String get registeringAs;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'EMAIL ADDRESS'**
  String get emailAddress;

  /// No description provided for @securePassword.
  ///
  /// In en, this message translates to:
  /// **'SECURE PASSWORD'**
  String get securePassword;

  /// No description provided for @syncing.
  ///
  /// In en, this message translates to:
  /// **'SYNCING...'**
  String get syncing;

  /// No description provided for @initializeAccount.
  ///
  /// In en, this message translates to:
  /// **'INITIALIZE ACCOUNT'**
  String get initializeAccount;

  /// No description provided for @secureLogin.
  ///
  /// In en, this message translates to:
  /// **'SECURE LOGIN'**
  String get secureLogin;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE WITH GOOGLE'**
  String get continueWithGoogle;

  /// No description provided for @newToProtocol.
  ///
  /// In en, this message translates to:
  /// **'NEW TO THE PROTOCOL? '**
  String get newToProtocol;

  /// No description provided for @alreadyPartOfNetwork.
  ///
  /// In en, this message translates to:
  /// **'ALREADY PART OF THE NETWORK? '**
  String get alreadyPartOfNetwork;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'LOGIN'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'REGISTER'**
  String get register;

  /// No description provided for @directory.
  ///
  /// In en, this message translates to:
  /// **'DIRECTORY'**
  String get directory;

  /// No description provided for @requests.
  ///
  /// In en, this message translates to:
  /// **'REQUESTS'**
  String get requests;

  /// No description provided for @services.
  ///
  /// In en, this message translates to:
  /// **'SERVICES'**
  String get services;

  /// No description provided for @match.
  ///
  /// In en, this message translates to:
  /// **'MATCH'**
  String get match;

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE'**
  String get explore;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'HELP'**
  String get help;

  /// No description provided for @vault.
  ///
  /// In en, this message translates to:
  /// **'WALLET'**
  String get vault;

  /// No description provided for @hopeSuite.
  ///
  /// In en, this message translates to:
  /// **'ESPY'**
  String get hopeSuite;

  /// No description provided for @swipe.
  ///
  /// In en, this message translates to:
  /// **'SWIPE'**
  String get swipe;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'MAP'**
  String get map;

  /// No description provided for @searchVerifiedNodes.
  ///
  /// In en, this message translates to:
  /// **'Search verified PINs...'**
  String get searchVerifiedNodes;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'ALL'**
  String get all;

  /// No description provided for @noPendingRequests.
  ///
  /// In en, this message translates to:
  /// **'NO PENDING REQUESTS'**
  String get noPendingRequests;

  /// No description provided for @careProtocolSwipe.
  ///
  /// In en, this message translates to:
  /// **'CARE PROTOCOL SWIPE'**
  String get careProtocolSwipe;

  /// No description provided for @matchInterest.
  ///
  /// In en, this message translates to:
  /// **'MATCH INTEREST'**
  String get matchInterest;

  /// No description provided for @matchInterestDesc.
  ///
  /// In en, this message translates to:
  /// **'A care professional has expressed interest in your protocol request.'**
  String get matchInterestDesc;

  /// No description provided for @protocolServices.
  ///
  /// In en, this message translates to:
  /// **'PROTOCOL SERVICES'**
  String get protocolServices;

  /// No description provided for @totalSlots.
  ///
  /// In en, this message translates to:
  /// **'TOTAL SLOTS'**
  String get totalSlots;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'USED'**
  String get used;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE'**
  String get available;

  /// No description provided for @listNewService.
  ///
  /// In en, this message translates to:
  /// **'LIST NEW SERVICE'**
  String get listNewService;

  /// No description provided for @noActiveListings.
  ///
  /// In en, this message translates to:
  /// **'NO ACTIVE LISTINGS'**
  String get noActiveListings;

  /// No description provided for @vaultSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'ESPY WALLET'**
  String get vaultSubscriptions;

  /// No description provided for @protocolStatus.
  ///
  /// In en, this message translates to:
  /// **'PROTOCOL STATUS'**
  String get protocolStatus;

  /// No description provided for @activeMember.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE MEMBER'**
  String get activeMember;

  /// No description provided for @pendingActivation.
  ///
  /// In en, this message translates to:
  /// **'PENDING ACTIVATION'**
  String get pendingActivation;

  /// No description provided for @compiledUnits.
  ///
  /// In en, this message translates to:
  /// **'COMPILED UNITS'**
  String get compiledUnits;

  /// No description provided for @slots.
  ///
  /// In en, this message translates to:
  /// **'SLOTS'**
  String get slots;

  /// No description provided for @pins.
  ///
  /// In en, this message translates to:
  /// **'PINS'**
  String get pins;

  /// No description provided for @activeMemberDesc.
  ///
  /// In en, this message translates to:
  /// **'Your care PINs are visible to the entire network.'**
  String get activeMemberDesc;

  /// No description provided for @pendingActivationDesc.
  ///
  /// In en, this message translates to:
  /// **'Awaiting payment verification to activate your visibility.'**
  String get pendingActivationDesc;

  /// No description provided for @membershipTiers.
  ///
  /// In en, this message translates to:
  /// **'MEMBERSHIP TIERS'**
  String get membershipTiers;

  /// No description provided for @upgrade.
  ///
  /// In en, this message translates to:
  /// **'UPGRADE'**
  String get upgrade;

  /// No description provided for @vaultLogs.
  ///
  /// In en, this message translates to:
  /// **'WALLET LEDGER'**
  String get vaultLogs;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'EXPIRED'**
  String get expired;

  /// No description provided for @permanent.
  ///
  /// In en, this message translates to:
  /// **'PERMANENT'**
  String get permanent;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'DAYS LEFT'**
  String get daysLeft;

  /// No description provided for @hoursLeft.
  ///
  /// In en, this message translates to:
  /// **'HOURS LEFT'**
  String get hoursLeft;

  /// No description provided for @emergencyAddressBook.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY ADDRESS BOOK'**
  String get emergencyAddressBook;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get language;

  /// No description provided for @locationSettings.
  ///
  /// In en, this message translates to:
  /// **'LOCATION SETTINGS'**
  String get locationSettings;

  /// No description provided for @serviceManager.
  ///
  /// In en, this message translates to:
  /// **'SERVICE MANAGER'**
  String get serviceManager;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get editProfile;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'NOTIFICATIONS'**
  String get notifications;

  /// No description provided for @privacyVault.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY CENTER'**
  String get privacyVault;

  /// No description provided for @signOutProtocol.
  ///
  /// In en, this message translates to:
  /// **'SIGN OUT OF PROTOCOL'**
  String get signOutProtocol;

  /// No description provided for @identityVerified.
  ///
  /// In en, this message translates to:
  /// **'IDENTITY VERIFIED'**
  String get identityVerified;

  /// No description provided for @pendingActivationShort.
  ///
  /// In en, this message translates to:
  /// **'PENDING ACTIVATION'**
  String get pendingActivationShort;

  /// No description provided for @identityVerifiedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your professional data is protected.'**
  String get identityVerifiedDesc;

  /// No description provided for @visitorVerifiedDesc.
  ///
  /// In en, this message translates to:
  /// **'Your visitor access is active and secured.'**
  String get visitorVerifiedDesc;

  /// No description provided for @pendingActivationDescShort.
  ///
  /// In en, this message translates to:
  /// **'Awaiting final verification and funding.'**
  String get pendingActivationDescShort;

  /// No description provided for @paymentPending.
  ///
  /// In en, this message translates to:
  /// **'LOW BALANCE'**
  String get paymentPending;

  /// No description provided for @profileHiddenDesc.
  ///
  /// In en, this message translates to:
  /// **'Your profile visibility or extra PINs may be limited. Recharge your wallet.'**
  String get profileHiddenDesc;

  /// No description provided for @fundNow.
  ///
  /// In en, this message translates to:
  /// **'RECHARGE'**
  String get fundNow;

  /// No description provided for @broadcast.
  ///
  /// In en, this message translates to:
  /// **'BROADCAST'**
  String get broadcast;

  /// No description provided for @exploreNodes.
  ///
  /// In en, this message translates to:
  /// **'EXPLORE PINS'**
  String get exploreNodes;

  /// No description provided for @mapFilters.
  ///
  /// In en, this message translates to:
  /// **'MAP FILTERS'**
  String get mapFilters;

  /// No description provided for @distanceThreshold.
  ///
  /// In en, this message translates to:
  /// **'DISTANCE THRESHOLD'**
  String get distanceThreshold;

  /// No description provided for @careSector.
  ///
  /// In en, this message translates to:
  /// **'CARE SECTOR'**
  String get careSector;

  /// No description provided for @radius.
  ///
  /// In en, this message translates to:
  /// **'RADIUS'**
  String get radius;

  /// No description provided for @noSectorsAvailable.
  ///
  /// In en, this message translates to:
  /// **'NO SECTORS AVAILABLE'**
  String get noSectorsAvailable;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'SELECT CATEGORY'**
  String get selectCategory;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'NO CATEGORIES FOUND FOR THIS SECTOR'**
  String get noCategoriesFound;

  /// No description provided for @tellUsAboutYourselfDesc.
  ///
  /// In en, this message translates to:
  /// **'Tell us about yourself'**
  String get tellUsAboutYourselfDesc;

  /// No description provided for @almostThereTitle.
  ///
  /// In en, this message translates to:
  /// **'Almost there'**
  String get almostThereTitle;

  /// No description provided for @totalEstimate.
  ///
  /// In en, this message translates to:
  /// **'TOTAL ESTIMATE'**
  String get totalEstimate;

  /// No description provided for @visibilityNodes.
  ///
  /// In en, this message translates to:
  /// **'VISIBILITY PINS'**
  String get visibilityNodes;

  /// No description provided for @serviceSlots.
  ///
  /// In en, this message translates to:
  /// **'SERVICE SLOTS'**
  String get serviceSlots;

  /// No description provided for @practiceAreaPins.
  ///
  /// In en, this message translates to:
  /// **'PRACTICE AREA PINS'**
  String get practiceAreaPins;

  /// No description provided for @visibilityNodesDesc.
  ///
  /// In en, this message translates to:
  /// **'Activates your profile in the directory for 30 days. Required for searchability.'**
  String get visibilityNodesDesc;

  /// No description provided for @serviceSlotsDesc.
  ///
  /// In en, this message translates to:
  /// **'Enables listing of 1 specific care protocol or service. Each slot hosts 1 listing.'**
  String get serviceSlotsDesc;

  /// No description provided for @practicePinsDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock additional geographic PINs for added practice locations.'**
  String get practicePinsDesc;

  /// No description provided for @additionalNodesDesc.
  ///
  /// In en, this message translates to:
  /// **'Additional practice area PINs can be unlocked via the Espy Store using tokens.'**
  String get additionalNodesDesc;

  /// No description provided for @institutionCategory.
  ///
  /// In en, this message translates to:
  /// **'INSTITUTION CATEGORY'**
  String get institutionCategory;

  /// No description provided for @aboutInstitutionDesc.
  ///
  /// In en, this message translates to:
  /// **'Describe your clinical services and facilities...'**
  String get aboutInstitutionDesc;

  /// No description provided for @departmentsDesc.
  ///
  /// In en, this message translates to:
  /// **'e.g. ER, Radiology, Cardiology'**
  String get departmentsDesc;

  /// No description provided for @departmentsArDesc.
  ///
  /// In en, this message translates to:
  /// **'مثلاً: الطوارئ، الأشعة، القلب'**
  String get departmentsArDesc;

  /// No description provided for @primaryFacilityLocationDesc.
  ///
  /// In en, this message translates to:
  /// **'Primary facility location'**
  String get primaryFacilityLocationDesc;

  /// No description provided for @protocolTierTitle.
  ///
  /// In en, this message translates to:
  /// **'Protocol Tier'**
  String get protocolTierTitle;

  /// No description provided for @institutionVisibilityDesc.
  ///
  /// In en, this message translates to:
  /// **'Activates your institutional profile in the directory for 30 days. High-impact visibility.'**
  String get institutionVisibilityDesc;

  /// No description provided for @institutionSlotsDesc.
  ///
  /// In en, this message translates to:
  /// **'Enables listing of institutional departments or specific care services.'**
  String get institutionSlotsDesc;

  /// No description provided for @institutionPinsDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlock additional geographic PINs for clinical branches or facility locations.'**
  String get institutionPinsDesc;

  /// No description provided for @paymentRequired.
  ///
  /// In en, this message translates to:
  /// **'RECHARGE REQUIRED'**
  String get paymentRequired;

  /// No description provided for @nameAndCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Name and Category are required.'**
  String get nameAndCategoryRequired;

  /// No description provided for @nameSectorCategoryRequired.
  ///
  /// In en, this message translates to:
  /// **'Name, Sector, and Category are required.'**
  String get nameSectorCategoryRequired;

  /// No description provided for @primaryNodeRequired.
  ///
  /// In en, this message translates to:
  /// **'Primary node location is required.'**
  String get primaryNodeRequired;

  /// No description provided for @submitting.
  ///
  /// In en, this message translates to:
  /// **'SUBMITTING...'**
  String get submitting;

  /// No description provided for @hopeBearer.
  ///
  /// In en, this message translates to:
  /// **'THE HOPE'**
  String get hopeBearer;

  /// No description provided for @suite.
  ///
  /// In en, this message translates to:
  /// **'ESPY'**
  String get suite;

  /// No description provided for @findHope.
  ///
  /// In en, this message translates to:
  /// **'FIND HOPE'**
  String get findHope;

  /// No description provided for @registerProfessional.
  ///
  /// In en, this message translates to:
  /// **'REGISTER PROFESSIONAL'**
  String get registerProfessional;

  /// No description provided for @registerInstitution.
  ///
  /// In en, this message translates to:
  /// **'REGISTER INSTITUTION'**
  String get registerInstitution;

  /// No description provided for @networkTagline.
  ///
  /// In en, this message translates to:
  /// **'CONNECT WITH VERIFIED CARE PINS IN THE NETWORK.'**
  String get networkTagline;

  /// No description provided for @editProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'EDIT PROFILE'**
  String get editProfileTitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'FULL NAME'**
  String get fullName;

  /// No description provided for @bioEn.
  ///
  /// In en, this message translates to:
  /// **'BIO (EN)'**
  String get bioEn;

  /// No description provided for @bioAr.
  ///
  /// In en, this message translates to:
  /// **'BIO (AR)'**
  String get bioAr;

  /// No description provided for @code.
  ///
  /// In en, this message translates to:
  /// **'CODE'**
  String get code;

  /// No description provided for @whatsappNumber.
  ///
  /// In en, this message translates to:
  /// **'WHATSAPP NUMBER'**
  String get whatsappNumber;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'SAVE CHANGES'**
  String get saveChanges;

  /// No description provided for @smartMatch.
  ///
  /// In en, this message translates to:
  /// **'SMART MATCH'**
  String get smartMatch;

  /// No description provided for @noNewNodesFound.
  ///
  /// In en, this message translates to:
  /// **'NO NEW PINS FOUND'**
  String get noNewNodesFound;

  /// No description provided for @professionalLabel.
  ///
  /// In en, this message translates to:
  /// **'Professional'**
  String get professionalLabel;

  /// No description provided for @specialist.
  ///
  /// In en, this message translates to:
  /// **'SPECIALIST'**
  String get specialist;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @defaultBio.
  ///
  /// In en, this message translates to:
  /// **'Dedicated healthcare professional providing verified care and expertise to the Lebanon network.'**
  String get defaultBio;

  /// No description provided for @emergencyAddressBookTitle.
  ///
  /// In en, this message translates to:
  /// **'EMERGENCY ADDRESS BOOK'**
  String get emergencyAddressBookTitle;

  /// No description provided for @noEmergencyChannels.
  ///
  /// In en, this message translates to:
  /// **'NO EMERGENCY CHANNELS'**
  String get noEmergencyChannels;

  /// No description provided for @accountExists.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT EXISTS'**
  String get accountExists;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered as a {role}.'**
  String emailAlreadyRegistered(Object role);

  /// No description provided for @roleLimitInfo.
  ///
  /// In en, this message translates to:
  /// **'Each email address is limited to one care protocol role.'**
  String get roleLimitInfo;

  /// No description provided for @goToDashboard.
  ///
  /// In en, this message translates to:
  /// **'GO TO DASHBOARD'**
  String get goToDashboard;

  /// No description provided for @saving.
  ///
  /// In en, this message translates to:
  /// **'SAVING...'**
  String get saving;

  /// No description provided for @nodeBroadcasts.
  ///
  /// In en, this message translates to:
  /// **'PIN BROADCASTS'**
  String get nodeBroadcasts;

  /// No description provided for @dispatchAnnouncement.
  ///
  /// In en, this message translates to:
  /// **'DISPATCH ANNOUNCEMENT'**
  String get dispatchAnnouncement;

  /// No description provided for @broadcastDesc.
  ///
  /// In en, this message translates to:
  /// **'Send a push notification to all visitors registered on the protocol, targeted by country.'**
  String get broadcastDesc;

  /// No description provided for @targetAudience.
  ///
  /// In en, this message translates to:
  /// **'TARGET AUDIENCE'**
  String get targetAudience;

  /// No description provided for @broadcastTitle.
  ///
  /// In en, this message translates to:
  /// **'BROADCAST TITLE'**
  String get broadcastTitle;

  /// No description provided for @messageContent.
  ///
  /// In en, this message translates to:
  /// **'MESSAGE CONTENT'**
  String get messageContent;

  /// No description provided for @dispatching.
  ///
  /// In en, this message translates to:
  /// **'DISPATCHING...'**
  String get dispatching;

  /// No description provided for @dispatchBroadcast.
  ///
  /// In en, this message translates to:
  /// **'DISPATCH BROADCAST'**
  String get dispatchBroadcast;

  /// No description provided for @pleaseFillAllFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields.'**
  String get pleaseFillAllFields;

  /// No description provided for @broadcastQueued.
  ///
  /// In en, this message translates to:
  /// **'Broadcast queued for delivery.'**
  String get broadcastQueued;

  /// No description provided for @communityFeed.
  ///
  /// In en, this message translates to:
  /// **'COMMUNITY FEED'**
  String get communityFeed;

  /// No description provided for @myRequests.
  ///
  /// In en, this message translates to:
  /// **'MY REQUESTS'**
  String get myRequests;

  /// No description provided for @postRequest.
  ///
  /// In en, this message translates to:
  /// **'POST REQUEST'**
  String get postRequest;

  /// No description provided for @postCareRequest.
  ///
  /// In en, this message translates to:
  /// **'POST CARE REQUEST'**
  String get postCareRequest;

  /// No description provided for @submitProtocolRequest.
  ///
  /// In en, this message translates to:
  /// **'SUBMIT PROTOCOL REQUEST'**
  String get submitProtocolRequest;

  /// No description provided for @careProtocol.
  ///
  /// In en, this message translates to:
  /// **'CARE PROTOCOL'**
  String get careProtocol;

  /// No description provided for @noOwnRequests.
  ///
  /// In en, this message translates to:
  /// **'YOU HAVE NO REQUESTS'**
  String get noOwnRequests;

  /// No description provided for @noActiveRequests.
  ///
  /// In en, this message translates to:
  /// **'NO ACTIVE REQUESTS'**
  String get noActiveRequests;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE'**
  String get active;

  /// No description provided for @respond.
  ///
  /// In en, this message translates to:
  /// **'RESPOND'**
  String get respond;

  /// No description provided for @myPost.
  ///
  /// In en, this message translates to:
  /// **'MY POST'**
  String get myPost;

  /// No description provided for @requestPublished.
  ///
  /// In en, this message translates to:
  /// **'Request published to the community.'**
  String get requestPublished;

  /// No description provided for @responseLogged.
  ///
  /// In en, this message translates to:
  /// **'Response logged. Connecting...'**
  String get responseLogged;

  /// No description provided for @serviceProtocol.
  ///
  /// In en, this message translates to:
  /// **'SERVICE PROTOCOL'**
  String get serviceProtocol;

  /// No description provided for @identityAndContent.
  ///
  /// In en, this message translates to:
  /// **'IDENTITY & CONTENT'**
  String get identityAndContent;

  /// No description provided for @pricingProtocolHint.
  ///
  /// In en, this message translates to:
  /// **'PRICING PROTOCOL (HINT)'**
  String get pricingProtocolHint;

  /// No description provided for @noPricingTags.
  ///
  /// In en, this message translates to:
  /// **'NO PRICING TAGS CONFIGURED'**
  String get noPricingTags;

  /// No description provided for @selectPricingHint.
  ///
  /// In en, this message translates to:
  /// **'SELECT PRICING HINT'**
  String get selectPricingHint;

  /// No description provided for @uploadPreview.
  ///
  /// In en, this message translates to:
  /// **'UPLOAD 16:9 PREVIEW'**
  String get uploadPreview;

  /// No description provided for @serviceTitle.
  ///
  /// In en, this message translates to:
  /// **'SERVICE TITLE'**
  String get serviceTitle;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'DESCRIPTION'**
  String get description;

  /// No description provided for @reachAndContact.
  ///
  /// In en, this message translates to:
  /// **'REACH & CONTACT'**
  String get reachAndContact;

  /// No description provided for @locationAttachment.
  ///
  /// In en, this message translates to:
  /// **'LOCATION ATTACHMENT'**
  String get locationAttachment;

  /// No description provided for @onlineDelivery.
  ///
  /// In en, this message translates to:
  /// **'Online Delivery (Global)'**
  String get onlineDelivery;

  /// No description provided for @primaryHub.
  ///
  /// In en, this message translates to:
  /// **'Primary Hub'**
  String get primaryHub;

  /// No description provided for @whatsappConfig.
  ///
  /// In en, this message translates to:
  /// **'WHATSAPP CONFIGURATION'**
  String get whatsappConfig;

  /// No description provided for @useProfileDefault.
  ///
  /// In en, this message translates to:
  /// **'Use Profile Default'**
  String get useProfileDefault;

  /// No description provided for @slotAllocation.
  ///
  /// In en, this message translates to:
  /// **'SLOT ALLOCATION'**
  String get slotAllocation;

  /// No description provided for @noAvailableSlots.
  ///
  /// In en, this message translates to:
  /// **'No available slots. Purchase more in the Wallet Store.'**
  String get noAvailableSlots;

  /// No description provided for @slotNode.
  ///
  /// In en, this message translates to:
  /// **'SLOT PIN'**
  String get slotNode;

  /// No description provided for @listing.
  ///
  /// In en, this message translates to:
  /// **'LISTING...'**
  String get listing;

  /// No description provided for @listService.
  ///
  /// In en, this message translates to:
  /// **'LIST SERVICE'**
  String get listService;

  /// No description provided for @selectSlotError.
  ///
  /// In en, this message translates to:
  /// **'Please select a slot.'**
  String get selectSlotError;

  /// No description provided for @aboutTheNode.
  ///
  /// In en, this message translates to:
  /// **'ABOUT THE PIN'**
  String get aboutTheNode;

  /// No description provided for @expertiseAndServices.
  ///
  /// In en, this message translates to:
  /// **'EXPERTISE & SERVICES'**
  String get expertiseAndServices;

  /// No description provided for @reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get reviews;

  /// No description provided for @defaultBioLong.
  ///
  /// In en, this message translates to:
  /// **'Dedicated to providing exceptional care and expertise within the Espy Protocol. This verified PIN has undergone rigorous vetting to ensure quality of service.'**
  String get defaultBioLong;

  /// No description provided for @secureWhatsappContact.
  ///
  /// In en, this message translates to:
  /// **'SECURE WHATSAPP CONTACT'**
  String get secureWhatsappContact;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'FAVORITE'**
  String get favorite;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'SHARE'**
  String get share;

  /// No description provided for @privacyVaultTitle.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY CENTER'**
  String get privacyVaultTitle;

  /// No description provided for @dataPrivacyProtocol.
  ///
  /// In en, this message translates to:
  /// **'DATA PRIVACY PROTOCOL'**
  String get dataPrivacyProtocol;

  /// No description provided for @privacyPolicyDesc.
  ///
  /// In en, this message translates to:
  /// **'Your data is protected under our secondary encryption layer. By using Espy, you agree to make your clinical expertise and PIN presence public to the care network. We do not sell or trade your data with third-party advertising algorithms.'**
  String get privacyPolicyDesc;

  /// No description provided for @contactAdmin.
  ///
  /// In en, this message translates to:
  /// **'CONTACT ADMIN'**
  String get contactAdmin;

  /// No description provided for @privacyConcernHint.
  ///
  /// In en, this message translates to:
  /// **'Describe your privacy concern or request...'**
  String get privacyConcernHint;

  /// No description provided for @sending.
  ///
  /// In en, this message translates to:
  /// **'SENDING...'**
  String get sending;

  /// No description provided for @sendMessage.
  ///
  /// In en, this message translates to:
  /// **'SEND MESSAGE'**
  String get sendMessage;

  /// No description provided for @messageDispatched.
  ///
  /// In en, this message translates to:
  /// **'Message dispatched to Admin.'**
  String get messageDispatched;

  /// No description provided for @networkNotifications.
  ///
  /// In en, this message translates to:
  /// **'NETWORK NOTIFICATIONS'**
  String get networkNotifications;

  /// No description provided for @noNewProtocols.
  ///
  /// In en, this message translates to:
  /// **'NO NEW PROTOCOLS'**
  String get noNewProtocols;

  /// No description provided for @global.
  ///
  /// In en, this message translates to:
  /// **'GLOBAL'**
  String get global;

  /// No description provided for @receivedByProtocol.
  ///
  /// In en, this message translates to:
  /// **'RECEIVED BY SYSTEM PROTOCOL'**
  String get receivedByProtocol;

  /// No description provided for @legalFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Jean Doe'**
  String get legalFullNameHint;

  /// No description provided for @whatsappCodeHint.
  ///
  /// In en, this message translates to:
  /// **'+961'**
  String get whatsappCodeHint;

  /// No description provided for @whatsappNumberHint.
  ///
  /// In en, this message translates to:
  /// **'XX XXX XXX'**
  String get whatsappNumberHint;

  /// No description provided for @noPinDropped.
  ///
  /// In en, this message translates to:
  /// **'No pin dropped yet.'**
  String get noPinDropped;

  /// No description provided for @primaryNodeInfo.
  ///
  /// In en, this message translates to:
  /// **'Your profile registration includes 1 free primary PIN. Additional PINs can be managed in your Wallet Store.'**
  String get primaryNodeInfo;

  /// No description provided for @professionalDashboardRedir.
  ///
  /// In en, this message translates to:
  /// **'Your clinical profile is now ready for initialization. Once you finalize, you will gain access to your professional dashboard.'**
  String get professionalDashboardRedir;

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO THE PROTOCOL'**
  String get welcomeTitle;

  /// No description provided for @welcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your profile is initialized. Your primary hub is now active on the map. To add more pins or list services, visit your Espy Wallet.'**
  String get welcomeMessage;

  /// No description provided for @submissionError.
  ///
  /// In en, this message translates to:
  /// **'Submission Error'**
  String get submissionError;

  /// No description provided for @setMainNode.
  ///
  /// In en, this message translates to:
  /// **'SET MAIN NODE'**
  String get setMainNode;

  /// No description provided for @viewProfile.
  ///
  /// In en, this message translates to:
  /// **'VIEW PROFILE'**
  String get viewProfile;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'CLOSE'**
  String get close;

  /// No description provided for @specialistAr.
  ///
  /// In en, this message translates to:
  /// **'Specialist'**
  String get specialistAr;

  /// No description provided for @institutionDashboardRedir.
  ///
  /// In en, this message translates to:
  /// **'Your institutional profile is ready for activation. You will now be redirected to your dashboard.'**
  String get institutionDashboardRedir;

  /// No description provided for @instWelcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'INSTITUTIONAL INITIALIZATION'**
  String get instWelcomeTitle;

  /// No description provided for @instWelcomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Congratulations! Your institution is registered. Your main facility is now active on the map. To expand your capacity, visit your Espy Wallet.'**
  String get instWelcomeMessage;

  /// No description provided for @systemOverview.
  ///
  /// In en, this message translates to:
  /// **'SYSTEM OVERVIEW'**
  String get systemOverview;

  /// No description provided for @visibility.
  ///
  /// In en, this message translates to:
  /// **'VISIBILITY'**
  String get visibility;

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'DAYS REMAINING'**
  String get daysRemaining;

  /// No description provided for @visibilityExtended.
  ///
  /// In en, this message translates to:
  /// **'VISIBILITY EXTENDED BY 30 DAYS'**
  String get visibilityExtended;

  /// No description provided for @protocolSavedFavorites.
  ///
  /// In en, this message translates to:
  /// **'Protocol saved to Vault Favorites'**
  String get protocolSavedFavorites;

  /// No description provided for @protocolScanComplete.
  ///
  /// In en, this message translates to:
  /// **'PROTOCOL SCAN COMPLETE'**
  String get protocolScanComplete;

  /// No description provided for @reviewedAllProtocols.
  ///
  /// In en, this message translates to:
  /// **'You have reviewed all active protocols.'**
  String get reviewedAllProtocols;

  /// No description provided for @swipeToBegin.
  ///
  /// In en, this message translates to:
  /// **'SWIPE TO BEGIN'**
  String get swipeToBegin;

  /// No description provided for @noActiveServicesFound.
  ///
  /// In en, this message translates to:
  /// **'NO ACTIVE SERVICES FOUND'**
  String get noActiveServicesFound;

  /// No description provided for @queueCleared.
  ///
  /// In en, this message translates to:
  /// **'QUEUE CLEARED'**
  String get queueCleared;

  /// No description provided for @reviewedAllRequests.
  ///
  /// In en, this message translates to:
  /// **'You have reviewed all active community requests.'**
  String get reviewedAllRequests;

  /// No description provided for @requestFilters.
  ///
  /// In en, this message translates to:
  /// **'REQUEST FILTERS'**
  String get requestFilters;

  /// No description provided for @newestFirst.
  ///
  /// In en, this message translates to:
  /// **'NEWEST FIRST'**
  String get newestFirst;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'UPDATE'**
  String get update;

  /// No description provided for @limitReached.
  ///
  /// In en, this message translates to:
  /// **'LIMIT REACHED'**
  String get limitReached;

  /// No description provided for @visitWalletPurchasePins.
  ///
  /// In en, this message translates to:
  /// **'Visit Espy Wallet to purchase more PINs.'**
  String get visitWalletPurchasePins;

  /// No description provided for @signInViewNotifications.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view notifications'**
  String get signInViewNotifications;

  /// No description provided for @paymentProtocols.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT PROTOCOLS'**
  String get paymentProtocols;

  /// No description provided for @authorizedPersonnelOnly.
  ///
  /// In en, this message translates to:
  /// **'Authorized personnel only.'**
  String get authorizedPersonnelOnly;

  /// No description provided for @noTransactionLogs.
  ///
  /// In en, this message translates to:
  /// **'NO TRANSACTION LOGS'**
  String get noTransactionLogs;

  /// No description provided for @espyStore.
  ///
  /// In en, this message translates to:
  /// **'ESPY STORE'**
  String get espyStore;

  /// No description provided for @espyTokens.
  ///
  /// In en, this message translates to:
  /// **'ESPY TOKENS'**
  String get espyTokens;

  /// No description provided for @successAddedTokens.
  ///
  /// In en, this message translates to:
  /// **'SUCCESS! ADDED {amount} TOKENS'**
  String successAddedTokens(Object amount);

  /// No description provided for @selectPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'SELECT PAYMENT METHOD'**
  String get selectPaymentMethod;

  /// No description provided for @whishPaySecure.
  ///
  /// In en, this message translates to:
  /// **'WHISH PAY SECURE'**
  String get whishPaySecure;

  /// No description provided for @paymentCompleted.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT COMPLETED'**
  String get paymentCompleted;

  /// No description provided for @successfullyActivated.
  ///
  /// In en, this message translates to:
  /// **'SUCCESSFULLY ACTIVATED {item}'**
  String successfullyActivated(Object item);

  /// No description provided for @signInViewFavorites.
  ///
  /// In en, this message translates to:
  /// **'Sign in to view favorites'**
  String get signInViewFavorites;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'CURRENT BALANCE'**
  String get currentBalance;

  /// No description provided for @broadcastHistory.
  ///
  /// In en, this message translates to:
  /// **'BROADCAST HISTORY'**
  String get broadcastHistory;

  /// No description provided for @noBroadcastsSent.
  ///
  /// In en, this message translates to:
  /// **'NO BROADCASTS SENT'**
  String get noBroadcastsSent;

  /// No description provided for @allocationAnchors.
  ///
  /// In en, this message translates to:
  /// **'ALLOCATION & ANCHORS'**
  String get allocationAnchors;

  /// No description provided for @primaryHubPin.
  ///
  /// In en, this message translates to:
  /// **'PRIMARY HUB PIN'**
  String get primaryHubPin;

  /// No description provided for @specificPracticePin.
  ///
  /// In en, this message translates to:
  /// **'SPECIFIC PRACTICE PIN'**
  String get specificPracticePin;

  /// No description provided for @serviceSlotManual.
  ///
  /// In en, this message translates to:
  /// **'SERVICE SLOT (MANUAL)'**
  String get serviceSlotManual;

  /// No description provided for @acknowledge.
  ///
  /// In en, this message translates to:
  /// **'ACKNOWLEDGE'**
  String get acknowledge;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'Password reset link sent to your email'**
  String get passwordResetSent;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @networkAnnouncements.
  ///
  /// In en, this message translates to:
  /// **'NETWORK ANNOUNCEMENTS'**
  String get networkAnnouncements;

  /// No description provided for @nodeDisconnected.
  ///
  /// In en, this message translates to:
  /// **'NODE DISCONNECTED'**
  String get nodeDisconnected;

  /// No description provided for @myNodesOfPresence.
  ///
  /// In en, this message translates to:
  /// **'MY NODES OF PRESENCE'**
  String get myNodesOfPresence;

  /// No description provided for @noNodesInitialized.
  ///
  /// In en, this message translates to:
  /// **'NO NODES INITIALIZED'**
  String get noNodesInitialized;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'COUNTRY'**
  String get country;

  /// No description provided for @userRole.
  ///
  /// In en, this message translates to:
  /// **'USER ROLE'**
  String get userRole;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'CLEAR ALL'**
  String get clearAll;

  /// No description provided for @accountSuspended.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT SUSPENDED'**
  String get accountSuspended;

  /// No description provided for @accessRestricted.
  ///
  /// In en, this message translates to:
  /// **'Your access has been restricted by the board.'**
  String get accessRestricted;

  /// No description provided for @dispatch.
  ///
  /// In en, this message translates to:
  /// **'DISPATCH'**
  String get dispatch;

  /// No description provided for @hopeHealingHumanity.
  ///
  /// In en, this message translates to:
  /// **'HOPE, HEALING, HUMANITY'**
  String get hopeHealingHumanity;

  /// No description provided for @availableExpansions.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE EXPANSIONS'**
  String get availableExpansions;

  /// No description provided for @rechargeCard.
  ///
  /// In en, this message translates to:
  /// **'RECHARGE CARD'**
  String get rechargeCard;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
