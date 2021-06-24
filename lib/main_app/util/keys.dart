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


  //switch account keys
  static final switchAccountAppbarKey = find.byValueKey('switchAccountAppbarKey');
  static final switchToAnotherAccountKey = find.byValueKey('switchToAnotherAccountKey');
  static final addNewAccountKey = find.byValueKey('addNewAccountKey');
  static final switchAccountTextKey = find.byValueKey('switchAccountTextKey');
  static final switchAccountUserNameKey = find.byValueKey('switchAccountUserNameKey');
  static final switchAccountPasswordKey = find.byValueKey('switchAccountPasswordKey');
  static final switchCancelButtonKey = find.byValueKey('switchCancelButtonKey');
  static final switchConfirmButtonKey = find.byValueKey('switchConfirmButtonKey');
  static final switchButtonKey1 = find.byValueKey('switchButtonKey1');
  static final switchButtonKey3 = find.byValueKey('switchButtonKey3');
  static final switchAccountYesButtonKey = find.byValueKey('switchAccountYesButtonKey');
  static final switchAccountNoButtonKey = find.byValueKey('switchAccountNoButtonKey');


  // family members key
  static final familyMembersAppbarKey = find.byValueKey('familyMembersAppbarKey');
  static final familyMemberEditButtonKey2 = find.byValueKey('familyMemberEditButtonKey2');
  static final familyMemberEditButtonKey3 = find.byValueKey('familyMemberEditButtonKey3');
  static final familyMemberEditCancelKey = find.byValueKey('familyMemberEditCancelKey');
  static final editMemberInfoKey = find.byValueKey('editMemberInfoKey');
  static final familyMemberEditUpdateKey = find.byValueKey('familyMemberEditUpdateKey');
  static final familyRelationUpdateKey = find.byValueKey('familyRelationUpdateKey');
  static final familyMemberRemoveButtonKey = find.byValueKey('familyMemberRemoveButtonKey');
  static final familyMemberCancelButtonKey = find.byValueKey('familyMemberCancelButtonKey');
  static final familyMemberDeleteKey2 = find.byValueKey('familyMemberDeleteKey2');
  static final familyMemberSearchAppbarKey = find.byValueKey('familyMemberSearchAppbarKey');
  static final familyMemberSearchKey = find.byValueKey('familyMemberSearchKey');
  static final familyMemberSearchButtonKey = find.byValueKey('familyMemberSearchButtonKey');
  static final addMemberKey1 = find.byValueKey('addMemberKey1');
  static final selectRelationShipAppbarKey = find.byValueKey('selectRelationShipAppbarKey');
  static final selectRelationKey = find.byValueKey('selectRelationKey');
  static final addAsFamilyMemberButtonKey = find.byValueKey('addAsFamilyMemberButtonKey');



  // hospitals keys
  static final hospitalBottomNavbarKey = find.byValueKey('hospitalBottomNavbarKey');
  static final hospitalAppbarKey = find.byValueKey('hospitalAppbarKey');
  static final getAppointmentKey1 = find.byValueKey('getAppointmentKey1');
  static final getAppointmentKey0 = find.byValueKey('getAppointmentKey0');
  static final getAppointmentKey8 = find.byValueKey('getAppointmentKey8');
  static final listViewBuilderKey = find.byValueKey('listViewBuilderKey');
  static final hospitalSearchFieldKey = find.byValueKey('hospitalSearchFieldKey');

  // doctors key
  static final doctorsKey = find.byValueKey('doctorsKey');
  static final doctorListViewBuilderKey = find.byValueKey('doctorListViewBuilderKey');
  static final findYourDoctorSearchKey = find.byValueKey('findYourDoctorSearchKey');
  static final filterIconKey = find.byValueKey('filterIconKey');
  static final filtersKey = find.byValueKey('filtersKey');
  static final deptList2 = find.byValueKey('deptList2');
  static final deptList5 = find.byValueKey('deptList5');
  static final speciality2 = find.byValueKey('speciality2');
  static final speciality3 = find.byValueKey('speciality3');
  static final applyFilterButtonKey = find.byValueKey('applyFilterButtonKey');
  static final filteredResultKey = find.byValueKey('filteredResultKey');
  static final clearFilterButton = find.byValueKey('clearFilterButton');
  //book your appointment key
  static final bookNowKey0 = find.byValueKey('bookNowKey0');
  static final bookNowKey8 = find.byValueKey('bookNowKey8');
  static final bookYourAppointmentAppbarKey = find.byValueKey('bookYourAppointmentAppbarKey');
}