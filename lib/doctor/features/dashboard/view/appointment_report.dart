import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/doctor/features/dashboard/view/widgets/dashboard_drawer.dart';
import 'package:myhealthbd_app/doctor/features/dashboard/view/widgets/worklists_widget.dart';
import 'package:myhealthbd_app/doctor/features/profile/view_model/personal_info_view_model.dart';
import 'package:myhealthbd_app/doctor/main_app/resource/doctor_const.dart';
import 'package:myhealthbd_app/features/dashboard/view/widgets/manage_account_prompt.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

import 'widgets/all_workilist_view.dart';
import 'widgets/manage_doctor_profile_prompt.dart';

class AppointmentReport extends StatefulWidget {
  @override
  _AppointmentReportState createState() => _AppointmentReportState();
}

class _AppointmentReportState extends State<AppointmentReport> {
  @override
  void initState() {
    var companyInfoVm = Provider.of<UserImageViewModel>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      await companyInfoVm.userImage();
    });
    // TODO: implement initState
    super.initState();
  }

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var companyInfoVm = Provider.of<UserImageViewModel>(context, listen: true);
    var dVm = Provider.of<PersonalInfoViewModel>(context, listen: true);
    var photo = companyInfoVm.details?.photo ?? '';
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var deviceHeight = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var spaceBetween = SizedBox(
      height: 10,
    );
    var fromDate = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'From',
          style: GoogleFonts.poppins(
              fontSize: isTablet
                  ? 18
                  : width <= 330
                      ? 12
                      : 16,
              fontWeight: FontWeight.w500),
        ),
        Container(
          height: width<=330? 35 : 45,
          width: isTablet? 160 : width <= 330 ? 110 : 140,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: HexColor("#6374DF"), // set border color
              //width: 3.0
            ), // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)), // set rounded corner radius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '22/12/18',
                style: GoogleFonts.poppins(
                    fontSize: isTablet
                        ? 18
                        : width <= 330
                            ? 12
                            : 14,
                    color: Colors.black,
                ),
              ),
              SizedBox(
                width: 20,
              ),
              SvgPicture.asset(
                "assets/icons/calendoc.svg",
                //key: Key('filterIconKey'),
                width: 10,
                height: 18,
                fit: BoxFit.fitWidth,
                allowDrawingOutsideViewBox: true,
                matchTextDirection: true,
              ),
            ],
          ),
        )
      ],
    );
    var toDate = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'To',
          style: GoogleFonts.poppins(
              fontSize: isTablet
                  ? 18
                  : width <= 330
                      ? 12
                      : 16,
              fontWeight: FontWeight.w500),
        ),
        Container(
          height: width<=330? 35 : 45,
          width: isTablet? 160 : width <= 330 ? 110 : 140,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: HexColor("#6374DF"), // set border color
              //width: 3.0
            ), // set border width
            borderRadius: BorderRadius.all(
                Radius.circular(10.0)), // set rounded corner radius
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '30/12/18',
                style: GoogleFonts.poppins(
                    fontSize: isTablet
                        ? 18
                        : width <= 330
                            ? 12
                            : 14,
                    color: Colors.black,
                    ),
              ),
              SizedBox(
                width: 20,
              ),
              SvgPicture.asset(
                "assets/icons/calendoc.svg",
                //key: Key('filterIconKey'),
                width: 10,
                height: 18,
                fit: BoxFit.fitWidth,
                allowDrawingOutsideViewBox: true,
                matchTextDirection: true,
              ),
            ],
          ),
        )
      ],
    );
    var shiftHeading = Text(
      'Shift:',
      style: GoogleFonts.poppins(fontSize: isTablet? 18 : width<=330? 12 : 16),
    );
    var shiftList = Expanded(
      child: Container(
        height: width<=330? 35 : 40,
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            itemBuilder: (context, int index) {
              return Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(5),
                      constraints: BoxConstraints(minWidth: isTablet? 130 : 100, minHeight: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xffE2E2E2),
                      ),
                      child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              children: [
                                Container(
                                  height: width<=330? 15 : 20,
                                  width: width<=330? 15 : 20,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      border: Border.all(color: Colors.white),
                                      color: selectedIndex == index
                                          ? Color(0xff74FF9E)
                                          : Colors.white),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  index == 0
                                      ? "All"
                                      : index == 1
                                          ? "Morning"
                                          : "Evening",
                                  style: GoogleFonts.poppins(fontSize: isTablet? 17 : width<=330? 12 : 14),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ],
              );
            }),
      ),
    );
    var viewButton = Align(
      alignment: Alignment.centerRight,
      child: FlatButton(
          minWidth: isTablet? width*.4 : width * .45,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          color: AppTheme.buttonActiveColor,
          onPressed: () async {},
          child: Text(
            'View Report',
            style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: isTablet? 17 : width <= 330 ? 12 : 15,
                fontWeight: FontWeight.w600),
          )),
    );
    var dateSection = Container(
      constraints: BoxConstraints(
        minHeight: 120,
        minWidth: width <= 330 ? width * .9 : width * .925,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: HexColor("#FFFFFF"),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: Column(
          children: [
            spaceBetween,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [fromDate, SizedBox(), toDate],
            ),
            spaceBetween,
            Row(
              children: [shiftHeading, shiftList],
            ),
            width<=330? SizedBox() : spaceBetween,
            width<=330? SizedBox() :  spaceBetween,
            viewButton,
            spaceBetween,
            width<=330? SizedBox() :  spaceBetween
          ],
        ),
      ),
    );
    var widthSpace = SizedBox(
      width: 5,
    );
    var widthSpaceTab = SizedBox(
      width: 10,
    );
    return Scaffold(
      backgroundColor: AppTheme.dashboardBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Appointment Report',
          style: GoogleFonts.poppins(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              spaceBetween,
              width<=330?  SizedBox() : spaceBetween,
              dateSection,
              spaceBetween,
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 11,
                  itemBuilder: (context, index) {
                    var indexInc = ++index;
                    return Container(
                        constraints: BoxConstraints(minHeight: width<=330? 60 : 80),
                        margin: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)),
                        child: Row(
                          children: [
                            Container(
                                constraints:
                                    BoxConstraints(minHeight: width<=330? 70 : 90, minWidth: 60),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: AppTheme.buttonActiveColor),
                                child: Center(
                                  child: Text(
                                    indexInc < 10
                                        ? "0${indexInc.toString()}"
                                        : indexInc.toString(),
                                    style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontSize: isTablet? 20 :  width<=330? 15 : 17 ,
                                        fontWeight: FontWeight.w600),
                                  ),
                                )),
                            Padding(
                              padding:  EdgeInsets.only(left: isTablet ? 25 : 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Zia Uddin Arman',
                                    style: GoogleFonts.poppins(fontSize: isTablet? 18 : width<=330? 12 :  14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        constraints:
                                            BoxConstraints(minWidth: 90),
                                        child: Text(
                                          'MH22012014368',
                                          style:
                                              GoogleFonts.poppins(fontSize: isTablet? 16: 11),
                                        ),
                                      ),
                                      widthSpace,
                                      isTablet? widthSpaceTab : SizedBox(),
                                      Container(
                                        width: 1,
                                        constraints:
                                            BoxConstraints(minHeight: 20),
                                        color: AppTheme.buttonActiveColor,
                                      ),
                                      widthSpace,
                                      isTablet? widthSpaceTab : SizedBox(),
                                      Text(
                                        '2nd Follow Up',
                                        style:
                                            GoogleFonts.poppins(fontSize:isTablet? 16 : 11),
                                      ),
                                      widthSpace,
                                      isTablet? widthSpaceTab : SizedBox(),
                                      width > 330
                                          ? Container(
                                              width: 1,
                                              constraints:
                                                  BoxConstraints(minHeight: 20),
                                              color: AppTheme.buttonActiveColor,
                                            )
                                          : SizedBox(),
                                      width > 330 ? widthSpace : SizedBox(),
                                      isTablet? widthSpaceTab : SizedBox(),
                                      width > 330
                                          ? Container(
                                              constraints:
                                                  BoxConstraints(minWidth: 60),
                                              child: Text(
                                                '08/08/2021',
                                                style: GoogleFonts.poppins(
                                                    fontSize: isTablet? 16 : 11),
                                              ),
                                            )
                                          : SizedBox(),
                                      widthSpace,
                                      isTablet? widthSpaceTab : SizedBox(),
                                      isTablet
                                          ? Container(
                                              width: 1,
                                              constraints:
                                                  BoxConstraints(minHeight: 20),
                                              color: AppTheme.buttonActiveColor,
                                            )
                                          : SizedBox(),
                                      widthSpace,
                                      isTablet? widthSpaceTab : SizedBox(),
                                      isTablet
                                          ? Container(
                                              constraints:
                                                  BoxConstraints(minWidth: 90),
                                              child: Text(
                                                'Morning',
                                                style: GoogleFonts.poppins(
                                                    fontSize: isTablet? 14 : 11),
                                              ),
                                            )
                                          : SizedBox()
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      isMobile
                                          ? Container(
                                              constraints:
                                                  BoxConstraints(minWidth: 90),
                                              child: Text(
                                                'Morning',
                                                style: GoogleFonts.poppins(
                                                    fontSize: isTablet? 14 : 11),
                                              ),
                                            )
                                          : SizedBox(),
                                      width <= 330 ? widthSpace : SizedBox(),
                                      width <= 330
                                          ? Container(
                                              width: 1,
                                              constraints:
                                                  BoxConstraints(minHeight: 20),
                                              color: AppTheme.buttonActiveColor,
                                            )
                                          : SizedBox(),
                                      width <= 330 ? widthSpace : SizedBox(),
                                      width <= 330
                                          ? Container(
                                              constraints:
                                                  BoxConstraints(minWidth: 60),
                                              child: Text(
                                                '08/08/2021',
                                                style: GoogleFonts.poppins(
                                                    fontSize: isTablet? 14 : 11),
                                              ),
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ));
                  })
            ],
          ),
        ),
      ),
    );
  }

  void showAlert(BuildContext context) {
    // var vm = Provider.of<UserDetailsViewModel>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) => Material(
            color: Colors.transparent, child: ManageDoctorProfilePrompt()));
  }
}
