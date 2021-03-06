import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/auth/view/sign_in_screen.dart';
import 'package:myhealthbd_app/features/constant.dart';

class SignInPrompt extends StatefulWidget {
  String title;
  String appBarName;
  SignInPrompt(this.title,this.appBarName);
  @override
  _SignInPromptState createState() => _SignInPromptState();
}

class _SignInPromptState extends State<SignInPrompt> {

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(25.0),
    topRight: Radius.circular(25.0),
  );




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
    return Scaffold(
      backgroundColor: Colors.grey,
        appBar: AppBar(
          //title: Text('Appointments'),
          backgroundColor: HexColor('#354291'),
          title: Text(widget.appBarName,style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500),),
        ),
        body:Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.bottomCenter,
                child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                    height: 180,
                    // child: SizedBox.expand(child: FlutterLogo()),
                    //margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
                    decoration: BoxDecoration(
                      //color: HexColor('#f9f2f3'),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [HexColor('#fdf0f2'), HexColor('#FFFFFF')],
                          tileMode: TileMode.repeated,
                        ),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        )),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 50.0),
                      child: Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text:  TextSpan(
                              style:  GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.black,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: widget.title),
                                TextSpan(text: "Sign In Required.", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                                //TextSpan(text: " from your family member list?", style: GoogleFonts.poppins()),
                              ],
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     Text(widget.title,
                          //         style: TextStyle(
                          //             fontSize: 16, color: Colors.black)),
                          //     Text("Sign In Required.",
                          //         style: TextStyle(
                          //             fontSize: 18,
                          //             color: Colors.black,
                          //             fontWeight: FontWeight.w500)),
                          //   ],),
                          SizedBox(
                            height: 20,
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
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(8),
                                      side: BorderSide(
                                          color: HexColor('#354291'))),
                                  color: Colors.white,
                                  child: SizedBox(
                                    height: 50,
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        "Cancel",
                                        style: TextStyle(
                                            color: HexColor('#354291'),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        transitionDuration:
                                        Duration(seconds: 1),
                                        transitionsBuilder: (context,
                                            animation,
                                            secondaryAnimation,
                                            child) {
                                          var begin = Offset(0, 1.0);
                                          var end = Offset.zero;
                                          var curve = Curves.easeInOut;

                                          var tween = Tween(
                                              begin: begin, end: end)
                                              .chain(
                                              CurveTween(curve: curve));

                                          return SlideTransition(
                                            position:
                                            animation.drive(tween),
                                            child: child,
                                          );
                                        },
                                        pageBuilder: (context, animation,
                                            secondaryAnimation) =>
                                            SignIn(isBook: true),
                                      ));
                                },
                                child: Material(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(10)),
                                  color: HexColor('#354291'),
                                  child: SizedBox(
                                    height: 50,
                                    width: 150,
                                    child: Center(
                                      child: Text(
                                        "Continue",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
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
              Positioned(
                bottom: 120,
                //top: MediaQuery.of(context).size.height / 1.8,
                left: 100,
                right: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: Constants.avatarRadius,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Constants.avatarRadius)),
                      child: Image.asset("assets/icons/sign_in_prompt.png", height: 90,width: 90,)),
                ),
              ),
            ],
          ),
        )
    );


  }


}
