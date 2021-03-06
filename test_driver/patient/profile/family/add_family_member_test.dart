import 'package:flutter_driver/flutter_driver.dart';
import 'package:myhealthbd_app/main_app/util/keys.dart';
import 'package:test/test.dart';

import '../../auth/sign_in_common_test.dart';

//flutter drive --flavor dev --target=test_driver/company/auth/signin.dart

main(){
  addFamilyMemberTest();
}
Future<void> addFamilyMemberTest()async{

  group('Add family member test', ()
  {
    FlutterDriver driver;
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });

    test('When__try_to_tap_add_family_member__should__go_to_search_screen_and_get_Search_text_on_appbar', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(Keys.addFamilyMemberKey);
        await Future.delayed(const Duration(seconds: 2), () {});
        await expect(await driver.getText(Keys.familyMemberSearchAppbarKey), "Search");
        await Future.delayed(const Duration(seconds: 2), () {});
      });
    });
    test('When__try_to_search_rahat__should__go_to_search_screen_and_get_Search_text_on_appbar', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(Keys.familyMemberSearchKey);
        await Future.delayed(const Duration(seconds: 2), () {});
        await driver.enterText('rahat');
        await Future.delayed(const Duration(seconds: 2), () {});
        await driver.tap(Keys.familyMemberSearchButtonKey);
        await expect(await driver.getText(Keys.familyMemberSearchAppbarKey), "Search");
        await Future.delayed(const Duration(seconds: 2), () {});
      });
    });
    test('When__try_add_member_at_index_1__should__go_to_add_family_member_screen_and_get_Select_Relationship_text_on_appbar', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(Keys.addMemberKey1);
        await Future.delayed(const Duration(seconds: 2), () {});
        await expect(await driver.getText(Keys.selectRelationShipAppbarKey), "Select Relationship");
        await Future.delayed(const Duration(seconds: 2), () {});
      });
    });
    // test('When__try_tap_add_as_family_member_button_without_selecting_relation__should__get_Select_Relationship_text_on_appbar', () async {
    //   await driver.runUnsynchronized(() async {
    //     await driver.tap(Keys.addAsFamilyMemberButtonKey);
    //     await Future.delayed(const Duration(seconds: 2), () {});
    //     await expect(await driver.getText(Keys.selectRelationShipAppbarKey), "Select Relationship");
    //     await Future.delayed(const Duration(seconds: 2), () {});
    //   });
    // });
    test('When__try_select_relation_and_tap_add_as_family_member_button_without_selecting_relation__should__go_to_family_members_screen_and_get_family_members_text_on_appbar', () async {
      await driver.runUnsynchronized(() async {
        await driver.tap(Keys.selectRelationKey);
        await Future.delayed(const Duration(seconds: 2), () {});
        await driver.tap(find.text("Brother"));
        await Future.delayed(const Duration(seconds: 2), () {});
        await driver.tap(Keys.addAsFamilyMemberButtonKey);
        await Future.delayed(const Duration(seconds: 2), () {});
        await expect(await driver.getText(Keys.familyMembersAppbarKey), "Family Members");
        await Future.delayed(const Duration(seconds: 2), () {});
      });
    });

  });


}
