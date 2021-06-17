import 'package:flutter_driver/flutter_driver.dart';

class Keys{
  //common keys
  static final backButton = find.byTooltip('Back');

  //sign in keys
  static final signInText = find.byValueKey('signInTextKey');
  static final signInButton = find.byValueKey('signInButtonKey');
  static final invalidCredentialKey = find.byValueKey('invalidCredentialKey');
  static final requiredFieldKey = find.byValueKey('requiredFieldKey');
  static final userNameKey = find.byValueKey('userNameKey');
  static final passwordKey = find.byValueKey('passwordKey');
  static final welcomeBackTextKey = find.byValueKey('welcomeBackTextKey');
  static final visibleButtonKey = find.byValueKey('visibleButtonKey');
  static final userAvatarKey = find.byValueKey('userAvatarKey');
  static final dashboardWelcomeText = find.byValueKey('dashboardWelcomeText');
  static final easyDoctorTextKey = find.byValueKey('easyDoctorTextKey');


  // profile keys
  static final accountsTextKey = find.byValueKey('accountsTextKey');
  static final manageProfileTextKey = find.byValueKey('manageProfileTextKey');
  static final userProfileKey = find.byValueKey('userProfileKey');
  static final editInfoKey = find.byValueKey('editInfoKey');
  static final editPersonalInfo = find.byValueKey('editPersonalInfo');
  static final profileMobileNumberKey = find.byValueKey('profileMobileNumberKey');
  static final profileNameKey = find.byValueKey('profileNameKey');
  static final profileEmailKey = find.byValueKey('profileEmailKey');
  static final profileAddressKey = find.byValueKey('profileAddressKey');
  static final profileSubmitButtonKey = find.byValueKey('profileSubmitButtonKey');
  static final profileGenderKey = find.byValueKey('profileGenderKey');
  static final profileBloodGroupKey = find.byValueKey('profileBloodGroupKey');
  static final profileFamilyViewAllKey = find.byValueKey('profileFamilyViewAllKey');
  static final addFamilyMemberKey = find.byValueKey('addFamilyMemberKey');
  static final changePasswordKey = find.byValueKey('changePasswordKey');
  static final changePasswordPromptKey = find.byValueKey('changePasswordPromptKey');
  static final currentPasswordKey = find.byValueKey('currentPasswordKey');
  static final newPasswordKey = find.byValueKey('newPasswordKey');
  static final confirmPasswordKey = find.byValueKey('confirmPasswordKey');
  static final cancelButtonKey = find.byValueKey('cancelButtonKey');
  static final changePasswordSaveButtonKey = find.byValueKey('changePasswordSaveButtonKey');
  static final changePasswordCancelButtonKey = find.byValueKey('changePasswordCancelButtonKey');
  static final changePasswordPromptOkButton = find.byValueKey('changePasswordPromptOkButton');

  // family members key
  static final familyMembersAppbarKey = find.byValueKey('familyMembersAppbarKey');

}