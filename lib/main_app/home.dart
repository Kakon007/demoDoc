import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/after_sign_in.dart';
import 'package:myhealthbd_app/features/appointments/view/appointments_screen.dart';
import 'package:myhealthbd_app/features/auth/view/sign_in_screen.dart';
import 'package:myhealthbd_app/features/auth/view_model/accessToken_view_model.dart';
import 'package:myhealthbd_app/features/constant.dart';
import 'package:myhealthbd_app/features/dashboard/repositories/hospital_list_repository.dart';
import 'package:myhealthbd_app/features/dashboard/view/dash_board_screen.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/hospital_list_view_model.dart';
import 'package:myhealthbd_app/features/find_doctor/view/find_doctor_screen.dart';
import 'package:myhealthbd_app/features/hospitals/repositories/hospital_list_repository.dart';
import 'package:myhealthbd_app/features/hospitals/view/hospital_screen.dart';
import 'package:myhealthbd_app/features/my_health/view/my_health_screen.dart';
import 'package:myhealthbd_app/features/my_health/view/patient_portal_screen.dart';
import 'package:myhealthbd_app/features/my_health/view/widgets/switch_account.dart';
import 'package:myhealthbd_app/features/notification/view/notification_screen.dart';
import 'package:myhealthbd_app/features/setting/view/setting_screen.dart';
import 'package:myhealthbd_app/features/user_profile/view/family_member_list_screen.dart';
import 'package:myhealthbd_app/features/user_profile/view/user_profile_screen.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_Sign_prompt.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_drawer.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_drawer_2.dart';
import 'package:myhealthbd_app/main_app/views/widgets/sign_in_dashBoard_prompt.dart';
import 'package:myhealthbd_app/main_app/views/widgets/sign_in_dashboard_prompt_for_patient_profile.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../get_appointment_screen.dart';
import 'views/widgets/default_screen.dart';

class HomeScreen extends StatefulWidget {
  String accessToken;
  String userName;
  HomeScreen({this.accessToken, this.userName});
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin{
  AnimationController _animationController;
  Animation<double> scaleAnimation;
  Duration duration=Duration(milliseconds: 200);
  bool isDrawerOpen = false;
  bool isSelected=false;
  int currentIndex=0;
  List<Animation> scaleAnimations;
  _moveTo(int index){
    currentIndex=index;
    setState(() {

    });
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(25.0),
    topRight: Radius.circular(25.0),
  );
  List<Widget> screenShots;
  Map<int,Widget> screens;



  @override
  void initState() {
    print("shakil");
    print(widget.accessToken);
    // TODO: implement initState
    super.initState();
    isDrawerOpen = false;
    _animationController=AnimationController(vsync: this,duration: duration);
    scaleAnimation=Tween<double>(begin: 1.0,end:0.7).animate(_animationController);
    scaleAnimations=[
    Tween<double>(begin: 1.0,end:0.7).animate(_animationController),
    Tween<double>(begin: 1.0,end:0.5).animate(_animationController),
    Tween<double>(begin: 1.0,end:0.5).animate(_animationController),
    Tween<double>(begin: 1.0,end:0.5).animate(_animationController),
    Tween<double>(begin: 1.0,end:0.5).animate(_animationController),
    Tween<double>(begin: 1.0,end:0.5).animate(_animationController),
    Tween<double>(begin: 1.0,end:0.5).animate(_animationController),
    Tween<double>(begin: 1.0,end:0.5).animate(_animationController),
    Tween<double>(begin: 1.0,end:0.5).animate(_animationController),
    Tween<double>(begin: 1.0,end:0.5).animate(_animationController),
    ];
    //_animationController.forward();
    //screenShots=screens.values.toList();
  }

  @override
  Widget build(BuildContext context) {
    var vm9 = Provider.of<AccessTokenProvider>(context, listen: true);
    var deviceWidth=MediaQuery.of(context).size.width;
    //
    screens= {
      0: DashboardScreen(menuCallBack: (){
        setState(() {
          isDrawerOpen=true;
          _animationController.forward();
          print("Heeoollo");
        });
      },isDrawerOpen: isDrawerOpen,accessToken: vm9.accessToken,),
      1: vm9.accessToken==null?SignInPrompt("To access your Appointments,",'Appointments'):GetAppointment(),
      2: vm9.accessToken==null?SignInPrompt("To access your Patient Portal,",'Patient Portal'):PrescriptionListScreen(accessToken: vm9.accessToken,),
      3: vm9.accessToken==null?SignInPrompt("To access your Patient Portal,",'Patient Portal'):PrescriptionListScreen(accessToken: vm9.accessToken,),
      4: vm9.accessToken==null?SignInPrompt("To access your Patient Portal,",'Patient Portal'):PrescriptionListScreen(accessToken: vm9.accessToken,),
      5:NotificationScreen(),
      6:SettingScreen(accessToken: vm9.accessToken,),
      7:FamilyMemberListScreen(),
      8:SwitchAccount(),
    };

    screenShots=screens.values.toList();

    Widget buildStackedScreen(int position){
      var deviceWidth=MediaQuery.of(context).size.width;
      return AnimatedPositioned(
        duration: duration,
        top: 0,
        left:isDrawerOpen?deviceWidth*0.50:0,
        right:isDrawerOpen?deviceWidth*-0.45:0,
        bottom: 0,
        child: ScaleTransition(
          scale: scaleAnimations[position],
          child: GestureDetector(
            onTap: (){
              if(isDrawerOpen){
                setState(() {
                  isDrawerOpen=false;
                  _animationController.reverse();
                });
              }
            },
            child:AbsorbPointer(absorbing: isDrawerOpen,child: screenShots[position]),
          ),
        ),
      );
      // return Scaffold(
      //   body: screenShots[position],
      // );
    }


    List<Widget> finalStack(){
      List<Widget> stackToReturn=[];
      stackToReturn.add(
      //     widget.accessToken==null?DrawerScreen2(menuCallBack:(selectedIndex) {
      //   setState(() {
      //     //isSelected=true;
      //     screenShots=screens.values.toList();
      //     final selectedWidget=screenShots.removeAt(selectedIndex);
      //     screenShots.insert(0, selectedWidget);
      //     // ignore: unnecessary_statements
      //     selectedIndex==0?null:
      //     Navigator.push(context, MaterialPageRoute(builder: (context)=>selectedWidget));
      //   });
      // },):
          DrawerScreen(accessToken: vm9.accessToken,menuCallBack:(selectedIndex) {
        setState(() {
          //isSelected=true;
          screenShots=screens.values.toList();
          final selectedWidget=screenShots.removeAt(selectedIndex);
          screenShots.insert(0, selectedWidget);
          // ignore: unnecessary_statements
          selectedIndex==0?null:
          Navigator.push(context, MaterialPageRoute(builder: (context)=>selectedWidget));
        });
      },));
      //stackToReturn.add(DashboardScreen());
      screenShots.asMap().entries.map((e) => buildStackedScreen(e.key)).toList().reversed..forEach((element) {stackToReturn.add(element);});
      return stackToReturn;
    }




    print(widget.accessToken);
    final String dashboardiconiamg = "assets/icons/dashboard_icon.svg";
    final Widget dashboardicon = SvgPicture.asset(
      dashboardiconiamg,
      width: 10,
      color: currentIndex==0? HexColor('#354291'):HexColor('#969EC8'),
      height: 20,
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );


    final String appointmenticonimg = "assets/icons/appointment_icon.svg";
    final Widget appointmenticon = SvgPicture.asset(
      appointmenticonimg,
      width: 10,
      height: 20,
      color: currentIndex==1? HexColor('#354291'):HexColor('#969EC8'),
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );

    final String hospitaliconimag = "assets/icons/hospital_icon.svg";
    final Widget hospitalicon = SvgPicture.asset(
      hospitaliconimag,
      width: 10,
      height: 20,
      color: currentIndex==2? HexColor('#354291'):HexColor('#969EC8'),
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );



    final String myhealthiconimag = "assets/icons/myhealth_icon.svg";
    final Widget myhealthicon = SvgPicture.asset(
      myhealthiconimag,
      width: 10,
      height: 20,
      color: currentIndex==3? HexColor('#354291'):HexColor('#969EC8'),
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );

    //List Of Pages
    List pages = <Widget>[
    isDrawerOpen?Stack(children:finalStack(),):

    Stack(
          children:[
            vm9.accessToken==null?DrawerScreen2():DrawerScreen(accessToken: vm9.accessToken,),

    AnimatedPositioned(
    duration: duration,
    top: 0,
    left:isDrawerOpen?deviceWidth*0.50:0,
    right:isDrawerOpen?deviceWidth*-0.45:0,
    bottom: 0,
    // transform: Matrix4.translationValues(xOffset, yOffset, 0)
    //   ..scale(scaleFactor),
    // duration: Duration(milliseconds: 200),
    // decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.all(Radius.circular(isDrawerOpen?60:0))),
    // height: double.infinity,
    // width: double.infinity,
    child: ScaleTransition(
    scale: scaleAnimation,
    child: GestureDetector(
      onTap: (){
        if(isDrawerOpen){
          setState(() {
            isDrawerOpen=false;
            _animationController.reverse();
          });
        }
      },
      child: DashboardScreen(menuCallBack: (){
        setState(() {
          isDrawerOpen=true;
          _animationController.forward();
          print("Heeoollo");
        });
      },isDrawerOpen: isDrawerOpen,accessToken: vm9.accessToken,onTapFeaturedCompany: () {
        _moveTo(2);
        // _paeViewController.animateToPage(2,
        //     duration: const Duration(milliseconds: 400),
        //     curve: Curves.easeInOut);
      }),
    ),
    ),
    )]),
    //   Stack(
    //       children: [
    //         widget.accessToken==null?DrawerScreen2():DrawerScreen(accessToken: widget.accessToken,),
    //         DashboardScreen(accessToken: widget.accessToken,) ]),
      vm9.accessToken==null?SignInDashboardForAppoinmentPrompt("To access your Appointments,"):GetAppointment(),
      HospitalScreen(),
      // isDrawerOpen?Stack(children:finalStack(),):
      // Stack(
      //     children:[
      //       widget.accessToken==null?DrawerScreen2():DrawerScreen(accessToken: widget.accessToken,),
      //
      //       AnimatedPositioned(
      //         duration: duration,
      //         top: 0,
      //         left:isDrawerOpen?deviceWidth*0.50:0,
      //         right:isDrawerOpen?deviceWidth*-0.45:0,
      //         bottom: 0,
      //         // transform: Matrix4.translationValues(xOffset, yOffset, 0)
      //         //   ..scale(scaleFactor),
      //         // duration: Duration(milliseconds: 200),
      //         // decoration: BoxDecoration(
      //         //     color: Colors.white,
      //         //     borderRadius: BorderRadius.all(Radius.circular(isDrawerOpen?60:0))),
      //         // height: double.infinity,
      //         // width: double.infinity,
      //         child: ScaleTransition(
      //           scale: scaleAnimation,
      //           child: GestureDetector(
      //             onTap: (){
      //               if(isDrawerOpen){
      //                 setState(() {
      //                   isDrawerOpen=false;
      //                   _animationController.reverse();
      //                 });
      //               }
      //             },
      //             child: widget.accessToken==null?SignInForPP():PrescriptionListScreen(menuCallBack: (){
      //               setState(() {
      //                 isDrawerOpen=true;
      //                 _animationController.forward();
      //                 print("Heeoollo");
      //               });
      //             },isDrawerOpen: isDrawerOpen,accessToken: widget.accessToken,),
      //           ),
      //         ),
      //       )]),

      vm9.accessToken==null?SignInDashboardForPatientPrompt("To access your Patient Portal,"):PrescriptionListScreen(accessToken: vm9.accessToken,),

    ];

    //BottomNavBar
    var bottomNavBar=BottomNavigationBar(
        onTap: (int index){
          if(currentIndex !=index)
            {
              _moveTo(index);
            }
        },
        currentIndex: currentIndex,
        selectedItemColor: HexColor('#8592E5'),
        unselectedItemColor: Colors.grey[800],
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
        unselectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        elevation: 20.0,
        type: BottomNavigationBarType.fixed,
        items: [
      //dashboard
      BottomNavigationBarItem(
          icon: Material(
        color: Colors.transparent,
        child:dashboardicon,

      // ignore: deprecated_member_use
      ),title: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Text(StringResources.dashboardNavBarText),
      )),
      //appointments
      // ignore: deprecated_member_use
      BottomNavigationBarItem(
          icon: Material(
        color: Colors.transparent,
        child:appointmenticon,

        // ignore: deprecated_member_use
      ),title: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Text(StringResources.appointmentNavBarText),
      )),
      //hospitals
      // ignore: deprecated_member_use
      BottomNavigationBarItem(
          icon:  Material(
        color: Colors.transparent,
        child:hospitalicon,

        // ignore: deprecated_member_use
      ),title: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Text(StringResources.hospitalNavBarText),
      )),
      //my_health
      // ignore: deprecated_member_use
      BottomNavigationBarItem(
          icon: Material(
        color: Colors.transparent,
        child:myhealthicon,

        // ignore: deprecated_member_use
      ),title: Padding(
        padding: const EdgeInsets.only(top:8.0),
        child: Text(StringResources.myHealthNavBarText),
      ))
    ]);

    return MaterialApp(
      title: "MyHealthBD",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: HexColor('#354291'),
        unselectedWidgetColor: HexColor('#8592E5'),
      ),
      home: WillPopScope(child: Scaffold(
         bottomNavigationBar: bottomNavBar,
        body: pages[currentIndex],
      ), onWillPop: () async {
        if (currentIndex == 0)
          return true;
        else {
          _moveTo(0);
          return false;
        }
      }),
    );
  }
}
