import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ml.dart';

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
    Locale('en'),
    Locale('ml'),
  ];

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'CareNow'**
  String get appTitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @myCare.
  ///
  /// In en, this message translates to:
  /// **'My Care'**
  String get myCare;

  /// No description provided for @resetPassword.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPassword;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkEmail;

  /// No description provided for @sentRecoveryInstructions.
  ///
  /// In en, this message translates to:
  /// **'We have sent password recovery instructions to your email.'**
  String get sentRecoveryInstructions;

  /// No description provided for @backToLogin.
  ///
  /// In en, this message translates to:
  /// **'Back to Login'**
  String get backToLogin;

  /// No description provided for @enterEmailForReset.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address and we will send you a link to reset your password.'**
  String get enterEmailForReset;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @sendResetLink.
  ///
  /// In en, this message translates to:
  /// **'Send Reset Link'**
  String get sendResetLink;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @elderly.
  ///
  /// In en, this message translates to:
  /// **'Elderly'**
  String get elderly;

  /// No description provided for @caregiver.
  ///
  /// In en, this message translates to:
  /// **'Caregiver'**
  String get caregiver;

  /// No description provided for @staff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staff;

  /// No description provided for @completeRegistration.
  ///
  /// In en, this message translates to:
  /// **'Complete Registration'**
  String get completeRegistration;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @simplifiedRegistration.
  ///
  /// In en, this message translates to:
  /// **'Simplified Registration for Easy Access'**
  String get simplifiedRegistration;

  /// No description provided for @dobOptional.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth (Optional)'**
  String get dobOptional;

  /// No description provided for @linkToElderly.
  ///
  /// In en, this message translates to:
  /// **'Link your account to an Elderly user'**
  String get linkToElderly;

  /// No description provided for @elderlyLinkId.
  ///
  /// In en, this message translates to:
  /// **'Elderly Link ID / Code'**
  String get elderlyLinkId;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @adminApprovalRequired.
  ///
  /// In en, this message translates to:
  /// **'Registration requires Admin Approval.'**
  String get adminApprovalRequired;

  /// No description provided for @staffId.
  ///
  /// In en, this message translates to:
  /// **'Staff ID / Badge Number'**
  String get staffId;

  /// No description provided for @department.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get department;

  /// No description provided for @welcomeToCareNow.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nCareNow'**
  String get welcomeToCareNow;

  /// No description provided for @selectLanguagePrompt.
  ///
  /// In en, this message translates to:
  /// **'Please select your preferred language to continue.'**
  String get selectLanguagePrompt;

  /// No description provided for @medication.
  ///
  /// In en, this message translates to:
  /// **'Medication'**
  String get medication;

  /// No description provided for @appointments.
  ///
  /// In en, this message translates to:
  /// **'Appointments'**
  String get appointments;

  /// No description provided for @emergency.
  ///
  /// In en, this message translates to:
  /// **'Emergency'**
  String get emergency;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @dashboardFor.
  ///
  /// In en, this message translates to:
  /// **'Dashboard for'**
  String get dashboardFor;

  /// No description provided for @nextDose.
  ///
  /// In en, this message translates to:
  /// **'Next Dose'**
  String get nextDose;

  /// No description provided for @vitals.
  ///
  /// In en, this message translates to:
  /// **'Vitals'**
  String get vitals;

  /// No description provided for @staffPortal.
  ///
  /// In en, this message translates to:
  /// **'Staff Portal'**
  String get staffPortal;

  /// No description provided for @searchPatientRecords.
  ///
  /// In en, this message translates to:
  /// **'Search Patient Records...'**
  String get searchPatientRecords;

  /// No description provided for @forgotPasswordQuestion.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPasswordQuestion;

  /// No description provided for @createAccountQuestion.
  ///
  /// In en, this message translates to:
  /// **'New here? Create an Account'**
  String get createAccountQuestion;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @usernameError.
  ///
  /// In en, this message translates to:
  /// **'Please enter username'**
  String get usernameError;

  /// No description provided for @userNotRegistered.
  ///
  /// In en, this message translates to:
  /// **'User not registered'**
  String get userNotRegistered;

  /// No description provided for @incorrectPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get incorrectPassword;

  /// No description provided for @emailAvailable.
  ///
  /// In en, this message translates to:
  /// **'Email already available'**
  String get emailAvailable;

  /// No description provided for @registrationFailed.
  ///
  /// In en, this message translates to:
  /// **'Registration failed'**
  String get registrationFailed;

  /// No description provided for @unexpectedError.
  ///
  /// In en, this message translates to:
  /// **'An unexpected error occurred'**
  String get unexpectedError;

  /// No description provided for @uniqueId.
  ///
  /// In en, this message translates to:
  /// **'My Unique ID'**
  String get uniqueId;

  /// No description provided for @elderlyMode.
  ///
  /// In en, this message translates to:
  /// **'Elderly Mode (Large Text)'**
  String get elderlyMode;

  /// No description provided for @elderlyModeDesc.
  ///
  /// In en, this message translates to:
  /// **'Increases text size'**
  String get elderlyModeDesc;

  /// No description provided for @changePassword.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// No description provided for @currentPassword.
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @passwordChanged.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully'**
  String get passwordChanged;

  /// No description provided for @manageLinkedElderly.
  ///
  /// In en, this message translates to:
  /// **'Manage Linked Elderly'**
  String get manageLinkedElderly;

  /// No description provided for @linkedMsg.
  ///
  /// In en, this message translates to:
  /// **'{count} / 5 linked'**
  String linkedMsg(Object count);

  /// No description provided for @noElderlyLinked.
  ///
  /// In en, this message translates to:
  /// **'No elderly linked yet.'**
  String get noElderlyLinked;

  /// No description provided for @addElderlyId.
  ///
  /// In en, this message translates to:
  /// **'Add Elderly ID (e.g. ELD-1234)'**
  String get addElderlyId;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @limitReached.
  ///
  /// In en, this message translates to:
  /// **'Limit of 5 reached'**
  String get limitReached;

  /// No description provided for @mandatory.
  ///
  /// In en, this message translates to:
  /// **'*'**
  String get mandatory;

  /// No description provided for @accountDisabled.
  ///
  /// In en, this message translates to:
  /// **'Your account has been disabled. Contact Admin.'**
  String get accountDisabled;

  /// No description provided for @staffIdOnly.
  ///
  /// In en, this message translates to:
  /// **'Staff ID'**
  String get staffIdOnly;

  /// No description provided for @condition.
  ///
  /// In en, this message translates to:
  /// **'Condition'**
  String get condition;

  /// No description provided for @medicines.
  ///
  /// In en, this message translates to:
  /// **'Medicines'**
  String get medicines;

  /// No description provided for @profileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Profile not found'**
  String get profileNotFound;

  /// No description provided for @searchByUniqueId.
  ///
  /// In en, this message translates to:
  /// **'Search by Unique ID'**
  String get searchByUniqueId;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date of Birth'**
  String get dateOfBirth;

  /// No description provided for @passwordHelper.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least 1 special char & 1 number'**
  String get passwordHelper;

  /// No description provided for @caregiverFamily.
  ///
  /// In en, this message translates to:
  /// **'Caregiver/Family Member'**
  String get caregiverFamily;

  /// No description provided for @volunteer.
  ///
  /// In en, this message translates to:
  /// **'Volunteer'**
  String get volunteer;

  /// No description provided for @ageEligibilityError.
  ///
  /// In en, this message translates to:
  /// **'You are not eligible to register as an elderly user'**
  String get ageEligibilityError;

  /// No description provided for @medicineTiming.
  ///
  /// In en, this message translates to:
  /// **'Medicine Timing'**
  String get medicineTiming;

  /// No description provided for @volunteerHub.
  ///
  /// In en, this message translates to:
  /// **'Volunteer Hub'**
  String get volunteerHub;

  /// No description provided for @welcomeVolunteer.
  ///
  /// In en, this message translates to:
  /// **'Welcome, Volunteer!'**
  String get welcomeVolunteer;

  /// No description provided for @thankYouVolunteer.
  ///
  /// In en, this message translates to:
  /// **'Thank you for joining our community.'**
  String get thankYouVolunteer;

  /// No description provided for @viewAvailableTasks.
  ///
  /// In en, this message translates to:
  /// **'View Available Tasks'**
  String get viewAvailableTasks;

  /// No description provided for @noConditions.
  ///
  /// In en, this message translates to:
  /// **'No conditions recorded'**
  String get noConditions;

  /// No description provided for @noMedicines.
  ///
  /// In en, this message translates to:
  /// **'No medicines recorded'**
  String get noMedicines;

  /// No description provided for @noTiming.
  ///
  /// In en, this message translates to:
  /// **'No timing recorded'**
  String get noTiming;
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
      <String>['en', 'ml'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ml':
      return AppLocalizationsMl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
