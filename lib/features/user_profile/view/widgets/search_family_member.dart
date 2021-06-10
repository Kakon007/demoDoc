import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/features/user_profile/models/registered_members_model.dart';
import 'package:myhealthbd_app/features/user_profile/view/family_member_list_screen.dart';
import 'package:myhealthbd_app/features/user_profile/view/widgets/add_family_member.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/registered_member_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:myhealthbd_app/main_app/views/widgets/SignUpField.dart';
import 'package:provider/provider.dart';

import '../../../constant.dart';

class SearchFamilyMember extends StatefulWidget {
  const SearchFamilyMember({Key key}) : super(key: key);

  @override
  _SearchFamilyMemberState createState() => _SearchFamilyMemberState();
}

class _SearchFamilyMemberState extends State<SearchFamilyMember> {
  TextEditingController memberSearch = TextEditingController();
  List<Item> familyMembers= [];
@override
  void initState() {
  Future.delayed(Duration.zero, () async {
    var userVm = Provider.of<UserDetailsViewModel>(appNavigator.context,listen: false);
    // TODO: implement initState
    userVm.getData();
  });

  super.initState();
  }
  Future<void> membersSearch(String query) async {
  print(query);
    var vm = Provider.of<RegisteredMemberViewModel>(context, listen: false);
    var regId= query;
    var patName= query;
    await vm.getMembers(regId, patName);
    if(vm.message=="Data Empty "){
      familyMembers=[];
    }
    else{
      familyMembers.clear();
      familyMembers=vm.members;
    }
  }
  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var vm = Provider.of<RegisteredMemberViewModel>(context, listen: true);
    var userVm = Provider.of<UserDetailsViewModel>(appNavigator.context,listen: true);
    var imageVm = Provider.of<UserImageViewModel>(appNavigator.context,listen: true);
    var width= MediaQuery.of(context).size.width;
    var searchField =Theme(
        data: Theme.of(context).copyWith(
          primaryColor: HexColor("#8592E5"),
        ),
        child: Container(
          width: isTablet?width*.935 :  width*.91,
          height: 50,
          child: TextField(
              onSubmitted: (value) {
                membersSearch(value);
              },
              controller: memberSearch,
              decoration: new InputDecoration(
                suffixIcon: Icon(
                  Icons.search,
                  //color: HexColor("#8592E5"),
                ),
                hintStyle: GoogleFonts.poppins(fontSize: isTablet? 18 : 15, color: HexColor("#D2D2D2")),
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
        ));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#354291'),
        title: Text(
          "Search",
          style: GoogleFonts.poppins(fontSize: isTablet? 18 : 15),
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.only(left: isTablet? 24 : 14.0, right: isTablet? 24 : 14, top: 15),
        child: Column(
          children: [
            Row(
              children: [
                searchField,
                // GestureDetector(
                //   onTap: (){
                //     Future.delayed(Duration.zero, () async {
                //       var vm = Provider.of<RegisteredMemberViewModel>(context, listen: false);
                //       var regId= memberSearch.text;
                //       var patName=  memberSearch.text;
                //       await vm.getMembers(regId, patName);
                //       if(vm.message=="Data Empty "){
                //         print("aaaaaaaaaaaaaaa");
                //         familyMembers=[];
                //       }
                //       else{
                //         familyMembers.clear();
                //         familyMembers=vm.members;
                //       }
                //     });
                //   },
                //   child: Padding(
                //     padding: const EdgeInsets.only(bottom: 2.4),
                //     child: Container(
                //         decoration: BoxDecoration(
                //             borderRadius: BorderRadius.only(
                //                 topRight: Radius.circular(25),
                //                 bottomRight: Radius.circular(25)),
                //             border: Border.all(color: HexColor("#8592E5")),
                //             color: HexColor("#8592E5")),
                //       width: 60,height: 48,child: Icon(Icons.search,color: HexColor("#FFFFFF"),),),
                //   ),
                // )
              ],
            ),
            SizedBox(height: 10,),
            vm.isLoading? Center(child: CircularProgressIndicator(valueColor:
            AlwaysStoppedAnimation<Color>(
                AppTheme.appbarPrimary),)) : Expanded(
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
                          height: isTablet? 85 : 70,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),

                                  photo != ""
                                      ? Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: AppTheme.appbarPrimary),
                                        //color: AppTheme.appbarPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      height: isTablet? 55 : 50,
                                      width: isTablet? 55 : 50,
                                      child: Center(
                                          child: imageVm.loadProfileImage(photo, isTablet? 50 : 45, isTablet? 50 : 45,50)
                                      ))
                                      : Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.appbarPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      height: isTablet? 55 : 50,
                                      width: isTablet? 55 : 50,
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/dPro.png',
                                          height: isTablet? 32 : 27,
                                          width: isTablet? 32 : 27,
                                        ),
                                      )),
                                  SizedBox(
                                    width: isTablet? 25 : width<=330? 15 : 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: width*.4,
                                        child: Text(
                                          familyMembers[index].fname,
                                          maxLines: 1,
                                          style: GoogleFonts.poppins(
                                              color: HexColor("#0D1231"),
                                              fontSize: isTablet? 18 : 16,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      Text(
                                        familyMembers[index].hospitalNumber,
                                        style: GoogleFonts.poppins(
                                          fontSize: isTablet? 17 : 15,
                                          color: AppTheme.appbarPrimary,),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  vm.addFamilyMemberInfo(name: vm.members[index].fname, regId: userVm.userDetailsList.hospitalNumber.toString(), regNo: userVm.userDetailsList.id.toString(), relatedRegNo:vm.members[index].id.toString(),image:photo,relatedRegId: familyMembers[index].hospitalNumber);
                                  Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context) {
                                    return AddFamilyMember(photo: photo,);
                                  }));
                                },
                                child: Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.person_add,
                                        color: HexColor("#4077BC"),
                                        size: isTablet? 30 : 25,
                                      ),
                                      Text(
                                        "Add Member",
                                        style: GoogleFonts.poppins(
                                            color: HexColor("#4077BC"),
                                            fontSize: isTablet? 15 :11),
                                      )
                                    ],
                                  ),
                                  decoration: BoxDecoration(
                                      color: HexColor("#D2D9FF"),
                                      borderRadius: BorderRadius.circular(10)),
                                  width: isTablet? 110 : width<=330 ? 85 : 90,
                                  height: isTablet? 85 : 70,
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
