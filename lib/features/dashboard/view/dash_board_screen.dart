import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:myhealthbd_app/features/appointments/models/book_appointment_model.dart';
import 'package:myhealthbd_app/features/auth/view_model/accessToken_view_model.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/features/auth/view_model/sign_out_view_model.dart';
import 'package:myhealthbd_app/features/dashboard/view/widgets/manage_account_prompt.dart';
import 'package:myhealthbd_app/features/dashboard/view/widgets/video_article_blog_details.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/blog_logo_view_model.dart';
import 'package:myhealthbd_app/features/hospitals/models/company_logo_model.dart';
import 'package:myhealthbd_app/features/dashboard/view/widgets/custom_blog_widget.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/blog_view_model.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/hospital_list_view_model.dart';
import 'package:myhealthbd_app/features/find_doctor/view/find_doctor_screen.dart';
import 'package:myhealthbd_app/features/hospitals/models/hospital_list_model.dart'
    as hos;
import 'package:myhealthbd_app/features/hospitals/view_model/hospital_image_view_model.dart';
import 'package:myhealthbd_app/features/hospitals/view_model/hospital_logo_view_model.dart';
import 'package:myhealthbd_app/features/my_health/view/widgets/switch_account.dart';
import 'package:myhealthbd_app/features/news/model/news_model.dart' as news;
import 'package:myhealthbd_app/features/news/repositories/news_repository.dart';
import 'package:myhealthbd_app/features/news/view/news_screen.dart';
import 'package:myhealthbd_app/features/news/view_model/news_logo_view_model.dart';
import 'package:myhealthbd_app/features/news/view_model/news_view_model.dart';
import 'package:myhealthbd_app/features/auth/view/sign_in_screen.dart';
import 'package:myhealthbd_app/features/hospitals/view/hospital_screen.dart';
import 'package:myhealthbd_app/features/user_profile/models/userDetails_model.dart';
import 'package:myhealthbd_app/features/user_profile/view/user_profile_screen.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/features/videos/models/channel_info_model.dart'
    as video;
import 'package:myhealthbd_app/features/videos/models/channel_info_model.dart';
import 'package:myhealthbd_app/features/videos/repositories/channel_Info_repository.dart';
import 'package:myhealthbd_app/features/videos/view_models/video_view_model.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:myhealthbd_app/main_app/home.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_card_pat.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_card_video.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_card_view.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_card_view_for_news.dart';
import 'package:myhealthbd_app/main_app/views/widgets/failure_widget.dart';
import 'package:myhealthbd_app/main_app/views/widgets/search_bar_viw_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';


class DashboardScreen extends StatefulWidget {
  final Function menuCallBack;
  bool isDrawerOpen;
  String accessToken;
  final Function onTapFeaturedCompany;


  DashboardScreen(
      {this.menuCallBack,
      this.isDrawerOpen,
      this.accessToken,
      this.onTapFeaturedCompany});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  File imageData;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<ScaffoldState> _scaffoldKey2 = new GlobalKey<ScaffoldState>();
  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(25.0),
    topRight: Radius.circular(25.0),
  );
  //CountdownTimerController controller;
  double xOffset = 0.0;
  double yOffset = 0.0;
  double scaleFactor = 1;

  loadLogo(String image) {
    Uint8List _bytesImage = Base64Decoder().convert(image);
    return _bytesImage;
  }

  loadImage(String image) {
    Uint8List _bytesImage = Base64Decoder().convert(image);
    return _bytesImage;
  }

  var lasTtimerr;

  lastTme() async{

    SharedPreferences lastTimer=await SharedPreferences.getInstance();

    if(lastTimer.containsKey('lastBookingTime')){
      lasTtimerr=lastTimer.getInt('lastBookingTime');
      print('lasttttt'+lasTtimerr.toString());
    }

  }

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await Provider.of<UserImageViewModel>(context, listen: false).userImage();
    });

    // TODO: implement initState
    var vm = Provider.of<HospitalListViewModel>(context, listen: false);
    vm.getData();
    var vm2 = Provider.of<NewsViewModel>(context, listen: false);
    vm2.getData();
    var vm3 = Provider.of<VideoViewModel>(context, listen: false);
    vm3.getData();
    var vm4 = Provider.of<BLogViewModel>(context, listen: false);
    vm4.getData();
    var vm5 = Provider.of<HospitalLogoViewModel>(context, listen: false);
    vm5.getData();
    print('Bdfor data');
    var vm6 = Provider.of<HospitalImageViewModel>(context, listen: false);
    vm6.getImageData();
    var vm7 = Provider.of<NewsLogoViewModel>(context, listen: false);
    vm7.getData();
    var vm8 = Provider.of<BLogLogoViewModel>(context, listen: false);
    vm8.getData();
    lastTme();
   // controller = CountdownTimerController(endTime: lasTtimerr!=null?lasTtimerr:DateTime.now().millisecondsSinceEpoch);

    super.initState();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   //fetchHospitalList();
  //   controller.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    var vm9 = Provider.of<AccessTokenProvider>(context, listen: false);
    var vm = appNavigator.getProviderListener<HospitalListViewModel>();
    List<hos.Item> list = vm.hospitalList;
    var lengthofHospitalList;
    MediaQuery.of(context).size.width > 600
        ? lengthofHospitalList = list.length < 5 ? list.length : 6
        : lengthofHospitalList = list.length < 5 ? list.length : 5;

    var vm2 = Provider.of<NewsViewModel>(context);
    var vm10 = Provider.of<UserImageViewModel>(context, listen: true);
    var photo = vm10.details?.photo ?? "";
    List<news.Item> list2 = vm2.newsList;
    var lengthofNewsList = list2.length;

    var vm3 = Provider.of<VideoViewModel>(context);
    List<video.Item> list3 = vm3.videoList;
    var lengthofVideoList = list3.length;
    // MediaQuery.of(context).size.width > 600
    //     ? lengthofVideoList = list3.length < 5 ? list3.length : 6
    //     : lengthofVideoList = list3.length < 5 ? list3.length : 5;
    print('VideoLength:::::' + lengthofVideoList.toString());

    var deviceHeight = MediaQuery.of(context).size.height;
    var deviceWidth = MediaQuery.of(context).size.width;

    var vm4 = Provider.of<BLogViewModel>(context);
    var vm5 = Provider.of<HospitalLogoViewModel>(context);
    var vm6 = Provider.of<HospitalImageViewModel>(context);
    var vm7 = Provider.of<NewsLogoViewModel>(context);
    var vm8 = Provider.of<BLogLogoViewModel>(context);


    // List<Item> list5 = vm5.hospitalLogoList;
    // var lengthofHopitalLogoList = list5.length;

    var contrainerWidth = deviceWidth >= 400 ? double.infinity : 400.00;

    final String assetName1 = "assets/icons/sign_in.svg";
    final Widget svg = SvgPicture.asset(
      assetName1,
      width: 8,
      height: 15,
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 230.0, top: 60),
          child: AnimatedContainer(
            transform: Matrix4.translationValues(-0.5, yOffset, 0)..scale(0.7),
            duration: Duration(milliseconds: 200),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.3),
                borderRadius: BorderRadius.all(Radius.circular(30))),
            height: double.infinity,
            width: double.infinity,
            child: Container(),
          ),
        ),

        // AnimatedContainer(
        //   transform: Matrix4.translationValues(xOffset, yOffset, 0)
        //     ..scale(scaleFactor),
        //   duration: Duration(milliseconds: 200),
        //   decoration: BoxDecoration(
        //       color: Colors.white,
        //       borderRadius: BorderRadius.all(Radius.circular(isDrawerOpen?60:0))),
        //   height: double.infinity,
        //   width: double.infinity,
        //   child:

        Stack(
          children: <Widget>[
            Stack(children: [
              widget.isDrawerOpen
                  ? this._backgroundImage()
                  : this._backgroundImage2(),
              // Padding(
              //   padding: const EdgeInsets.only(top: 80.0, left: 70),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "20 Health tips",
              //         style: GoogleFonts.poppins(
              //             fontSize: 25,
              //             color: Colors.white,
              //             fontWeight: FontWeight.bold),
              //       ),
              //       SizedBox(
              //         height: 1,
              //       ),
              //       Text(
              //         "to help you start off towards \nhealthy living in 2021",
              //         style: GoogleFonts.poppins(
              //             fontSize: 10,
              //             color: Colors.white,
              //             fontWeight: FontWeight.w500),
              //       ),
              //       SizedBox(
              //         height: 8,
              //       ),
              //       Container(
              //         width: 90,
              //         height: 20,
              //         decoration: BoxDecoration(
              //           border: Border.all(color: Colors.white),
              //           borderRadius: BorderRadius.circular(30),
              //         ),
              //         child: Padding(
              //           padding: const EdgeInsets.only(right: 10.0, left: 10),
              //           child: Row(
              //             children: [
              //               Text(
              //                 "Read More",
              //                 style: GoogleFonts.poppins(
              //                     color: Colors.white, fontSize: 8),
              //               ),
              //               Spacer(),
              //               Icon(
              //                 Icons.arrow_forward,
              //                 size: 10,
              //                 color: Colors.white,
              //               )
              //             ],
              //           ),
              //         ),
              //       )
              //     ],
              //   ),
              // ),
              Scaffold(
                resizeToAvoidBottomInset: false,
                key: _scaffoldKey,
                backgroundColor: Colors.transparent,
                appBar:  AppBar(
                  // leading: Container(
                  //     height: 10,
                  //     child: svg),
                  title:  Text(
                    StringResources.dasboardAppBarText,
                    style: GoogleFonts.poppins(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: vm9.accessToken == null
                          ? GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageRouteBuilder(
                                      transitionDuration: Duration(seconds: 1),
                                      transitionsBuilder: (context, animation,
                                          secondaryAnimation, child) {
                                        var begin = Offset(0, 1.0);
                                        var end = Offset.zero;
                                        var curve = Curves.easeInOut;

                                        var tween = Tween(
                                                begin: begin, end: end)
                                            .chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                      pageBuilder: (context, animation,
                                              secondaryAnimation) =>
                                          SignIn(),
                                    ));
                              },
                              child: Row(
                                children: [
                                  Text(
                                    StringResources.dasboardAppBarSignInText,
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 10),
                                  ),
                                  SizedBox(
                                    width: 3,
                                  ),
                                  svg,
                                  // CircleAvatar(
                                  //   radius: 18,
                                  //   backgroundColor: Colors.white,
                                  //   child: CircleAvatar(
                                  //     backgroundImage: AssetImage('assets/images/proimg.png'),
                                  //     radius: 16,
                                  //   ),
                                  // ),
                                ],
                              ))
                          : GestureDetector(
                              onTap: () {
                                showAlert(context);
                                // showDialog(context: context, builder: (context) => carDialog);
                              },
                              child: photo != ""
                                  ? Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppTheme.appbarPrimary),
                                    //color: AppTheme.appbarPrimary,
                                    shape: BoxShape.circle,
                                  ),
                                  height: 35,
                                  width: 35,
                                  child: Center(
                                      child: vm10.loadProfileImage(photo, 33.5, 35,50)
                                  ))
                                  : Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.appbarPrimary,
                                        shape: BoxShape.circle,
                                      ),
                                      height: 32,
                                      width: 32,
                                      child: Center(
                                        child: Image.asset(
                                          'assets/images/dPro.png',
                                          height: 22,
                                          width: 22,
                                        ),
                                      )),
                            ),
                    )
                  ],
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  leading: Container(
                      child: widget.isDrawerOpen
                          ? IconButton(
                              iconSize: 35,
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                widget.menuCallBack();
                              })
                          : IconButton(
                              icon: Icon(Icons.notes),
                              onPressed: () {
                                widget.menuCallBack();
                              })),
                ),
                body: DraggableScrollableSheet(
                    // height: double.infinity,
                    // // minHeight: deviceHeight>=600?480:250,
                    // // maxHeight: 710,
                    // // isDraggable: true,
                    // // //backdropEnabled: true,
                    // // borderRadius: isDrawerOpen?BorderRadius.all(Radius.circular(30)):radius,
                    // decoration: BoxDecoration(
                    //     borderRadius: widget.isDrawerOpen
                    //         ? BorderRadius.all(Radius.circular(25))
                    //         : BorderRadius.only(
                    //             topLeft: Radius.circular(25),
                    //             topRight: Radius.circular(25)),
                    //     color: HexColor("#FFFFFF"),
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: HexColor("#0D1231").withOpacity(0.08),
                    //         spreadRadius: 10,
                    //         blurRadius: 7,
                    //         offset: Offset(0, 3), // changes position of shadow
                    //       ),
                    //     ]),

                    initialChildSize: 0.83,
                    maxChildSize: 1.0,
                    minChildSize: 0.83,
                    builder: (BuildContext context,
                        ScrollController scrollController) {
                      return Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              controller: scrollController,
                              scrollDirection: Axis.vertical,
                              physics: AlwaysScrollableScrollPhysics(),
                              child: Container(
                                // height:200,
                                decoration: BoxDecoration(
                                    borderRadius: widget.isDrawerOpen
                                        ? BorderRadius.all(Radius.circular(25))
                                        : BorderRadius.only(
                                            topLeft: Radius.circular(25),
                                            topRight: Radius.circular(25)),
                                    color: HexColor("#FFFFFF"),
                                    boxShadow: [
                                      BoxShadow(
                                        color: HexColor("#0D1231")
                                            .withOpacity(0.08),
                                        spreadRadius: 10,
                                        blurRadius: 7,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ]),
                                //color: Colors.white,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18, left: 20.0, right: 20),
                                      child: Row(
                                        children: [
                                          Text(
                                            StringResources
                                                .esayDoctorAppointmentText,
                                            style: GoogleFonts.poppins(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Spacer(),
                                          Container(
                                              width: MediaQuery.of(context)
                                                          .size
                                                          .width <=
                                                      450
                                                  ? 70
                                                  : 100,
                                              child: Image.asset(
                                                  "assets/images/my_health_logo.png")),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0, right: 15),
                                      child: GestureDetector(
                                        onTap: widget.onTapFeaturedCompany,
                                        child: Container(
                                          width: contrainerWidth,
                                          height: 50,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25),
                                            color: Colors.white,
                                            border: Border.all(
                                                color: HexColor('#E1E1E1')),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.2),
                                                spreadRadius: 2,
                                                blurRadius: 5,
                                                offset: Offset(0,
                                                    2), // changes position of shadow
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
                                            child: Row(
                                              children: [
                                                Text(
                                                  StringResources.searchBoxHint,
                                                  style: TextStyle(
                                                    color: Colors.grey[400],
                                                    fontSize: deviceWidth >= 400
                                                        ? 15
                                                        : 14,
                                                  ),
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding: const EdgeInsets.only(right:12.0),
                                                  child: Icon(
                                                    Icons.search_sharp,
                                                    color: Colors.grey[400],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // SizedBox(
                                    //   height: 10,
                                    // ),
                                    // vm9.accessToken == null || lasTtimerr==null
                                    //     ? Container()
                                    //     : CustomCardPat(
                                    //         "You have an upcoming appointment",
                                    //         "22-02-2021 Monday 08:30pm \nSerial-12",
                                    //         "Dr. Jahid Hasan",
                                    //         "Alok hospital",
                                    //     lasTtimerr,
                                    //   //controller
                                    // ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, right: 18),
                                      child: Row(
                                        children: [
                                          Text(
                                            StringResources
                                                .hospitalDiagnosticsText,
                                            style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HospitalScreen()));
                                              },
                                              child: Text(
                                                StringResources.viewAllText,
                                                style: GoogleFonts.poppins(
                                                    color: AppTheme.appbarPrimary,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    vm.shouldShowPageLoader ||
                                            vm5.shouldShowPageLoader ||
                                            vm6.shouldShowPageLoaderForImage
                                        ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 18.0,
                                            ),
                                            child: Container(
                                              width: 1510,
                                              height:  120.0,
                                              child: Shimmer.fromColors(
                                                baseColor: Colors.grey[300],
                                                highlightColor: Colors.white,
                                                child: Row(
                                                    children: List.generate(
                                                        5,
                                                            (index) => Expanded(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Material(
                                                              color: Colors.grey,
                                                              borderRadius: BorderRadius.circular(5),
                                                              child: Center(),
                                                            ),
                                                          ),
                                                        ))),
                                              ),
                                            ),
                                          ),
                                        ) : SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 18.0,
                                              ),
                                              child: Row(
                                                children: [
                                                  ...List.generate(
                                                      lengthofHospitalList,
                                                      (i) {
                                                    int index = vm5
                                                        .hospitalLogoList
                                                        .indexWhere((element) =>
                                                            element.id ==
                                                            list[i].id);
                                                    int imageindex = vm6
                                                        .hospitalImageList
                                                        .indexWhere((element) =>
                                                            element.id ==
                                                            list[i].id);
                                                    return CustomCard(
                                                      loadLogo(vm5
                                                          .hospitalLogoList[
                                                              index]
                                                          .photoLogo),
                                                      vm6
                                                                  .hospitalImageList[
                                                                      imageindex]
                                                                  .photoImg !=
                                                              null
                                                          ? loadImage(vm6
                                                              .hospitalImageList[
                                                                  imageindex]
                                                              .photoImg)
                                                          : loadLogo(vm5
                                                              .hospitalLogoList[
                                                                  index]
                                                              .photoLogo),
                                                      list[i].companyName,
                                                      list[i].companyAddress ==
                                                              null
                                                          ? "Mirpur,Dahaka,Bangladesh"
                                                          : list[i]
                                                              .companyAddress,
                                                      "60 Doctors",
                                                      list[i].companyPhone ==
                                                              null
                                                          ? "+880 1962823007"
                                                          : list[i]
                                                              .companyPhone,
                                                      list[i].companyEmail ==
                                                              null
                                                          ? "info@mysoftitd.com"
                                                          : list[i]
                                                              .companyEmail,
                                                      list[i].companyLogo,
                                                      list[i].companyId,
                                                      list[i].ogNo.toString(),
                                                      list[i].id.toString(),
                                                    );
                                                  }),
                                                ],
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, right: 18),
                                      child: Row(
                                        children: [
                                          Text(
                                            "MyHealthBD News",
                                            style: GoogleFonts.poppins(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width <=
                                                        450
                                                    ? 14
                                                    : 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HealthVideoAll(
                                                              pageNo: 1,
                                                            )));
                                              },
                                              child: Text(
                                                StringResources.viewAllText,
                                                style: GoogleFonts.poppins(
                                                    color: AppTheme.appbarPrimary,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // vm2.shouldShowAppError
                                    //     ? ListView( key: Key('allJobsListView2'),
                                    //   children: [errorWidget()],
                                    // ):
                                    vm2.shouldShowPageLoader ||
                                            vm7.shouldShowPageLoader
                                        ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                        ),
                                        child: Container(
                                          width: 1510,
                                          height:  120.0,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300],
                                            highlightColor: Colors.white,
                                            child: Row(
                                                children: List.generate(
                                                    5,
                                                        (index) => Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Material(
                                                          color: Colors.grey,
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: Center(),
                                                        ),
                                                      ),
                                                    ))),
                                          ),
                                        ),
                                      ),
                                    )
                                        : vm2.shouldShowNoNewsFound
                                            ? Center(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text(StringResources
                                                      .noNewsFound),
                                                  key: Key('noJobsFound1'),
                                                ),
                                              )
                                            : SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                    left: 18.0,
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      ...List.generate(
                                                        lengthofNewsList,
                                                        (i) {
                                                          int index = vm7
                                                              .newsLogoList
                                                              .indexWhere((element) =>
                                                                  element
                                                                      .blogNo ==
                                                                  list2[i]
                                                                      .blogNo);
                                                          return CustomCardNews(
                                                              loadLogo(vm7
                                                                  .newsLogoList[
                                                                      index]
                                                                  .logo),
                                                              DateUtil().formattedDate(
                                                                  DateTime.parse(
                                                                          list2[i]
                                                                              .publishDate)
                                                                      .toLocal()),
                                                              list2[i].title,
                                                              list2[i]
                                                                  .newsLink);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, right: 18),
                                      child: Row(
                                        children: [
                                          Text(
                                            "MyHealthBD Blog",
                                            style: GoogleFonts.poppins(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width <=
                                                        450
                                                    ? 14
                                                    : 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            HealthVideoAll(
                                                              pageNo: 0,
                                                            )));
                                              },
                                              child: Text(
                                                StringResources.viewAllText,
                                                style: GoogleFonts.poppins(
                                                    color: AppTheme.appbarPrimary,
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              )),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    vm4.shouldShowPageLoader ||
                                            vm8.shouldShowPageLoader
                                        ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                        ),
                                        child: Container(
                                          width: 1510,
                                          height:  120.0,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300],
                                            highlightColor: Colors.white,
                                            child: Row(
                                                children: List.generate(
                                                    5,
                                                        (index) => Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Material(
                                                          color: Colors.grey,
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: Center(),
                                                        ),
                                                      ),
                                                    ))),
                                          ),
                                        ),
                                      ),
                                    ) : Padding(
                                            padding: const EdgeInsets.only(
                                              left: 18.0,
                                            ),
                                            child: SizedBox(
                                              height: 120,
                                              child: ListView.builder(
                                                itemBuilder:
                                                    (BuildeContext, index) {
                                                  int i = vm8.blogLogoList
                                                      .indexWhere((element) =>
                                                          element.blogNo ==
                                                          vm4.newsList[index]
                                                              .blogNo);
                                                  return CustomBlogWidget(
                                                    logo: loadLogo(vm8
                                                        .blogLogoList[i].logo),
                                                    title: vm4
                                                        .newsList[index].title,
                                                    news: vm4.newsList[index]
                                                        .blogDetail,
                                                  );
                                                },
                                                scrollDirection:
                                                    Axis.horizontal,
                                                itemCount: vm4.newsList.length,
                                              ),
                                            ),
                                          ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 18.0, right: 18),
                                      child: Row(
                                        children: [
                                          Text(
                                            "MyHealthBD Videos",
                                            style: GoogleFonts.poppins(
                                                fontSize: MediaQuery.of(context)
                                                            .size
                                                            .width <=
                                                        450
                                                    ? 14
                                                    : 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HealthVideoAll(
                                                            pageNo: 2,
                                                          )));
                                            },
                                            child: Text(
                                              StringResources.viewAllText,
                                              style: GoogleFonts.poppins(
                                                  color: AppTheme.appbarPrimary,
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    vm3.shouldShowPageLoader
                                        ? SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 18.0,
                                        ),
                                        child: Container(
                                          width: 1510,
                                          height:  120.0,
                                          child: Shimmer.fromColors(
                                            baseColor: Colors.grey[300],
                                            highlightColor: Colors.white,
                                            child: Row(
                                                children: List.generate(
                                                    5,
                                                        (index) => Expanded(
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Material(
                                                          color: Colors.grey,
                                                          borderRadius: BorderRadius.circular(5),
                                                          child: Center(),
                                                        ),
                                                      ),
                                                    ))),
                                          ),
                                        ),
                                      ),
                                    ) : Padding(
                                            padding: const EdgeInsets.only(
                                              left: 18.0,
                                            ),
                                            child: SizedBox(
                                              height: 120,
                                              child: ListView.builder(
                                                itemCount: lengthofVideoList,
                                                itemBuilder:
                                                    (BuildeContext, index) {
                                                  //int i = vm8.blogLogoList.indexWhere((element) => element.blogNo==vm4.newsList[index].blogNo);
                                                  return CustomCardVideo(
                                                      list3[index]
                                                          .snippet
                                                          .thumbnails
                                                          .standard
                                                          .url,
                                                      list3[index]
                                                          .snippet
                                                          .title,
                                                      list3[index]
                                                          .snippet
                                                          .resourceId
                                                          .videoId,
                                                      list3[index]
                                                          .snippet
                                                          .description);
                                                },
                                                scrollDirection:
                                                    Axis.horizontal,
                                              ),
                                            ),
                                          ),

                                    // SingleChildScrollView(
                                    //         scrollDirection: Axis.horizontal,
                                    //         child: Padding(
                                    //           padding: const EdgeInsets.only(
                                    //             left: 18.0,
                                    //           ),
                                    //           child: Row(
                                    //             children: [
                                    //               ...List.generate(
                                    //                 lengthofVideoList,
                                    //                 (i) => CustomCardVideo(
                                    //                     list3[i]
                                    //                         .snippet
                                    //                         .thumbnails
                                    //                         .standard
                                    //                         .url,
                                    //                     list3[i].snippet.title,
                                    //                     list3[i]
                                    //                         .snippet
                                    //                         .resourceId
                                    //                         .videoId,
                                    //                     list3[i]
                                    //                         .snippet
                                    //                         .description),
                                    //               ),
                                    //             ],
                                    //           ),
                                    //         ),
                                    //       ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      );
                    }),
              ),
            ]),
          ],
        ),
      ],
    );
  }

  Widget _backgroundImage() {
    return Container(
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(30))),

      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        image: DecorationImage(
            image: AssetImage("assets/images/dashboardImg.png"),
            fit: BoxFit.fill),
      ),
      height: 418.0,
      //width: double.infinity,
      // child: FadeInImage(
      //   fit: BoxFit.cover,
      //   image:AssetImage("assets/images/dashboard_back.png"),
      //   placeholder: AssetImage(''),
      // ),
    );
  }

  Widget _backgroundImage2() {
    return Container(
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.all(Radius.circular(30))),

      decoration: const BoxDecoration(
        color: Colors.white,
        //borderRadius: BorderRadius.all(Radius.circular(30)),
        image: DecorationImage(
            image: AssetImage("assets/images/dashboardImg.png"),
            fit: BoxFit.fill),
      ),
      height: 300.0,
      // width: double.infinity,
      // child: FadeInImage(
      //   fit: BoxFit.cover,
      //   image:AssetImage("assets/images/dashboard_back.png"),
      //   placeholder: AssetImage(''),
      // ),
    );
  }

  void showAlert(BuildContext context) {
    var vm = Provider.of<UserDetailsViewModel>(context, listen: false);
    showDialog(
        context: context,
        builder: (context) =>
            Material(color: Colors.transparent, child: ManageAccountPrompt()));
  }
}

class DateUtil {
  static const DATE_FORMAT = 'yyyy-MM-dd';

  String formattedDate(DateTime dateTime) {
    //print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}
