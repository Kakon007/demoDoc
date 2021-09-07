import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/appointments/view/widgets/family_members.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/family_members_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:provider/provider.dart';

class ForMeBookTest extends StatefulWidget {
  const ForMeBookTest({Key key}) : super(key: key);

  @override
  _ForMeBookTestState createState() => _ForMeBookTestState();
}

class _ForMeBookTestState extends State<ForMeBookTest> {
  bool memberList = false;
  var memberBorderColor = "#EAEBED";
  String _selectedMemberType;
  var patientBorderColor = "#EAEBED";
  var selectedMemberType = "";
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var familyVm =
    Provider.of<FamilyMembersListViewModel>(context, listen: true);
    var imageVm = Provider.of<UserImageViewModel>(context, listen: true);
    var membersNameList = Row(
      children: [
        GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.0,
                width: isTablet ? width * .86 : width * .95,
                decoration: BoxDecoration(
                    color: familyVm.isSelected && memberList
                        ? AppTheme.appbarPrimary
                        : Colors.white,
                    border: Border.all(color: HexColor(memberBorderColor)),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 16.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            memberList = true;
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return FamilyMembers();
                                })).then((value) {
                                  setState(() {

                                  });
                            });
                          });
                        },
                        child: Container(
                          width: isTablet ? width * .82 : width * .88,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButtonFormField(
                              icon: Icon(
                                familyVm.isSelected && memberList
                                    ? Icons.keyboard_arrow_right_outlined
                                    : Icons.keyboard_arrow_down_sharp,
                                color: familyVm.isSelected && memberList
                                    ? Colors.white
                                    : HexColor("#D2D2D2"),
                              ),
                              iconSize: isTablet ? 30 : 25,
                              decoration: InputDecoration(
                                  contentPadding:
                                  EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  enabledBorder: InputBorder.none),
                              isExpanded: true,
                              hint: Text(
                                "Select your family member",
                                style: GoogleFonts.roboto(
                                    fontSize: isTablet ? 18 : 15,
                                    color: familyVm.isSelected && memberList
                                        ? Colors.white
                                        : HexColor("#D2D2D2")),
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              memberBorderColor != "#FF0000"
                  ? SizedBox(
                width: 2,
              )
                  : Padding(
                  padding:
                  const EdgeInsets.only(left: 16, top: 8, right: 38),
                  child: Text(
                    "This Field Is Required",
                    style: GoogleFonts.poppins(
                        color: Colors.red, fontSize: 12),
                  )),
            ],
          ),
        ),
      ],
    );
    var membersTypeList = Row(
      children: [
        GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 50.0,
                width: isTablet ? width * .86 : width * .95,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: HexColor(patientBorderColor)),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Container(
                        width: isTablet ? width * .82 : width * .88,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButtonFormField(
                            key: Key('selectAddPatientType'),
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              color: _selectedMemberType != null
                                  ? Colors.black54
                                  : HexColor("#D2D2D2"),
                            ),
                            iconSize: isTablet ? 30 : 25,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                enabledBorder: InputBorder.none),
                            isExpanded: true,
                            hint: Text(
                              "Select Type",
                              key: Key('selectTypeHintKey'),
                              style: GoogleFonts.roboto(
                                  fontSize: isTablet ? 18 : 15,
                                  color: HexColor("#D2D2D2")),
                            ),
                            // Not necessary for Option 1
                            value: _selectedMemberType,
                            onChanged: (newValue) {
                              setState(() {
                                patientBorderColor = "#EAEBED";
                                _selectedMemberType = newValue;
                                if (_selectedMemberType != selectedMemberType) {
                                  if (_selectedMemberType == "Family Member") {
                                    memberList = true;
                                  } else {
                                    memberList = false;
                                  }
                                  selectedMemberType = newValue;
                                  Future.delayed(Duration.zero, () async {
                                  });
                                }
                              });
                            },
                            items: StringResources.memberList.map((patNo) {
                              return DropdownMenuItem(
                                child: Row(
                                  children: [
                                    Text(
                                      patNo,
                                      style: GoogleFonts.roboto(
                                          fontSize: isTablet ? 18 : 15),
                                    ),
                                  ],
                                ),
                                value: patNo,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              patientBorderColor != "#FF0000"
                  ? SizedBox(
                width: 2,
              )
                  : Padding(
                  padding:
                  const EdgeInsets.only(left: 16, top: 8, right: 38),
                  child: Text(
                    "This Field Is Required",
                    style: GoogleFonts.poppins(
                        color: Colors.red, fontSize: 12),
                  )),
            ],
          ),
        ),
      ],
    );
    var memberDetail = Container(
        width: isTablet ? width * .86 : width * .95,
        decoration: BoxDecoration(
          color: HexColor("#F0F2FF"),
          borderRadius: BorderRadius.circular(10),
        ),
        margin: EdgeInsets.only(bottom: 2),
        height: isTablet
            ? 80
            : width <= 330
            ? 60
            : 70,
        // width: MediaQuery.of(context).size.width * .78,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                familyVm.imageMem != ""
                    ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: AppTheme.appbarPrimary),
                      //color: AppTheme.appbarPrimary,
                      shape: BoxShape.circle,
                    ),
                    height: isTablet
                        ? 55
                        : width <= 330
                        ? 40
                        : 50,
                    width: isTablet
                        ? 55
                        : width <= 330
                        ? 40
                        : 50,
                    child: Center(
                        child: imageVm.loadProfileImage(
                            familyVm.imageMem,
                            isTablet
                                ? 50
                                : width <= 330
                                ? 35
                                : 45,
                            isTablet
                                ? 50
                                : width <= 330
                                ? 35
                                : 45,
                            50)))
                    : Container(
                    decoration: BoxDecoration(
                      color: AppTheme.appbarPrimary,
                      shape: BoxShape.circle,
                    ),
                    height: isTablet
                        ? 55
                        : width <= 330
                        ? 40
                        : 50,
                    width: isTablet
                        ? 55
                        : width <= 330
                        ? 40
                        : 50,
                    child: Center(
                      child: Image.asset(
                        'assets/images/dPro.png',
                        height: isTablet
                            ? 32
                            : width <= 330
                            ? 22
                            : 28,
                        width: isTablet
                            ? 32
                            : width <= 330
                            ? 22
                            : 28,
                      ),
                    )),
                SizedBox(
                  width: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * .4,
                      child: Text(
                        familyVm.familyMemName,
                        style: GoogleFonts.poppins(
                            color: HexColor("#0D1231"),
                            fontSize: isTablet
                                ? 17
                                : width <= 330
                                ? 12
                                : 14,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      familyVm.relation,
                      style: GoogleFonts.poppins(
                        fontSize: isTablet
                            ? 18
                            : width <= 330
                            ? 13
                            : 15,
                        color: AppTheme.appbarPrimary,
                      ),
                    )
                  ],
                ),
              ],
            ),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        familyVm.memberDetail(
                            -1, false, "", "", "", "", "", "", "", "", "");
                      });
                    },
                    child: Icon(
                      Icons.clear,
                      size: isTablet ? 30 : 25,
                      color: AppTheme.appbarPrimary,
                    )),
                SizedBox(
                  width: isTablet ? 18 : 10,
                ),
              ],
            ),
          ],
        ));
    var spaceBetween = SizedBox(height: 10,);
    print('family name ${familyVm.familyMemName}');
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          membersTypeList,
          spaceBetween,
          membersNameList,
          spaceBetween,
          familyVm.isSelected && memberList
              ? memberDetail
              : SizedBox(),
        ],),
    );
  }
}
