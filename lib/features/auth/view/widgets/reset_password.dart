import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/auth/view_model/reset_password_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:myhealthbd_app/main_app/util/validator.dart';
import 'package:myhealthbd_app/main_app/views/widgets/SignUpField.dart';
import 'package:provider/provider.dart';

class ResetPasswordAlert extends StatefulWidget {
  String userName;

  ResetPasswordAlert({this.userName});

  @override
  _ResetPasswordAlertState createState() => _ResetPasswordAlertState();
}

class _ResetPasswordAlertState extends State<ResetPasswordAlert> {
  final _email = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  bool isExpanded = false;
  bool isCurrentObSecure;
  bool isNewObSecure;
  bool isConfirmObSecure;
  bool isValidCredential = true;

  @override
  void initState() {
    // TODO: implement initState
    isCurrentObSecure = true;
    isNewObSecure = true;
    isConfirmObSecure = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<ResetPasswordViewModel>(context, listen: true);
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var width = MediaQuery.of(context).size.width * 0.44;
    var username = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Container(
            child: Text(
              "Username",
              style: TextStyle(
                fontSize: isTablet ? 15 : 12,
              ),
            ),
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          height: 50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: HexColor("#EAEBED")),
              borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              widget.userName,
              style: GoogleFonts.poppins(),
            ),
          ),
        )
      ],
    );
    var email = SignUpFormField(
      topPadding: isTablet ? 25 : 18,
      controller: _email,
      labelFontSize: isTablet ? 15 : 12,
      hintSize: isTablet ? 18 : 15,
      margin: EdgeInsets.only(bottom: 2),
      validator: Validator().validateEmail,
      isRequired: true,
      labelText: "Email",
      hintText: "Email",
    );
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
          horizontal:
              isTablet ? width * .4 : MediaQuery.of(context).size.width * .08),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      content: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: !isExpanded
                ? isTablet
                    ? 280
                    : 255
                : isValidCredential
                    ? isTablet
                        ? 300
                        : 275
                    : isTablet
                        ? 290
                        : 265,
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 25.0, right: 25, bottom: 0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        decoration: new BoxDecoration(),
                        child: new Text(
                          'Reset Password',
                          style: GoogleFonts.poppins(
                              color: AppTheme.appbarPrimary,
                              fontSize: isTablet ? 18 : 15.0,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: isTablet ? 10 : 10,
                  ),
                  username,
                  SizedBox(
                    height: isTablet ? 10 : 10,
                  ),
                  email,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: isTablet
                            ? 200
                            : width <= 360
                                ? width * .7
                                : width * .8,
                        height: isTablet ? 50 : width * .25,
                        child: FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          textColor: AppTheme.appbarPrimary,
                          color: HexColor("#FFFFFF"),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: BorderSide(
                                  color: AppTheme.appbarPrimary, width: 1)),
                          child: Text(
                            StringResources.cancelText,
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      SizedBox(
                        width: isTablet
                            ? 200
                            : width <= 360
                                ? width * .7
                                : width * .8,
                        height: isTablet ? 50 : width * .25,
                        child: FlatButton(
                          textColor: Colors.white,
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                isExpanded = false;
                              });
                              await vm.getResetInfo(
                                  widget.userName, _email.text);
                              isExpanded = false;
                              if (vm.resetInfo == "Saved Successfully") {
                                Navigator.pop(context);
                                _successAlert(context);
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Invalid username or email",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                isValidCredential = false;
                              }
                            } else {
                              setState(() {
                                isExpanded = true;
                              });
                            }
                          },
                          color: AppTheme.appbarPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "Reset",
                            style: GoogleFonts.poppins(),
                          ),
                        ),
                      )

                      // submitButton
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _successAlert(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return Align(
          alignment: Alignment.center,
          child: Material(
            type: MaterialType.transparency,
            child: Container(
                height: 150,
                width: isTablet
                    ? MediaQuery.of(context).size.width * .7
                    : MediaQuery.of(context).size.width <= 330
                        ? 250
                        : 290,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  gradient: LinearGradient(begin: Alignment.topRight,
                      // end: Alignment.topCenter,
                      stops: [
                        0.2,
                        0.5,
                      ], colors: [
                    HexColor("#D6DCFF"),
                    HexColor("#FFFFFF"),
                  ]),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "An email has been sent to your email address with your password.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            minWidth: 120,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                            color: AppTheme.appbarPrimary,
                            child: Text(
                              "OK",
                              style: GoogleFonts.poppins(color: Colors.white),
                            ))
                      ],
                    )
                  ],
                )),
          ),
        );
      },
    );
  }
}
