import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/after_sign_in.dart';
import 'package:myhealthbd_app/features/auth/sign_up_screen.dart';
import 'package:myhealthbd_app/features/my_health/view/my_health_screen.dart';
import 'package:myhealthbd_app/main_app/resource/const.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/views/widgets/SignUpField.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_text_field_rounded.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool value = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    print(height);
    var spaceBetween = SizedBox(
      height: height >= 600 ? 15.0 : 10.0,
    );
    var userName = SignUpField(
      contentPadding: EdgeInsets.all(15),
      hintText: StringResources.usernameHint,
    );
    var password = SignUpField(
        contentPadding: EdgeInsets.all(15),
        hintText: StringResources.passwordHint,
    );
    var rememberMe = Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                  activeColor: HexColor('#141D53'),
                  key: Key('checkBoxKey'),
                  value: this.value,
                  onChanged: (bool value) {
                    setState(() {
                      this.value = value;
                    });
                  }),
              Text(
                StringResources.rememberMe,
                style:  GoogleFonts.poppins(
                  color: HexColor('#141D53'),
                ),
              )
            ],
          ),
          Text(
            StringResources.forgetPassword,
            style:  GoogleFonts.poppins(
              color: HexColor('#141D53'),
            ),
          )
        ],
      ),
    );
    var signInButton = Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: HexColor('#141D53'),
        child: SizedBox(
          height: height >= 600 ? 50 : 40,
          width: MediaQuery.of(context).size.width / .2,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                StringResources.signInButton,
                style:  GoogleFonts.poppins(fontSize: 18, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
    var socialSignIn = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          StringResources.signInWith,
          style:  GoogleFonts.poppins(
              fontWeight: FontWeight.w300, color: HexColor("#8592E5")),
        ),
        SizedBox(
          width: 8,
        ),
        Container(
          height: 30,
          width: 30,
          child: Image.asset(facebookIcon),
        ),
        SizedBox(
          width:5,
        ),
        Text(StringResources.or,
            style:  GoogleFonts.poppins(
                color: HexColor("#8592E5"), fontWeight: FontWeight.w300)),
        SizedBox(
          width: 5,
        ),
        Container(
          height: 32,
          width: 32,
          child: Image.asset(
            googleIcon,
          ),
        ),
      ],
    );
    var signUp = GestureDetector(
        onTap: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => SignUp()));
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(StringResources.dontHaveAccount,
                style:  GoogleFonts.poppins(
                    color: HexColor("#8592E5"), fontWeight: FontWeight.w300)),
            Text(
              StringResources.signUpText,
              style:  GoogleFonts.poppins(
                  color: HexColor("#141D53"), fontWeight: FontWeight.bold),
            )
          ],
        ));
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor("#F1F9FF"),
      body: Stack(children: <Widget>[
        this._backgroundImage(),
        Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.transparent,
          body: Padding(
            padding: height >= 600
                ? EdgeInsets.only(top: 360.0)
                : EdgeInsets.only(top: 160),
            child: new Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: HexColor("#FFFFFF"),
                  boxShadow: [
                    BoxShadow(

                      color: HexColor("#0D1231").withOpacity(0.08),
                      spreadRadius:10,
                      blurRadius: 7,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(right:25, left: 15),
                child: Column(
                  children: [
                    spaceBetween,
                    SizedBox(height: 5,),
                    Center(
                        child: Text(
                      StringResources.welcomeBack,
                      style:  GoogleFonts.poppins(
                        color: HexColor("#0D1231"),
                        fontSize: 20.0,
                      ),
                    )),
                   // spaceBetween,
                    userName,
                    password,
                    rememberMe,
                    spaceBetween,
                    GestureDetector(
                        onTap: (){

                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => AfterSignIn()));
                        },
                        child: signInButton),
                    spaceBetween,
                    socialSignIn,
                    spaceBetween,
                    signUp
                  ],
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }

  Widget _backgroundImage() {
    return Stack(
      children: [
        Container(
          height: 350.0,
          width: MediaQuery.of(context).size.width,
          child: FadeInImage(
            fit: BoxFit.cover,
            image: AssetImage("assets/images/background_signin_1.png"),
            placeholder: AssetImage(''),
          ),
        ),
        Positioned(
          child: Container(
            alignment: Alignment(0, -0.75),
            child: FadeInImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/myhealth.png"),
              placeholder: AssetImage(''),
            ),
          ),
        )
      ],
    );
  }
}
