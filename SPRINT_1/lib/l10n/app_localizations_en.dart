// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get notifications => 'Notifications';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get appTitle => 'CareNow';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get myCare => 'My Care';

  @override
  String get resetPassword => 'Reset Password';

  @override
  String get checkEmail => 'Check your email';

  @override
  String get sentRecoveryInstructions =>
      'We have sent password recovery instructions to your email.';

  @override
  String get backToLogin => 'Back to Login';

  @override
  String get enterEmailForReset =>
      'Enter your email address and we will send you a link to reset your password.';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get sendResetLink => 'Send Reset Link';

  @override
  String get createAccount => 'Create Account';

  @override
  String get elderly => 'Elderly';

  @override
  String get caregiver => 'Caregiver';

  @override
  String get staff => 'Staff';

  @override
  String get completeRegistration => 'Complete Registration';

  @override
  String get fullName => 'Full Name';

  @override
  String get simplifiedRegistration =>
      'Simplified Registration for Easy Access';

  @override
  String get dobOptional => 'Date of Birth (Optional)';

  @override
  String get linkToElderly => 'Link your account to an Elderly user';

  @override
  String get elderlyLinkId => 'Elderly Link ID / Code';

  @override
  String get relationship => 'Relationship';

  @override
  String get adminApprovalRequired => 'Registration requires Admin Approval.';

  @override
  String get staffId => 'Staff ID / Badge Number';

  @override
  String get department => 'Department';

  @override
  String get welcomeToCareNow => 'Welcome to\nCareNow';

  @override
  String get selectLanguagePrompt =>
      'Please select your preferred language to continue.';

  @override
  String get medication => 'Medication';

  @override
  String get appointments => 'Appointments';

  @override
  String get emergency => 'Emergency';

  @override
  String get profile => 'Profile';

  @override
  String get dashboardFor => 'Dashboard for';

  @override
  String get nextDose => 'Next Dose';

  @override
  String get vitals => 'Vitals';

  @override
  String get staffPortal => 'Staff Portal';

  @override
  String get searchPatientRecords => 'Search Patient Records...';

  @override
  String get forgotPasswordQuestion => 'Forgot Password?';

  @override
  String get createAccountQuestion => 'New here? Create an Account';

  @override
  String get username => 'Username';

  @override
  String get usernameError => 'Please enter username';

  @override
  String get userNotRegistered => 'User not registered';

  @override
  String get incorrectPassword => 'Incorrect password';

  @override
  String get emailAvailable => 'Email already available';

  @override
  String get registrationFailed => 'Registration failed';

  @override
  String get unexpectedError => 'An unexpected error occurred';

  @override
  String get uniqueId => 'My Unique ID';

  @override
  String get elderlyMode => 'Elderly Mode (Large Text)';

  @override
  String get elderlyModeDesc => 'Increases text size';

  @override
  String get changePassword => 'Change Password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get update => 'Update';

  @override
  String get cancel => 'Cancel';

  @override
  String get passwordChanged => 'Password changed successfully';

  @override
  String get manageLinkedElderly => 'Manage Linked Elderly';

  @override
  String linkedMsg(Object count) {
    return '$count / 5 linked';
  }

  @override
  String get noElderlyLinked => 'No elderly linked yet.';

  @override
  String get addElderlyId => 'Add Elderly ID (e.g. ELD-1234)';

  @override
  String get add => 'Add';

  @override
  String get close => 'Close';

  @override
  String get limitReached => 'Limit of 5 reached';

  @override
  String get mandatory => '*';

  @override
  String get accountDisabled =>
      'Your account has been disabled. Contact Admin.';

  @override
  String get staffIdOnly => 'Staff ID';

  @override
  String get condition => 'Condition';

  @override
  String get medicines => 'Medicines';

  @override
  String get profileNotFound => 'Profile not found';

  @override
  String get searchByUniqueId => 'Search by Unique ID';

  @override
  String get dateOfBirth => 'Date of Birth';

  @override
  String get passwordHelper =>
      'Must contain at least 1 special char & 1 number';

  @override
  String get caregiverFamily => 'Caregiver/Family Member';

  @override
  String get volunteer => 'Volunteer';

  @override
  String get ageEligibilityError =>
      'You are not eligible to register as an elderly user';

  @override
  String get medicineTiming => 'Medicine Timing';

  @override
  String get volunteerHub => 'Volunteer Hub';

  @override
  String get welcomeVolunteer => 'Welcome, Volunteer!';

  @override
  String get thankYouVolunteer => 'Thank you for joining our community.';

  @override
  String get viewAvailableTasks => 'View Available Tasks';

  @override
  String get noConditions => 'No conditions recorded';

  @override
  String get noMedicines => 'No medicines recorded';

  @override
  String get noTiming => 'No timing recorded';
}
