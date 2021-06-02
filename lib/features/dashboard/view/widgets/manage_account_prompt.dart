import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/auth/view_model/accessToken_view_model.dart';
import 'package:myhealthbd_app/features/dashboard/view/widgets/sign_out_prompt.dart';
import 'package:myhealthbd_app/features/my_health/view/widgets/switch_account.dart';
import 'package:myhealthbd_app/features/user_profile/view/user_profile_screen.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:provider/provider.dart';

class ManageAccountPrompt extends StatefulWidget {
  @override
  _ManageAccountPromptState createState() => _ManageAccountPromptState();
}

class _ManageAccountPromptState extends State<ManageAccountPrompt> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await Provider.of<UserImageViewModel>(context, listen: false).userImage();
      await Provider.of<UserDetailsViewModel>(context, listen: false).getData();
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<UserDetailsViewModel>(context, listen: true);
    var vm2 = Provider.of<AccessTokenProvider>(context, listen: true);
    var vm10 = Provider.of<UserImageViewModel>(context, listen: true);
    var width= MediaQuery.of(context).size.width;
    var photo = vm10.details?.photo ?? "";
    return Center(
        child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            20,
          )),
      width: width < 330 ? 300 : 320.0,
      height: width < 330 ? 280 : 300.0,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 0.5, color: Colors.grey),
                  ),
                ),
                height: 150,
                child: Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Accounts",
                            style: GoogleFonts.poppins(
                                fontSize: width < 330 ? 16 : 18,
                                color: AppTheme.appbarPrimary,
                                fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(Icons.clear)),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          photo != ""
                              ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppTheme.appbarPrimary),
                                    //color: AppTheme.appbarPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  height:  width < 330 ? 50 : 60,
                                  width:  width < 330 ? 50 : 60,
                                  child: Center(
                                      child: vm10.loadProfileImage(
                                          photo, width < 330 ? 50 : 60,  width < 330 ? 50 : 60, 50)))
                              : Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.appbarPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  height:  width < 330 ? 50 : 60,
                                  width:  width < 330 ? 50 : 60,
                                  child: Center(
                                    child: Image.asset(
                                      'assets/images/dPro.png',
                                      height:  width < 330 ? 30 : 35,
                                      width: width < 330 ? 30 : 35,
                                    ),
                                  )),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vm.userDetailsList?.fname ?? '',
                                style: GoogleFonts.poppins(
                                    color: AppTheme.appbarPrimary,
                                    fontSize: width < 330 ? 16 : 18,
                                    fontWeight: FontWeight.w400),
                              ),
                              Text(
                                vm.userDetailsList?.address ?? '',
                                style: GoogleFonts.poppins(
                                    color: HexColor("#8592E5"), fontSize: 13),
                              ),
                              SizedBox(
                                height: width < 330 ? 5 : 8,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => UserProfile(
                                                fName: vm.userDetailsList
                                                        ?.patientName ??
                                                    "",
                                                phoneNumber: vm.userDetailsList
                                                    .phoneMobile,
                                                address:
                                                    vm.userDetailsList.address,
                                                dob: vm.userDetailsList.dob,
                                                id: vm.userDetailsList
                                                    .hospitalNumber,
                                                accessToken: vm2.accessToken,
                                              )));
                                },
                                child: Container(
                                  width: width<330 ? 150 : 160,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: AppTheme.appbarPrimary),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                      child: Text(
                                    "Manage Your Profile",
                                    style: GoogleFonts.poppins(
                                        color: AppTheme.appbarPrimary,
                                        fontSize: 12),
                                  )),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SwitchAccount();
                        }));
                      },
                      child: Row(
                        children: [
                          Container(
                              height: 25,
                              width: 25,
                              child: Image.asset('assets/images/switch.png')),
                          SizedBox(
                            width: width < 330 ?  5 : 10,
                          ),
                          Text(
                            "Switch to another account",
                            style: GoogleFonts.poppins(
                                color: AppTheme.appbarPrimary, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: width < 330 ? 15 : 20,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return SwitchAccount();
                        }));
                      },
                      child: Row(
                        children: [
                          Container(
                              height: 25,
                              width: 25,
                              child:
                                  Image.asset('assets/images/add_account.png')),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Add another account",
                            style: GoogleFonts.poppins(
                                color: AppTheme.appbarPrimary, fontSize: 13),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return SignOutPrompt();
                    });
              },
              child: Container(
                width: width < 330 ? 300 : 320.0,
                decoration: BoxDecoration(
                  color: AppTheme.appbarPrimary,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                ),
                height: width < 330 ? 35 : 45,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign Out",
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(
                      Icons.logout,
                      size: 20,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    ));
  }
}
