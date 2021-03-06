import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/features/user_profile/models/registered_members_model.dart';
import 'package:myhealthbd_app/features/user_profile/view/widgets/add_family_member.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/family_members_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/registered_member_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchFamilyMember extends StatefulWidget {
  const SearchFamilyMember({Key key}) : super(key: key);

  @override
  _SearchFamilyMemberState createState() => _SearchFamilyMemberState();
}

class _SearchFamilyMemberState extends State<SearchFamilyMember> {
  TextEditingController memberSearch = TextEditingController();
  List<Item> familyMembers = [];

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      var userVm = Provider.of<UserDetailsViewModel>(appNavigator.context,
          listen: false);
      // TODO: implement initState
      userVm.getData();
      getUSerDetails();
      var familyVm =
          Provider.of<FamilyMembersListViewModel>(context, listen: false);
      familyVm.familyMembers(userVm.userDetailsList.hospitalNumber);
    });

    super.initState();
  }

  Future<void> membersSearch(String query) async {
    var vm = Provider.of<RegisteredMemberViewModel>(context, listen: false);
    var regId = query;
    var patName = query;
    await vm.getMembers(regId, patName);
    if (vm.message == "Data Empty ") {
      familyMembers = [];
    } else {
      familyMembers.clear();
      familyMembers = vm.members;
    }
  }

  var user;
  var pass;

  Future<void> getUSerDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user = prefs.getString("usernameRemember").toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    var familyVm =
        Provider.of<FamilyMembersListViewModel>(context, listen: false);
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var vm = Provider.of<RegisteredMemberViewModel>(context, listen: true);
    var userVm =
        Provider.of<UserDetailsViewModel>(appNavigator.context, listen: true);
    var imageVm =
        Provider.of<UserImageViewModel>(appNavigator.context, listen: true);
    var width = MediaQuery.of(context).size.width;
    var searchField = Container(
      width: isTablet ? width * .935 : width * .91,
      height: 50,
      child: TextField(
          onSubmitted: (value) {
            membersSearch(value);
          },
          key: Key('familyMemberSearchKey'),
          controller: memberSearch,
          decoration: new InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                membersSearch(memberSearch.text);
              },
              key: Key('familyMemberSearchButtonKey'),
              child: Icon(
                Icons.search,
                //color: HexColor("#8592E5"),
              ),
            ),
            hintStyle: GoogleFonts.poppins(
                fontSize: isTablet ? 18 : 15, color: HexColor("#D2D2D2")),
            hintText: "Name or Username",
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#8592E5"), width: 1.0),
              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(25),
              //     bottomLeft: Radius.circular(25)),
              borderRadius: BorderRadius.circular(25),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: HexColor("#C7C8CF"), width: 1.0),
              borderRadius: BorderRadius.circular(25),
              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(25),
              //     bottomLeft: Radius.circular(25)),
            ),
            contentPadding: EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 3.0),
          )),
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#354291'),
        title: Text(
          "Search",
          key: Key('familyMemberSearchAppbarKey'),
          style: GoogleFonts.poppins(fontSize: isTablet ? 18 : 15),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: isTablet ? 24 : 14.0, right: isTablet ? 24 : 14, top: 15),
        child: Column(
          children: [
            Row(
              children: [
                searchField,
              ],
            ),
            SizedBox(
              height: 10,
            ),
            vm.isLoading
                ? Center(
                    child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppTheme.appbarPrimary),
                  ))
                : Expanded(
                    child: SingleChildScrollView(
                      physics: ScrollPhysics(),
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: familyMembers.length,
                          itemBuilder: (BuildContext context, int index) {
                            var photo = familyMembers[index]?.photo ?? "";
                            return Container(
                                decoration: BoxDecoration(
                                  color: HexColor("#F0F2FF"),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                margin: EdgeInsets.only(top: 5, bottom: 5),
                                constraints: BoxConstraints(
                                  minHeight: isTablet ? 85 : 70,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 10,
                                        ),
                                        photo != ""
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: AppTheme
                                                          .appbarPrimary),
                                                  //color: AppTheme.appbarPrimary,
                                                  shape: BoxShape.circle,
                                                ),
                                                height: isTablet ? 55 : 50,
                                                width: isTablet ? 55 : 50,
                                                child: Center(
                                                    child: imageVm
                                                        .loadProfileImage(
                                                            photo,
                                                            isTablet ? 50 : 45,
                                                            isTablet ? 50 : 45,
                                                            50)))
                                            : Container(
                                                decoration: BoxDecoration(
                                                  color: AppTheme.appbarPrimary,
                                                  shape: BoxShape.circle,
                                                ),
                                                height: isTablet ? 55 : 50,
                                                width: isTablet ? 55 : 50,
                                                child: Center(
                                                  child: Image.asset(
                                                    'assets/images/dPro.png',
                                                    height: isTablet ? 32 : 27,
                                                    width: isTablet ? 32 : 27,
                                                  ),
                                                )),
                                        SizedBox(
                                          width: isTablet
                                              ? 25
                                              : width <= 330
                                                  ? 15
                                                  : 20,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: width * .4,
                                              child: Text(
                                                familyMembers[index].fname,
                                                maxLines: 1,
                                                style: GoogleFonts.poppins(
                                                    color: HexColor("#0D1231"),
                                                    fontSize:
                                                        isTablet ? 18 : 16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                            ),
                                            Text(
                                              familyMembers[index]
                                                  .hospitalNumber,
                                              style: GoogleFonts.poppins(
                                                fontSize: isTablet ? 17 : 15,
                                                color: AppTheme.appbarPrimary,
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        var memberRegId;
                                        var relation;
                                        familyVm.familyMembersList
                                            .forEach((item) {
                                          if (item.fmRegId.contains(
                                              familyMembers[index]
                                                  .hospitalNumber)) {
                                            memberRegId = familyMembers[index]
                                                .hospitalNumber;
                                            relation = item.relationName;
                                          }
                                        });
                                        if (user ==
                                            familyMembers[index]
                                                .hospitalNumber) {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'You cannot add yourself as your family member.',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 12.0);
                                        } else if (memberRegId == null &&
                                            familyMembers[index]
                                                    .hospitalNumber !=
                                                user) {
                                          vm.addFamilyMemberInfo(
                                              name: vm.members[index].fname,
                                              regId: userVm.userDetailsList
                                                  .hospitalNumber
                                                  .toString(),
                                              regNo: userVm.userDetailsList.id
                                                  .toString(),
                                              relatedRegNo: vm.members[index].id
                                                  .toString(),
                                              image: photo,
                                              relatedRegId: familyMembers[index]
                                                  .hospitalNumber);
                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return AddFamilyMember(
                                              photo: photo,
                                            );
                                          }));
                                        } else {
                                          Fluttertoast.showToast(
                                              msg:
                                                  'The user is already added in your list as your $relation',
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              backgroundColor: Colors.red,
                                              textColor: Colors.white,
                                              fontSize: 12.0);
                                        }
                                      },
                                      key: Key('addMemberKey$index'),
                                      child: Container(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.person_add,
                                              color: HexColor("#4077BC"),
                                              size: isTablet ? 30 : 25,
                                            ),
                                            Text(
                                              "Add Member",
                                              style: GoogleFonts.poppins(
                                                  color: HexColor("#4077BC"),
                                                  fontSize: isTablet ? 15 : 11),
                                            )
                                          ],
                                        ),
                                        decoration: BoxDecoration(
                                            color: HexColor("#D2D9FF"),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        width: isTablet
                                            ? 110
                                            : width <= 330
                                                ? 85
                                                : 90,
                                        constraints: BoxConstraints(
                                          minHeight: isTablet ? 85 : 70,
                                        ),
                                        //height: isTablet? 85 : 70,
                                      ),
                                    ),
                                  ],
                                ));
                          }),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
