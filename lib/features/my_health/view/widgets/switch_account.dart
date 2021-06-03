import 'package:bot_toast/bot_toast.dart';
import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/auth/view_model/accessToken_view_model.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/features/auth/view_model/auth_view_model.dart';
import 'package:myhealthbd_app/features/my_health/repositories/dbmanager.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../constant.dart';
import 'add_switch_account_alert_dialog.dart';

class SwitchAccount extends StatefulWidget {
  @override
  _SwitchAccountState createState() => _SwitchAccountState();
}

class _SwitchAccountState extends State<SwitchAccount> {
  final DbManager dbmManager = new DbManager();
  final _formKey = new GlobalKey<FormState>();
  SwitchAccounts _accounts;
  List<SwitchAccounts> accountList;
  int updateIndex;
  var username;
  SwitchAccounts switchAccounts;

  Future<void> getUSerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    username = prefs.getString("username");
  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      getUSerDetails();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vm5 = Provider.of<AuthViewModel>(context, listen: false);
    var vm = Provider.of<AccessTokenProvider>(context, listen: false);
    var spaceBetween = SizedBox(
      height: 10,
    );
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#354291'),
        title: Text(
          "Switch Account",
          style: GoogleFonts.poppins(fontSize: 15),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Switch Account",
              style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: HexColor("#354291"),
                  fontWeight: FontWeight.w500),
            ),
            spaceBetween,
            GestureDetector(
              onTap: () {
                _showAlert(context);
              },
              child: DashedContainer(
                dashColor: AppTheme.appbarPrimary,
                borderRadius: 5.0,
                dashedLength: 15.0,
                blankLength: 5.0,
                child: Container(
                  height: 30,
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_add_sharp,
                        color: AppTheme.appbarPrimary,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Add New Account",
                          style:
                              GoogleFonts.poppins(color: HexColor("#354291"))),
                    ],
                  ),
                ),
              ),
            ),
            spaceBetween,
            spaceBetween,
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: FutureBuilder(
                    future: dbmManager.getAccountList(),
                    builder: (context, snapshot) {
                      accountList = snapshot.data;
                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:
                              accountList == null ? 0 : accountList.length,
                          itemBuilder: (BuildContext context, int index) {
                            SwitchAccounts st = accountList[index];
                            var userImageVm = Provider.of<UserImageViewModel>(
                                context,
                                listen: true);
                            var profileImage =
                                accountList[index]?.relation ?? "";
                            return Container(
                                decoration: BoxDecoration(
                                  color: index % 2 == 0
                                      ? HexColor("#F0F2FF")
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.only(
                                    bottom: width <= 330 ? 3 : 4),
                                height: width <= 330 ? 70 : 80,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width <= 330 ? 5 : 10,
                                        ),
                                        Container(
                                            decoration: BoxDecoration(
                                              color: AppTheme.appbarPrimary,
                                              shape: BoxShape.circle,
                                            ),
                                            height: width <= 330 ? 50 : 60,
                                            width: width <= 330 ? 50 : 60,
                                            child: profileImage == ""
                                                ? Center(
                                                    child: Image.asset(
                                                      'assets/images/dPro.png',
                                                      height: width <= 330
                                                          ? 30
                                                          : 35,
                                                      width: width <= 330
                                                          ? 30
                                                          : 35,
                                                    ),
                                                  )
                                                : userImageVm.loadProfileImage(
                                                    profileImage,
                                                    width <= 330 ? 28 : 34,
                                                    width <= 330 ? 28 : 34,
                                                    50)),
                                        SizedBox(
                                          width: width <= 330 ? 10 : 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              st.name,
                                              style: GoogleFonts.poppins(
                                                  color: HexColor("#0D1231"),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w400),
                                            ),
                                            Text(
                                              st.username,
                                              style: GoogleFonts.poppins(
                                                  color: HexColor("#B8C2F8")),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    st.username == username
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.check,
                                                    color:
                                                        AppTheme.appbarPrimary,
                                                  ),
                                                  Text(
                                                    "Signed In",
                                                    style: GoogleFonts.poppins(
                                                        color: AppTheme
                                                            .appbarPrimary,
                                                        fontWeight:
                                                            FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                width: width <= 330 ? 10 : 20,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              GestureDetector(
                                                child: Container(
                                                    height: 16,
                                                    child: SvgPicture.asset(
                                                      "assets/images/switch.svg",
                                                      color: AppTheme
                                                          .appbarPrimary,
                                                    )),
                                                onTap: () async {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return Material(
                                                          type: MaterialType
                                                              .transparency,
                                                          child: Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Material(
                                                              type: MaterialType
                                                                  .transparency,
                                                              child: Stack(
                                                                children: [
                                                                  Container(
                                                                    height: 300,
                                                                    width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width,
                                                                    //color: Colors.red,
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Padding(
                                                                        padding: EdgeInsets.only(
                                                                            bottom:
                                                                                0,
                                                                            left:
                                                                                20,
                                                                            right:
                                                                                20),
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              180,
                                                                          decoration: BoxDecoration(
                                                                              //color: HexColor('#f9f2f3'),
                                                                              gradient: LinearGradient(
                                                                                begin: Alignment.topCenter,
                                                                                end: Alignment.bottomCenter,
                                                                                colors: [
                                                                                  HexColor('#fdf0f2'),
                                                                                  HexColor('#FFFFFF')
                                                                                ],
                                                                                tileMode: TileMode.repeated,
                                                                              ),
                                                                              borderRadius: BorderRadius.circular(25)),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(top: 50.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 10.0, right: 10),
                                                                                  child: RichText(
                                                                                    textAlign: TextAlign.center,
                                                                                    text:  TextSpan(
                                                                                      style:  GoogleFonts.poppins(
                                                                                        fontSize: 16.0,
                                                                                        color: Colors.black,
                                                                                      ),
                                                                                      children: <TextSpan>[
                                                                                        TextSpan(text: 'Do you really want to switch account?'),],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                SizedBox(
                                                                                  height: 15,
                                                                                ),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  children: [
                                                                                    GestureDetector(
                                                                                      onTap: () {
                                                                                        Navigator.pop(context);
                                                                                      },
                                                                                      child: Material(
                                                                                        elevation: 0,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: HexColor('#354291'))),
                                                                                        color: Colors.white,
                                                                                        child: SizedBox(
                                                                                          height: 50,
                                                                                          width: 120,
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              "No",
                                                                                              style: TextStyle(color: HexColor('#354291'), fontWeight: FontWeight.w500, fontSize: 15),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 15,
                                                                                    ),
                                                                                    GestureDetector(
                                                                                      onTap: () async {
                                                                                        await vm5.getAuthData(st.username, st.password);
                                                                                        if (vm5.accessToken != null) {
                                                                                          BotToast.showLoading();
                                                                                          var vm3 = Provider.of<UserImageViewModel>(context, listen: false);
                                                                                          var vm4 = Provider.of<UserDetailsViewModel>(context, listen: false);
                                                                                          await vm4.getSwitchData(vm5.accessToken);
                                                                                          await vm3.switchImage(vm5.accessToken);
                                                                                          switchAccounts = st;
                                                                                          updateIndex = index;
                                                                                          switchAccounts.username = st.username;
                                                                                          switchAccounts.password = st.password;
                                                                                          switchAccounts.name = vm4.userSwitchDetailsList.fname;
                                                                                          switchAccounts.relation = vm3.switchDetails.photo;
                                                                                          dbmManager.updateStudent(switchAccounts).then((value) => {
                                                                                                setState(() {}),
                                                                                              });
                                                                                        }
                                                                                        //BotToast.closeAllLoading();
                                                                                        if (vm5.accessToken != null) {
                                                                                          //BotToast.showLoading();
                                                                                          await vm.signOut();
                                                                                          BotToast.closeAllLoading();
                                                                                          appNavigator.getProvider<AccessTokenProvider>().setToken(vm5.accessToken);
                                                                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                                                                          prefs.setString("username", st.username);
                                                                                          prefs.setString("password", st.password);
                                                                                        } else {
                                                                                          BotToast.closeAllLoading();
                                                                                        }
                                                                                      },
                                                                                      child: Material(
                                                                                        elevation: 0,
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                        color: HexColor('#354291'),
                                                                                        child: SizedBox(
                                                                                          height: 50,
                                                                                          width: 120,
                                                                                          child: Center(
                                                                                            child: Text(
                                                                                              "Yes",
                                                                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    bottom: 175,
                                                                    //top: MediaQuery.of(context).size.height / 1.8,
                                                                    left: 100,
                                                                    right: 100,
                                                                    child:
                                                                        CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .transparent,
                                                                      radius: Constants
                                                                          .avatarRadius,
                                                                      child: ClipRRect(
                                                                          borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
                                                                          child: Image.asset(
                                                                            "assets/icons/sign_in_prompt.png",
                                                                            height:
                                                                                90,
                                                                            width:
                                                                                90,
                                                                          )),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                },
                                              ),
                                              SizedBox(
                                                width: width <= 330 ? 10 : 20,
                                              ),
                                              GestureDetector(
                                                child: Icon(Icons.delete_sweep,
                                                    color:
                                                        AppTheme.appbarPrimary),
                                                onTap: () {
                                                  showGeneralDialog(
                                                    barrierLabel: "Label",
                                                    barrierDismissible: true,
                                                    barrierColor: Colors.black
                                                        .withOpacity(0.5),
                                                    transitionDuration:
                                                        Duration(
                                                            milliseconds: 700),
                                                    context: context,
                                                    pageBuilder: (context,
                                                        anim1, anim2) {
                                                      return Material(
                                                        type: MaterialType
                                                            .transparency,
                                                        child: Align(
                                                          alignment:
                                                              Alignment.center,
                                                          child: Material(
                                                            type: MaterialType
                                                                .transparency,
                                                            child: Stack(
                                                              children: [
                                                                Container(
                                                                  height: 300,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width,
                                                                  //color: Colors.red,
                                                                  child: Center(
                                                                    child:
                                                                        Padding(
                                                                      padding: EdgeInsets.only(
                                                                          bottom:
                                                                              0,
                                                                          left:
                                                                              20,
                                                                          right:
                                                                              20),
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            180,
                                                                        decoration: BoxDecoration(
                                                                            //color: HexColor('#f9f2f3'),
                                                                            gradient: LinearGradient(
                                                                              begin: Alignment.topCenter,
                                                                              end: Alignment.bottomCenter,
                                                                              colors: [
                                                                                HexColor('#fdf0f2'),
                                                                                HexColor('#FFFFFF')
                                                                              ],
                                                                              tileMode: TileMode.repeated,
                                                                            ),
                                                                            borderRadius: BorderRadius.circular(25)),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.only(top: 50.0),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Column(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                                                                                    child: RichText(
                                                                                      textAlign: TextAlign.center,
                                                                                      text:  TextSpan(
                                                                                        style:  GoogleFonts.poppins(
                                                                                          fontSize: 14.0,
                                                                                          color: Colors.black,
                                                                                        ),
                                                                                        children: <TextSpan>[
                                                                                           TextSpan(text: 'Remove '),
                                                                                           TextSpan(text: accountList[index].name, style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                                                                           TextSpan(text: " from your account list?", style: GoogleFonts.poppins()),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Text("", style: GoogleFonts.poppins())
                                                                                ],
                                                                              ),
                                                                              SizedBox(
                                                                                height: 5,
                                                                              ),
                                                                              Row(
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  GestureDetector(
                                                                                    onTap: () {
                                                                                      Navigator.pop(context);
                                                                                    },
                                                                                    child: Material(
                                                                                      elevation: 0,
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8), side: BorderSide(color: HexColor('#354291'))),
                                                                                      color: Colors.white,
                                                                                      child: SizedBox(
                                                                                        height: 50,
                                                                                        width: 120,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "Cancel",
                                                                                            style: TextStyle(color: HexColor('#354291'), fontWeight: FontWeight.w500, fontSize: 15),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 15,
                                                                                  ),
                                                                                  GestureDetector(
                                                                                    onTap: () async {
                                                                                      dbmManager.deleteStudent(st.id);

                                                                                      setState(() {
                                                                                        accountList.removeAt(index);
                                                                                      });
                                                                                      Navigator.of(context).pop(context);
                                                                                    },
                                                                                    child: Material(
                                                                                      elevation: 0,
                                                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                                                      color: HexColor('#354291'),
                                                                                      child: SizedBox(
                                                                                        height: 50,
                                                                                        width: 120,
                                                                                        child: Center(
                                                                                          child: Text(
                                                                                            "Remove",
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                Positioned(
                                                                  bottom: 210,
                                                                  left: 100,
                                                                  right: 100,
                                                                  child:
                                                                      Container(
                                                                    width: 55,
                                                                    height: 55,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        shape: BoxShape
                                                                            .circle,
                                                                        boxShadow: [
                                                                          BoxShadow(
                                                                            color:
                                                                                HexColor("#0D1231").withOpacity(0.08),
                                                                            spreadRadius:
                                                                                3,
                                                                            blurRadius:
                                                                                5,
                                                                            offset:
                                                                                Offset(0, 1), // changes position of shadow
                                                                          ),
                                                                        ]),
                                                                    child: Icon(
                                                                      Icons
                                                                          .delete_outline,
                                                                      size: 30,
                                                                      color: HexColor(
                                                                          "#FF92A1"),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    transitionBuilder: (context,
                                                        anim1, anim2, child) {
                                                      return SlideTransition(
                                                        position: Tween(
                                                                begin: Offset(
                                                                    0, 2),
                                                                end: Offset(
                                                                    0, 0))
                                                            .animate(anim1),
                                                        child: child,
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                              SizedBox(
                                                width: 30,
                                              ),
                                            ],
                                          ),
                                  ],
                                ));
                          });
                    }),
              ),
            ),
            spaceBetween,
          ],
        ),
      ),
    );
  }

  void _showAlert(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AddAccountAlert();
        }).then((value) {
      setState(() {});
    });
  }
}
