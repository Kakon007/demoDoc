import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/auth/view/sign_in_screen.dart';
import 'package:myhealthbd_app/features/auth/view/sign_up_screen.dart';
import 'package:myhealthbd_app/features/constant.dart';
import 'package:myhealthbd_app/main_app/resource/const.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';

class SignInDashboardForPatientPrompt extends StatefulWidget {
  String title;
  SignInDashboardForPatientPrompt(this.title);
  @override
  _SignInDashboardForPatientPromptState createState() => _SignInDashboardForPatientPromptState();
}

class _SignInDashboardForPatientPromptState extends State<SignInDashboardForPatientPrompt> {

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(25.0),
    topRight: Radius.circular(25.0),
  );


  _showAppoinmentPrompt(){
    _showAlert(context);
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();

    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await _showAppoinmentPrompt();
    // });
  }
  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    final Widget appoinIcon = SvgPicture.asset(
      "assets/icons/new_pro.svg",
      width: isTablet ? 70 : 50,
      height: isTablet ? 250 : MediaQuery.of(context).size.height>650 ? 210 : MediaQuery.of(context).size.height<550? 160 :  180,
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );
    return Scaffold(
      appBar: AppBar(
        //title: Text('Appointments'),
        backgroundColor: HexColor('#354291'),
        title: Text('Patient Portal',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500),),
      ),
      body: Center(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 220,
                  height: isTablet ? 90 : MediaQuery.of(context).size.height>600 ? 70 : MediaQuery.of(context).size.height<550? 60 :  70,
                  child: Image.asset(kMyHealthLogo)),
              SizedBox(height: 10,),
              appoinIcon,
              SizedBox(height: MediaQuery.of(context).size.height>600 ? 20 : 10,),
              Text('Want to access your Prescriptions?', key: Key('wantToAccessPresKey'),textAlign: TextAlign.center,style: GoogleFonts.poppins(fontSize: isTablet ? 20 :  MediaQuery.of(context).size.height<=600 ? 13 : 16 ,fontWeight: FontWeight.w500),),
              SizedBox(height:isTablet? 25  : MediaQuery.of(context).size.height>600 ? 20 :10,),
              GestureDetector(
                onTap: (){
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
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8),
                  child: Material(
                    elevation: 0  ,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    color: HexColor("#354291"),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width*.85,
                      height : isTablet ? 60 : MediaQuery.of(context).size.height>600 ? 50 : MediaQuery.of(context).size.height<550? 35 :  40,
                      child: Center(
                        child: Text("Sign In",style:  GoogleFonts.poppins(color: Colors.white,fontSize: isTablet? 18 : 12,fontWeight: FontWeight.w600),),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: isTablet? 25 :  MediaQuery.of(context).size.height>600 ? 20 : 10),
              GestureDetector(   onTap: (){
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
                          SignUp(),
                    ));
              },child: Text("Sign Up",style:  GoogleFonts.poppins(color: HexColor('#8592E5'),fontSize: isTablet? 18  : 12,fontWeight: FontWeight.w600),)),


            ],
          ),
        ),
      ),
    );

  }

  void _showAlert(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Stack(
          children:[
            Align(
              alignment: Alignment.bottomCenter,
              child: Material(
                type: MaterialType.transparency,
                child: Container(
                  height: 200,
                  // child: SizedBox.expand(child: FlutterLogo()),
                  //margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
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
                    borderRadius: radius,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top:70.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(widget.title,style:TextStyle(fontSize: 18,color: Colors.black)),
                          SizedBox(height: 5,),
                          Text("Sign In required.",style:TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w500)),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left:40.0),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap:(){
                                    Navigator.pop(context);
                                  },
                                  child: Material(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),side: BorderSide(color:HexColor('#354291') )),
                                    color: Colors.white,
                                    child: SizedBox(
                                      height: 50,
                                      width: 150,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(color: HexColor('#354291'),fontWeight: FontWeight.w500,fontSize: 15),
                                          ),

                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 15,),
                                GestureDetector(
                                  onTap: (){
                                    Navigator.push(context, PageRouteBuilder(
                                      transitionDuration: Duration(seconds: 1),
                                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                        var begin = Offset(0, 1.0);
                                        var end = Offset.zero;
                                        var curve = Curves.easeInOut;

                                        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                                        return SlideTransition(
                                          position: animation.drive(tween),
                                          child: child,
                                        );
                                      },
                                      pageBuilder: (context, animation, secondaryAnimation) => SignIn(),
                                    ));
                                  },
                                  child: Material(
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                    color: HexColor('#354291'),
                                    child: SizedBox(
                                      height: 50,
                                      width: 150,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "Continue",
                                            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 2), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

}



// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:hexcolor/hexcolor.dart';
// import 'package:myhealthbd_app/features/auth/view/sign_in_screen.dart';
// import 'package:myhealthbd_app/features/auth/view/sign_up_screen.dart';
// import 'package:myhealthbd_app/features/constant.dart';
//
// class SignInDashboardForPatientPrompt extends StatefulWidget {
//   String title;
//   SignInDashboardForPatientPrompt(this.title);
//   @override
//   _SignInDashboardForPatientPromptState createState() => _SignInDashboardForPatientPromptState();
// }
//
// class _SignInDashboardForPatientPromptState extends State<SignInDashboardForPatientPrompt> {
//
//   BorderRadiusGeometry radius = BorderRadius.only(
//     topLeft: Radius.circular(25.0),
//     topRight: Radius.circular(25.0),
//   );
//
//
//   _showAppoinmentPrompt(){
//     _showAlert(context);
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//
//     super.initState();
//
//     // WidgetsBinding.instance.addPostFrameCallback((_) async {
//     //   await _showAppoinmentPrompt();
//     // });
//   }
//   @override
//   Widget build(BuildContext context) {
//
//     final Widget appoinIcon = SvgPicture.asset(
//       "assets/icons/new_pro.svg",
//       //color: Colors.black,
//       width: 50,
//       height:220,
//       fit: BoxFit.fitWidth,
//       allowDrawingOutsideViewBox: true,
//       matchTextDirection: true,
//       //semanticsLabel: 'Acme Logo'
//     );
//     return Scaffold(
//       appBar: AppBar(
//         //title: Text('Appointments'),
//         backgroundColor: HexColor('#354291'),
//         title: Text('Patient Portal',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500),),
//       ),
//       body: Center(
//         child: Container(
//           child: Padding(
//             padding: const EdgeInsets.only(top:70.0),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(right:20.0),
//                   child: Container(
//                       width: 250,
//                       child: Image.asset(
//                           "assets/images/my_health_logo.png")),
//                 ),
//                 SizedBox(height: 10,),
//                 appoinIcon,
//                 SizedBox(height: 20,),
//                 Text('Want to manage your Prescriptions, Reports and \n Documents from anywhere?',textAlign: TextAlign.center,style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500),),
//                 SizedBox(height: 20,),
//                 GestureDetector(
//                   onTap: (){
//                     Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           transitionDuration: Duration(seconds: 1),
//                           transitionsBuilder: (context, animation,
//                               secondaryAnimation, child) {
//                             var begin = Offset(0, 1.0);
//                             var end = Offset.zero;
//                             var curve = Curves.easeInOut;
//
//                             var tween = Tween(
//                                 begin: begin, end: end)
//                                 .chain(CurveTween(curve: curve));
//
//                             return SlideTransition(
//                               position: animation.drive(tween),
//                               child: child,
//                             );
//                           },
//                           pageBuilder: (context, animation,
//                               secondaryAnimation) =>
//                               SignIn(),
//                         ));
//                   },
//                   child: Material(
//                     elevation: 0  ,
//                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//                     color: HexColor("#354291"),
//                     child: SizedBox(
//                       width: 330,
//                       height: 50,
//                       child: Center(
//                         child: Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Text("Sign In",style:  GoogleFonts.poppins(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w600),),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 20,),
//                 GestureDetector(
//                   onTap: (){
//                     Navigator.push(
//                         context,
//                         PageRouteBuilder(
//                           transitionDuration: Duration(seconds: 1),
//                           transitionsBuilder: (context, animation,
//                               secondaryAnimation, child) {
//                             var begin = Offset(0, 1.0);
//                             var end = Offset.zero;
//                             var curve = Curves.easeInOut;
//
//                             var tween = Tween(
//                                 begin: begin, end: end)
//                                 .chain(CurveTween(curve: curve));
//
//                             return SlideTransition(
//                               position: animation.drive(tween),
//                               child: child,
//                             );
//                           },
//                           pageBuilder: (context, animation,
//                               secondaryAnimation) =>
//                               SignUp(),
//                         ));
//                   },
//                     child: Text("Sign Up",style:  GoogleFonts.poppins(color: HexColor('#8592E5'),fontSize: 12,fontWeight: FontWeight.w600),)),
//
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//
//
//   }
//
//   void _showAlert(BuildContext context) {
//     showGeneralDialog(
//       barrierLabel: "Label",
//       barrierDismissible: false,
//       barrierColor: Colors.black.withOpacity(0.5),
//       transitionDuration: Duration(milliseconds: 700),
//       context: context,
//       pageBuilder: (context, anim1, anim2) {
//         return Stack(
//           children:[
//             Align(
//               alignment: Alignment.bottomCenter,
//               child: Material(
//                 type: MaterialType.transparency,
//                 child: Container(
//                   height: 200,
//                   // child: SizedBox.expand(child: FlutterLogo()),
//                   //margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
//                   decoration: BoxDecoration(
//                     //color: HexColor('#f9f2f3'),
//                     gradient: LinearGradient(
//                       begin: Alignment.topCenter,
//                       end: Alignment.bottomCenter,
//                       colors: [
//                         HexColor('#fdf0f2'),
//                         HexColor('#FFFFFF')
//                       ],
//                       tileMode: TileMode.repeated,
//                     ),
//                     borderRadius: radius,
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.only(top:70.0),
//                     child: Center(
//                       child: Column(
//                         children: [
//                           Text(widget.title,style:TextStyle(fontSize: 18,color: Colors.black)),
//                           SizedBox(height: 5,),
//                           Text("Sign In required.",style:TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w500)),
//                           SizedBox(height: 10,),
//                           Padding(
//                             padding: const EdgeInsets.only(left:40.0),
//                             child: Row(
//                               children: [
//                                 GestureDetector(
//                                   onTap:(){
//                                     Navigator.pop(context);
//                                   },
//                                   child: Material(
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),side: BorderSide(color:HexColor('#354291') )),
//                                     color: Colors.white,
//                                     child: SizedBox(
//                                       height: 50,
//                                       width: 150,
//                                       child: Center(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             "Cancel",
//                                             style: TextStyle(color: HexColor('#354291'),fontWeight: FontWeight.w500,fontSize: 15),
//                                           ),
//
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 SizedBox(width: 15,),
//                                 GestureDetector(
//                                   onTap: (){
//                                     Navigator.push(context, PageRouteBuilder(
//                                       transitionDuration: Duration(seconds: 1),
//                                       transitionsBuilder: (context, animation, secondaryAnimation, child) {
//                                         var begin = Offset(0, 1.0);
//                                         var end = Offset.zero;
//                                         var curve = Curves.easeInOut;
//
//                                         var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
//
//                                         return SlideTransition(
//                                           position: animation.drive(tween),
//                                           child: child,
//                                         );
//                                       },
//                                       pageBuilder: (context, animation, secondaryAnimation) => SignIn(),
//                                     ));
//                                   },
//                                   child: Material(
//                                     elevation: 0,
//                                     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                                     color: HexColor('#354291'),
//                                     child: SizedBox(
//                                       height: 50,
//                                       width: 150,
//                                       child: Center(
//                                         child: Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: Text(
//                                             "Continue",
//                                             style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
//                                           ),
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             Positioned(
//               top: MediaQuery.of(context).size.height/1.5,
//               left:100,
//               right:100,
//               child: CircleAvatar(
//                 backgroundColor: Colors.transparent,
//                 radius: Constants.avatarRadius,
//                 child: ClipRRect(
//                     borderRadius: BorderRadius.all(Radius.circular(Constants.avatarRadius)),
//                     child: Image.asset("assets/icons/sign_in_prompt.png")
//                 ),
//               ),
//             ),
//           ],
//         );
//       },
//       transitionBuilder: (context, anim1, anim2, child) {
//         return SlideTransition(
//           position: Tween(begin: Offset(0, 2), end: Offset(0, 0)).animate(anim1),
//           child: child,
//         );
//       },
//     );
//   }
//
// }
