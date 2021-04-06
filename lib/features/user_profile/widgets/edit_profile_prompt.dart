import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/views/widgets/SignUpField.dart';
class EditProfileAlert extends StatefulWidget {
  @override
  _EditProfileAlertState createState() => _EditProfileAlertState();
}

class _EditProfileAlertState extends State<EditProfileAlert> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width * 0.44;
    var name = Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: new ThemeData(
            primaryColor: Colors.grey,
            //primaryColorDark: Colors.grey,
          ),
          child: Container(
            margin:  EdgeInsets.only(top: 8,bottom: 8,right: 3,left: 3),
            height: 50,
            child: TextField(
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.0),
                    borderRadius: BorderRadius.circular(10)
                ),
                  border: new OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                      //borderSide: new BorderSide(color: Colors.teal.withOpacity(0.3))
                  ),
                  labelText: 'Name *',
                 ),
            ),
          ),
        )
    );
    var email = Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: new ThemeData(
            primaryColor: Colors.grey,
            //primaryColorDark: Colors.grey,
          ),
          child: Container(
            margin:  EdgeInsets.only(top: 8,bottom: 8,right: 3,left: 3),
            height: 50,
            child: TextField(
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.0),
                    borderRadius: BorderRadius.circular(10)
                ),
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  //borderSide: new BorderSide(color: Colors.teal.withOpacity(0.3))
                ),
                labelText: 'Email *',
              ),
            ),
          ),
        )
    );
    var mobile = Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: new ThemeData(
            primaryColor: Colors.grey,
            //primaryColorDark: Colors.grey,
          ),
          child: Container(
            margin:  EdgeInsets.only(top: 8,bottom: 8,right: 3,left: 3),
            height: 50,
            child: TextField(
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.0),
                    borderRadius: BorderRadius.circular(10)
                ),
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  //borderSide: new BorderSide(color: Colors.teal.withOpacity(0.3))
                ),
                labelText: 'Mobile *',
              ),
            ),
          ),
        )
    );
    var address = Directionality(
        textDirection: TextDirection.ltr,
        child: Theme(
          data: new ThemeData(
            primaryColor: Colors.grey.withOpacity(0.1),
            //primaryColorDark: Colors.grey,
          ),
          child: Container(
            margin:  EdgeInsets.only(top: 8,bottom: 8,right: 3,left: 3),
            height: 50,
            child: TextField(
              decoration: new InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.0),
                    borderRadius: BorderRadius.circular(10)
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey.withOpacity(0.2), width: 1.0),
                    borderRadius: BorderRadius.circular(10)
                ),
                border: new OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  //borderSide: new BorderSide(color: Colors.teal.withOpacity(0.3))
                ),
                labelText: 'Address *',
              ),
            ),
          ),
        )
    );
    // var newPassword = SignUpFormField(
    //   labelText: "New Password",
    //   isRequired: true,
    //   obSecure: true,
    //   controller: _password,
    //   margin: EdgeInsets.only(top: 8,bottom: 8,right: 3,left: 3),
    //   contentPadding: EdgeInsets.all(15),
    //   hintText: 'Confirm Password',
    // );
    // var confirmPassword = SignUpFormField(
    //   labelText: "Confirm Password",
    //   isRequired: true,
    //   obSecure: true,
    //   controller: _confirmPassword,
    //   margin: EdgeInsets.only(top: 8,bottom: 8,right: 3,left: 3),
    //   contentPadding: EdgeInsets.all(15),
    //   hintText: 'Confirm Password',
    // );
    return Center(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              padding:  EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              constraints: BoxConstraints(maxWidth: 400, maxHeight: width*2.5),
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Column(
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    // mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0,right: 25, bottom: 15),
                          child: Row(
                            children: <Widget>[
                              Container(
                                // padding: new EdgeInsets.all(10.0),
                                decoration: new BoxDecoration(
                                ),
                                child: new Text(
                                  'Change Password',
                                  style: GoogleFonts.poppins(
                                      color: AppTheme.appbarPrimary,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w500
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0, right: 15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              name,
                              email,
                              mobile,
                              address,
                              Padding(
                                padding: const EdgeInsets.only(left: 22.0, right: 22, top: 22),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: width * .8,
                                      height: width * .25,
                                      child: FlatButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        textColor:  AppTheme.appbarPrimary,
                                        color: HexColor("#FFFFFF"),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(8),
                                            side: BorderSide(
                                                color: AppTheme
                                                    .appbarPrimary,
                                                width: 1)),
                                        child: Text(
                                          StringResources.cancelText,
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width * .8,
                                      height: width * .25,
                                      child: FlatButton(
                                        textColor: Colors.white,
                                        onPressed: () {},
                                        color:  AppTheme.appbarPrimary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          "Save",
                                          style: GoogleFonts.poppins(),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ] ),
                ),
              ),
            ),
          ),
        ));
  }
}