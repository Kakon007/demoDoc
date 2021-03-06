import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myhealthbd_app/features/constant.dart';
import 'package:myhealthbd_app/features/my_health/repositories/dbmanager.dart';
import 'package:myhealthbd_app/features/user_profile/view/family_member_list_screen.dart';
import 'package:myhealthbd_app/features/user_profile/view/widgets/search_family_member.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/family_members_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view/widgets/change_password_prompt.dart';
import 'package:myhealthbd_app/features/user_profile/view/widgets/edit_profile_prompt.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_cropper/image_cropper.dart';

class UserProfile extends StatefulWidget {
  String fName;
  String phoneNumber;
  String address;
  String dob;
  String id;
  String accessToken;
  String email;
  String gender;
  String bloodGroup;

  UserProfile(
      {this.fName,
      this.phoneNumber,
      this.address,
      this.dob,
      this.id,
      this.accessToken,
      this.email,
      this.gender,
      this.bloodGroup});

  @override
  _UserProfileState createState() => _UserProfileState(
      fName: fName,
      phoneNumber: phoneNumber,
      address: address,
      dob: dob,
      email: email,
      gender: gender,
      bloodGroup: bloodGroup);
}

class _UserProfileState extends State<UserProfile> {
  String fName;
  String phoneNumber;
  String address;
  String dob;
  String email;
  String gender;
  String bloodGroup;

  _UserProfileState(
      {this.fName,
      this.phoneNumber,
      this.address,
      this.dob,
      this.email,
      this.gender,
      this.bloodGroup});

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(25.0),
    topRight: Radius.circular(25.0),
  );
  String response;
  var photo;
  final DbManager dbmManager = new DbManager();
  SwitchAccounts switchAccounts;
  List<SwitchAccounts> accountsList;
  var username;
  bool shouldDenyClick = false;
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration.zero, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      username = prefs.getString("username").toUpperCase();
      await Provider.of<UserImageViewModel>(context, listen: false).userImage();
      photo = Provider.of<UserImageViewModel>(context, listen: false).details?.photo ?? "";
      var userVm = Provider.of<UserDetailsViewModel>(context, listen: false);
      await userVm.getData();
      var familyVm = Provider.of<FamilyMembersListViewModel>(context, listen: false);
      familyVm.familyMembers(userVm.userDetailsList.hospitalNumber);
      accountsList = await dbmManager.getAccountList();
    });
    Provider.of<UserDetailsViewModel>(context, listen: false).getData();
    super.initState();
  }

  File _image;
  final picker = ImagePicker();
  bool isEdit = false;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    // if (pickedFile != null) {
    //   _image = File(pickedFile.path);
    //   debugPrint("ish ${await _image.length()}");
    //   setState(() {
    //     isEdit = true;
    //   });
    // } else {
    //   debugPrint('No image selected.');
    // }

    if (pickedFile != null) {
//      var compressedImage = await ImageCompressUtil.compressImage(file, 80);
      Future<File> croppedFile = ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Cropper',
              toolbarColor: Theme.of(context).primaryColor,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));

      croppedFile.then((value) async {
        _image = value;
        //debugPrint("ish ${await _image.length()}");
        setState(() {
          isEdit = true;
        });
      });
    } else {
      debugPrint('No image selected.');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var vm = Provider.of<UserDetailsViewModel>(context, listen: true);
    var vm2 = Provider.of<UserImageViewModel>(context, listen: true);
    var familyVm = Provider.of<FamilyMembersListViewModel>(context, listen: true);
    var userId = vm.userDetailsList.id;
    var hospitalNumber = vm.userDetailsList.hospitalNumber;
    var regDate = vm.userDetailsList.regDate;
    photo = vm2.details?.photo ?? "";
    var imageVm = Provider.of<UserImageViewModel>(context, listen: true);
    var pickBirthDate =
        DateFormat("yyyy-MM-dd").parse(vm.userDetailsList.dob).add(Duration(days: 1));
    String _formatDate = DateFormat("yyyy-MM-dd").format(pickBirthDate);
    var _selectedBlood =
        vm.userDetailsList.bloodGroup != null ? vm.userDetailsList.bloodGroup : null;
    var _selectedGender = vm.userDetailsList.gender == "M" ? "Male" : "Female";
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: HexColor('#354291'),
          //leading: Icon(Icons.notes),
          title: Row(
            children: [
              Text(
                'User Profile',
                key: Key('userProfileKey'),
                style:
                    GoogleFonts.roboto(fontSize: isTablet ? 18 : 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Row(
                children: [
                  isEdit
                      ? shouldDenyClick
                          ? SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 1.0,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : GestureDetector(
                              child: Text(
                                "Save",
                                style: GoogleFonts.poppins(
                                  fontSize: isTablet ? 18 : 15,
                                ),
                              ),
                              onTap: () async {
                                setState(() {
                                  shouldDenyClick = true;
                                });
                                await vm2.updateImage(_image, vm.userDetailsList.hospitalNumber,
                                    vm2.details.userId.toString());
                                await vm2.updateProfile2(
                                    _image,
                                    userId.toString(),
                                    vm.userDetailsList.fname,
                                    vm.userDetailsList.email,
                                    vm.userDetailsList.phoneMobile,
                                    vm.userDetailsList.address,
                                    _formatDate,
                                    _selectedGender,
                                    _selectedBlood,
                                    hospitalNumber,
                                    regDate);
                                response = vm2.resStatusCode;
                                setState(() {
                                  if (response == "200") {
                                    shouldDenyClick = false;
                                    isEdit = false;
                                    _image = null;
                                    response = null;
                                  } else {
                                    shouldDenyClick = false;
                                  }
                                });
                                accountsList.forEach((item) {
                                  if (item.username.contains(username)) {
                                    debugPrint('image data');
                                    SwitchAccounts st = item;
                                    switchAccounts = st;
                                    switchAccounts.username = item.username;
                                    switchAccounts.password = item.password;
                                    switchAccounts.name = item.name;
                                    switchAccounts.relation = vm2.details?.photo;
                                    switchAccounts.id = item.id;
                                    dbmManager.updateStudent(switchAccounts).then((value) => {
                                          setState(() {}),
                                        });
                                  }
                                });
                              },
                            )
                      : Text(""),
                  SizedBox(
                    width: 20,
                  ),
                  // Icon(
                  //   Icons.notifications,
                  //   size: 20,
                  // ),
                ],
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Stack(children: [
            Stack(children: [
              Container(
                color: Colors.white,
                height: 800,
                width: double.infinity,
                child: Padding(
                  padding: EdgeInsets.only(top: 180.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 22.0, left: 22),
                        child: Row(
                          children: [
                            Text(
                              "Family Members",
                              style: GoogleFonts.roboto(
                                  color: HexColor('#354291'),
                                  fontSize: isTablet ? 20 : 16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: FamilyMemberListScreen(),
                                  ),
                                );
                                ;
                              },
                              child: Container(
                                height: isTablet ? 25 : 20,
                                width: isTablet ? 70 : 60,
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    Row(
                                      children: [
                                        Text(
                                          "View All",
                                          key: Key('profileFamilyViewAllKey'),
                                          style: GoogleFonts.roboto(
                                              color: AppTheme.appbarPrimary,
                                              fontSize: isTablet ? 14 : 12),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: isTablet ? 15 : 10,
                      ),
                      Padding(
                        padding: EdgeInsets.only(
                            right: familyVm.familyMembersList.length == 0 ? 22 : 0.0, left: 22),
                        child: ConstrainedBox(
                            constraints: new BoxConstraints(
                              // minHeight: 20.0,
                              maxHeight: isTablet ? 85 : 75.0,
                            ),
                            child: familyVm.familyMembersList.length == 0
                                ? Container(
                                    height: 75,
                                    width: MediaQuery.of(context).size.width,
                                    color: HexColor('#F7F8FF'),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'You have added no family members.',
                                          style: GoogleFonts.poppins(
                                              fontSize: isTablet ? 15 : 13, color: Colors.grey),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        TextButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(builder: (context) {
                                                return SearchFamilyMember();
                                              }));
                                            },
                                            child: Text(
                                              'Add now',
                                              style: GoogleFonts.poppins(
                                                  fontSize: isTablet ? 15 : 13,
                                                  color: HexColor('#8592E5')),
                                            ))
                                      ],
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: familyVm.familyMembersList.length >= 5
                                        ? 5
                                        : familyVm.familyMembersList.length,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) {
                                      var photo = familyVm.familyMembersList[index]?.photo ?? "";
                                      return Container(
                                        margin: EdgeInsets.only(right: isTablet ? 10 : 6),
                                        decoration: BoxDecoration(
                                            color: HexColor('#F7F8FF'),
                                            borderRadius: BorderRadius.circular(8)),
                                        height: 50.0,
                                        width: isTablet ? 180 : 150,
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 5,
                                            ),
                                            photo != ""
                                                ? Container(
                                                    decoration: BoxDecoration(
                                                      border:
                                                          Border.all(color: AppTheme.appbarPrimary),
                                                      //color: AppTheme.appbarPrimary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    height: isTablet ? 45 : 40,
                                                    width: isTablet ? 45 : 40,
                                                    child: Center(
                                                        child: imageVm.loadProfileImage(
                                                            photo,
                                                            isTablet ? 40 : 35,
                                                            isTablet ? 40 : 35,
                                                            50)))
                                                : Container(
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.appbarPrimary,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    height: isTablet ? 45 : 40,
                                                    width: isTablet ? 45 : 40,
                                                    child: Center(
                                                      child: Image.asset(
                                                        'assets/images/dPro.png',
                                                        height: isTablet ? 27 : 22,
                                                        width: isTablet ? 27 : 22,
                                                      ),
                                                    )),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: isTablet ? 115 : 95,
                                                  child: Text(
                                                    familyVm.familyMembersList[index].fmName,
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: GoogleFonts.roboto(
                                                        color: HexColor('#0D1231'),
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: isTablet ? 14 : 11),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  familyVm.familyMembersList[index].relationName,
                                                  style: GoogleFonts.roboto(
                                                      color: HexColor('#B8C2F8'),
                                                      fontSize: isTablet ? 13 : 10),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      );
                                    })),
                      ),
                      // InkWell(
                      //   onTap: (){
                      //     Navigator.push(
                      //       context,
                      //       PageTransition(
                      //         type: PageTransitionType.rightToLeft,
                      //         child: FamilyMemberListScreen(),
                      //       ),
                      //     );
                      //   },
                      //   child: Material(
                      //     elevation: 2,
                      //     shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(8)),
                      //     color: HexColor("#354291"),
                      //     child: SizedBox(
                      //       width: isTablet? MediaQuery.of(context).size.width*.95 : MediaQuery.of(context).size.width*.9,
                      //       height: isTablet? 50 : 40,
                      //       child: Center(
                      //         child: Row(
                      //           mainAxisAlignment: MainAxisAlignment.center,
                      //           children: [
                      //             Icon(
                      //               Icons.person_add,
                      //               color: Colors.white,
                      //               size: isTablet? 25 : 20 ,
                      //             ),
                      //             SizedBox(
                      //               width: 10,
                      //             ),
                      //             Text(
                      //               "Add Family Members",
                      //               key: Key('addFamilyMemberKey'),
                      //               style: GoogleFonts.roboto(
                      //                   color: Colors.white,
                      //                   fontSize: isTablet? 18 : 15,
                      //                   fontWeight: FontWeight.w500),
                      //             ),
                      //           ],
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 10,
                      ),
                      // Expanded(
                      //   child: ListView.builder(
                      //       physics: NeverScrollableScrollPhysics(),
                      //       shrinkWrap: true,
                      //       scrollDirection: Axis.horizontal,
                      //       itemCount: 3,
                      //       itemBuilder: (BuildContext context, int index) {
                      //         var photo = familyVm.familyMembersList[index]?.photo ?? "";
                      //         debugPrint("photo $photo");
                      //         return Container(
                      //           color: HexColor('#F7F8FF'),
                      //           height: 50.0,
                      //           width: 102,
                      //           child: Row(
                      //             children: [
                      //               CircleAvatar(
                      //                 radius: 22,
                      //                 backgroundColor:
                      //                     HexColor('#354291').withOpacity(0.2),
                      //                 child: CircleAvatar(
                      //                   radius: 21,
                      //                   backgroundColor: Colors.white,
                      //                   child: CircleAvatar(
                      //                     backgroundImage:
                      //                         AssetImage('assets/images/f1.png'),
                      //                     radius: 20,
                      //                   ),
                      //                 ),
                      //               ),
                      //               SizedBox(
                      //                 width: 10,
                      //               ),
                      //               Padding(
                      //                 padding: const EdgeInsets.only(top: 10.0),
                      //                 child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Text(
                      //                       familyVm.familyMembersList[index].fmName,
                      //                       style: GoogleFonts.roboto(
                      //                           color: HexColor('#0D1231'),
                      //                           fontSize: 10),
                      //                     ),
                      //                     SizedBox(
                      //                       height: 5,
                      //                     ),
                      //                     Text(
                      //                       familyVm.familyMembersList[index].relationName,
                      //                       style: GoogleFonts.roboto(
                      //                           color: HexColor('#B8C2F8'),
                      //                           fontSize: 8),
                      //                     ),
                      //                   ],
                      //                 ),
                      //               )
                      //             ],
                      //           ),
                      //         );
                      //       }),
                      // ),
                      Row(
                        children: [
                          // Container(
                          //   color: HexColor('#F7F8FF'),
                          //   height: 55.0,
                          //   width: 102,
                          //   child: Row(
                          //     children: [
                          //       CircleAvatar(
                          //         radius: 22,
                          //         backgroundColor:
                          //             HexColor('#354291').withOpacity(0.2),
                          //         child: CircleAvatar(
                          //           radius: 21,
                          //           backgroundColor: Colors.white,
                          //           child: CircleAvatar(
                          //             backgroundImage:
                          //                 AssetImage('assets/images/f1.png'),
                          //             radius: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.only(top: 10.0),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               "Nahid Doe",
                          //               style: GoogleFonts.roboto(
                          //                   color: HexColor('#0D1231'),
                          //                   fontSize: 10),
                          //             ),
                          //             SizedBox(
                          //               height: 5,
                          //             ),
                          //             Text(
                          //               "Brother",
                          //               style: GoogleFonts.roboto(
                          //                   color: HexColor('#B8C2F8'),
                          //                   fontSize: 8),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: 9,
                          // ),
                          // Container(
                          //   color: HexColor('#F7F8FF'),
                          //   height: 55.0,
                          //   width: 110,
                          //   child: Row(
                          //     children: [
                          //       CircleAvatar(
                          //         radius: 22,
                          //         backgroundColor:
                          //             HexColor('#354291').withOpacity(0.2),
                          //         child: CircleAvatar(
                          //           radius: 21,
                          //           backgroundColor: Colors.white,
                          //           child: CircleAvatar(
                          //             backgroundImage:
                          //                 AssetImage('assets/images/f2.png'),
                          //             radius: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.only(top: 10.0),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               "Nahid Doe",
                          //               style: GoogleFonts.roboto(
                          //                   color: HexColor('#0D1231'),
                          //                   fontSize: 10),
                          //             ),
                          //             SizedBox(
                          //               height: 5,
                          //             ),
                          //             Text(
                          //               "Brother",
                          //               style: GoogleFonts.roboto(
                          //                   color: HexColor('#B8C2F8'),
                          //                   fontSize: 8),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          // SizedBox(
                          //   width: 9,
                          // ),
                          // Container(
                          //   color: HexColor('#F7F8FF'),
                          //   height: 55.0,
                          //   width: 110,
                          //   child: Row(
                          //     children: [
                          //       CircleAvatar(
                          //         radius: 22,
                          //         backgroundColor:
                          //             HexColor('#354291').withOpacity(0.2),
                          //         child: CircleAvatar(
                          //           radius: 21,
                          //           backgroundColor: Colors.white,
                          //           child: CircleAvatar(
                          //             backgroundImage:
                          //                 AssetImage('assets/images/f3.png'),
                          //             radius: 20,
                          //           ),
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //       Padding(
                          //         padding: const EdgeInsets.only(top: 10.0),
                          //         child: Column(
                          //           crossAxisAlignment:
                          //               CrossAxisAlignment.start,
                          //           children: [
                          //             Text(
                          //               "Nahid Doe",
                          //               style: GoogleFonts.roboto(
                          //                   color: HexColor('#0D1231'),
                          //                   fontSize: 10),
                          //             ),
                          //             SizedBox(
                          //               height: 5,
                          //             ),
                          //             Text(
                          //               "Brother",
                          //               style: GoogleFonts.roboto(
                          //                   color: HexColor('#B8C2F8'),
                          //                   fontSize: 8),
                          //             ),
                          //           ],
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 22.0, left: 22),
                        child: Row(
                          children: [
                            Text(
                              "Personal Info",
                              style: GoogleFonts.roboto(
                                  color: HexColor('#354291'),
                                  fontSize: isTablet ? 18 : 15,
                                  fontWeight: FontWeight.bold),
                            ),
                            Spacer(),
                            InkWell(
                              onTap: () {
                                _showAlertDialogForEditProfile(context);
                              },
                              child: Container(
                                constraints: BoxConstraints(
                                  minWidth: isTablet ? 70 : 60,
                                ),
                                height: isTablet ? 25 : 20,
                                // width: isTablet ? 70 : 60,
                                decoration: BoxDecoration(
                                  border: Border.all(color: HexColor('#354291')),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                    child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.edit,
                                          color: AppTheme.appbarPrimary,
                                          size: isTablet ? 15 : 13,
                                        ),
                                        Text(
                                          "Edit Info",
                                          key: Key('editInfoKey'),
                                          style: GoogleFonts.roboto(
                                            color: HexColor('#354291'),
                                            fontSize: isTablet ? 12 : 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(),
                                  ],
                                )),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),

                      buildInformationItem(
                        label: "Username",
                        value: vm.userDetailsList?.hospitalNumber ?? "",
                        showBgColor: true,
                      ),
                      buildInformationItem(
                        label: "Full Name",
                        value: vm.userDetailsList?.fname ?? "",
                        showBgColor: false,
                      ),
                      buildInformationItem(
                        label: "Email Address",
                        value: vm.userDetailsList?.email ?? "",
                        showBgColor: true,
                      ),
                      buildInformationItem(
                        label: "Mobile Number",
                        value: vm.userDetailsList?.phoneMobile ?? "",
                      ),
                      buildInformationItem(
                        label: "Address",
                        value: vm.userDetailsList?.address ?? "",
                        showBgColor: true,
                      ),
                      buildInformationItem(
                        label: "Date of Birth ",
                        value:
                            "${DateUtil().formattedDate(DateTime.parse(vm.userDetailsList?.dob ?? "").toLocal())}",
                        showBgColor: false,
                      ),
                      buildInformationItem(
                        label: "Gender",
                        value:
                            "${vm.userDetailsList?.gender == "M" ? "Male" : vm.userDetailsList?.gender == "F" ? "Female" : ""}",
                        showBgColor: true,
                      ),
                      buildInformationItem(
                        label: "Blood Group",
                        value: vm.userDetailsList?.bloodGroup ?? "",
                        showBgColor: false,
                      ),
                      // SizedBox(
                      //   height: 15,
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(right: 22.0, left: 22),
                      //   child: Row(
                      //     children: [
                      //       Text(
                      //         "Change Password",
                      //         style: GoogleFonts.roboto(
                      //             color: HexColor('#354291'),
                      //             fontSize: 16,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          _showAlertDialogForPassword(context);
                        },
                        key: Key('changePasswordKey'),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Material(
                            elevation: 2,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            color: HexColor("#354291"),
                            child: SizedBox(
                              width: isTablet
                                  ? MediaQuery.of(context).size.width * .95
                                  : MediaQuery.of(context).size.width * .95,
                              height: isTablet ? 50 : 40,
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Change Password",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontSize: isTablet ? 18 : 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                color: HexColor('#E9ECFE'),
                height: 120.0,
                width: double.infinity,
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20),
                //   //color: Colors.grey,
                // ),
              ),
            ]),
            // CircleAvatar(
            //   radius: 10,
            //   backgroundColor: Colors.white,
            //   child: CircleAvatar(
            //     backgroundImage: AssetImage('assets/images/proimg.png'),
            //     radius: 9,
            //   ),
            // ),

            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Container(
                  height: 145,
                  width: isTablet ? 160 : 145,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppTheme.appbarPrimary),
                          color: Colors.white,
                        ),
                        //color: Colors.white,
                        height: isTablet ? 135 : 120,
                        width: isTablet ? 155 : 135,
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(19),
                                child: Image.file(
                                  _image,
                                  height: 100,
                                  width: 60,
                                  fit: BoxFit.cover,
                                ))
                            : photo != ""
                                ? vm2.loadProfileImage(photo, 100, 60, 19)
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                        child: Image.asset(
                                      'assets/images/dPro.png',
                                      fit: BoxFit.contain,
                                    )),
                                  ),
                      ),
                      Positioned(
                        bottom: isTablet ? 0 : 12,
                        left: isTablet ? 62 : 55,
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                              height: isTablet ? 35 : 30,
                              width: isTablet ? 35 : 30,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  border: Border.all(color: AppTheme.appbarPrimary)),
                              child: Icon(
                                Icons.camera_alt,
                                color: AppTheme.appbarPrimary,
                                size: isTablet ? 22 : 18,
                              )),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget buildInformationItem({
    @required String label,
    @required String value,
    bool showBgColor = false,
  }) {
    bool isMobile = Responsive.isMobile(context);
    var textStyle = GoogleFonts.roboto(color: Color(0xff141D53), fontSize: isMobile ? 14 : 17);
    return Container(
      color: showBgColor ? Color(0xffF7F8FF) : Colors.white,
      constraints: BoxConstraints(minHeight: 40),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 110,
              child: Text(
                "$label",
                style: textStyle,
              ),
            ),
            Text(
              " : ",
              style: textStyle,
            ),
            Expanded(
              child: Text(
                "$value",
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDialogForPassword(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return ChangePasswordAlert(widget.accessToken, widget.id);
        });
  }

  void _showAlertDialogForEditProfile(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return EditProfileAlert();
        }).then((value) {
      setState(() {});
    });
  }
}

class DateUtil {
  static const DATE_FORMAT = 'dd-MM-yyyy';

  String formattedDate(DateTime dateTime) {
    debugPrint('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}
