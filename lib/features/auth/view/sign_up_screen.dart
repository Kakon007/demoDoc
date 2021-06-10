import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:myhealthbd_app/features/auth/view_model/sign_up_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:myhealthbd_app/main_app/util/validator.dart';
import 'package:myhealthbd_app/main_app/views/widgets/SignUpField.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String _dropDownValue;
  List<String> selectedList;
  String selectedDuration;
  String abc = "#EAEBED";
  DateTime pickedDate;
  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _address = TextEditingController();
  BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(25), topRight: Radius.circular(25));

// Option 2
  String _selectedGender;
  final _formKey = GlobalKey<FormState>();

  Future<Null> selectDate(BuildContext context) async {
    final DateTime date = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppTheme.appbarPrimary,
            accentColor: AppTheme.appbarPrimary,
            colorScheme: ColorScheme.light(primary: AppTheme.appbarPrimary),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child,
        );
      },
      initialDate: DateTime(2003),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null && date != pickedDate) {
      setState(() {
        pickedDate = date;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pickedDate = DateTime(2003);
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var vm = Provider.of<SignUpViewModel>(context, listen: true);
    selectedList = StringResources.genderList;
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width * 0.44;
    var spaceBetween = SizedBox(
      height: height >= 600 ? 10.0 : 5.0,
    );
    print(pickedDate);
    var name = SignUpFormField(
      topPadding: isTablet? 30 : 18,
      controller: _name,
      validator: Validator().nullFieldValidate,
      margin: EdgeInsets.all(2),
      labelText: "Name",
      isRequired: true,
      labelFontSize: isTablet? 15 : 12 ,
      hintSize:isTablet? 17 : 14  ,
      hintText: StringResources.name,
    );
    var email = SignUpFormField(
      topPadding: isTablet? 30 : 25,
      controller: _email,
      validator: Validator().validateEmail,
      hintSize:isTablet? 17 : 14  ,
      margin: EdgeInsets.only(bottom: 2),
      labelFontSize: isTablet? 15 : 12 ,
      isRequired: true,
      labelText: "Email",
      hintText: StringResources.email,
    );
    var mobile = SignUpFormField(
      topPadding: isTablet? 30 : 25,
      controller: _mobile,
      validator: Validator().validatePhoneNumber,
      labelFontSize: isTablet? 15 : 12 ,
      hintSize:isTablet? 17 : 14  ,
      margin: EdgeInsets.only(bottom: 2),
      isRequired: true,
      labelText: "Mobile",
      hintText: StringResources.mobileNumber,
    );
    var password = SignUpFormField(
      margin: EdgeInsets.only(bottom: 2),
      isRequired: true,
      labelText: "Password",
      hintText: StringResources.password,
    );
    var confirmPassword = SignUpFormField(
      margin: EdgeInsets.only(bottom: 2),
      isRequired: true,
      labelText: "Confirm Password",
      hintText: StringResources.confirmPassword,
    );
    var address = SignUpFormField(
      topPadding: isTablet? 30 : 25,
      controller: _address,
      validator: Validator().nullFieldValidate,
      labelFontSize: isTablet? 15 : 12 ,
      hintSize:isTablet? 17 : 14  ,
      margin: EdgeInsets.only(bottom: 2),
      isRequired: true,
      labelText: "Address",
      hintText: StringResources.address,
    );
    String _formatDate = DateFormat("dd/MM/yyyy").format(pickedDate);
    String _formatDate2 = DateFormat("yyyy-MM-dd").format(pickedDate);
    var date = Row(
      children: [
        GestureDetector(
          child: Column(
            children: [
              Container(
                  height: 20.0,
                  width: width,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Text(StringResources.dateOfBirth,
                            style: GoogleFonts.roboto(fontSize: isTablet? 15 : 12)),
                        Text(
                          " *",
                          style: GoogleFonts.roboto(fontSize: isTablet? 15 : 12 ,color: HexColor("#FF5B71")),
                        )
                      ],
                    ),
                  )),
              Container(
                height: isTablet? 50 : 45.0,
                width: width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: HexColor(abc)),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Text(
                        pickedDate == DateTime.now()
                            ? "Date of birth"
                            : "$_formatDate",
                        style: TextStyle(fontSize :isTablet? 17 : 14  ,),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                          height: 18,
                          child:
                              Image.asset("assets/images/calender_icon.png")),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            selectDate(context);
          },
        ),
      ],
    );
    var gender = Row(
      children: [
        Column(
          children: [
            Container(
                height: 20.0,
                width: width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Text(StringResources.gender,
                          style: GoogleFonts.roboto(fontSize: isTablet? 15 : 12)),
                      Text(
                        " *",
                        style: GoogleFonts.roboto(fontSize: isTablet? 15 : 12,color: HexColor("#FF5B71")),
                      )
                    ],
                  ),
                )),
            Container(
              height: isTablet? 50 : 45.0,
              width: width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: HexColor(abc)),
                  borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.0),
                    child: Container(
                      width: width*.88,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          icon: Icon(Icons.keyboard_arrow_down_sharp,color: _selectedGender != null  ?  Colors.black54: HexColor("#D2D2D2"),),
                          iconSize:25,
                          decoration:
                              InputDecoration(
                                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                                  enabledBorder: InputBorder.none),
                          isExpanded: true,
                          hint: Text(
                            StringResources.gender,
                            style: GoogleFonts.roboto(
                                fontSize: isTablet? 17 : 15, color: HexColor("#D2D2D2")),
                          ),
                          value: _selectedGender,
                          onChanged: (newValue) {
                            setState(() {
                              _selectedGender = newValue;
                            });
                          },
                          items: StringResources.genderList.map((gender) {
                            return DropdownMenuItem(
                              child: new Text(
                                gender,
                                style: GoogleFonts.roboto(fontSize: 14),
                              ),
                              value: gender,
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
    var signUpButton = GestureDetector(
      onTap: () async {
        //signUp(_name.text,_email.text, _mobile.text, _address.text, _selectedGender,_formatDate2);
        //showAlert(context);
        if (_formKey.currentState.validate()) {
          print("shaki" + _address.text + "shaki");
          await vm.getSignUpInfo(_name.text, _email.text, _mobile.text,
              _address.text, _selectedGender, _formatDate2);
          if (vm.message == "Saved Successfully") {
            Navigator.pop(context);
            showAlert(context);
          }
        }
      },
      child: Material(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        color: AppTheme.signInSignUpColor,
        child: SizedBox(
          height: height >= 600 ? 50 : 40,
          width: MediaQuery.of(context).size.width / .2,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                StringResources.signUpButton,
                style: TextStyle(
                    fontSize:isTablet? 20 :  height >= 600 ? 18 : 15, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
    var signIn = Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(StringResources.alreadyHaveAnAccount,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 13,
                    color: AppTheme.signInSignUpColor,
                    fontWeight: FontWeight.w300)),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Text(
                StringResources.signInText,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 13,
                    color: AppTheme.signInSignUpColor,
                    fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ],
    );
    var termsPolicy = Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 8,
        ),
        Text(
          StringResources.agreeToTerms,
          style: GoogleFonts.roboto(color: HexColor("#8592E5"), fontSize: isTablet ? 16 : 14),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              StringResources.terms,
              style: GoogleFonts.roboto(
                  color: AppTheme.signInSignUpColor,
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 16 : 13),
            ),
            Text(
              " and  ",
              style:
                  GoogleFonts.roboto(color: HexColor("#8592E5"), fontSize: isTablet ? 16 : 13),
            ),
            Text(
              StringResources.policy,
              style: GoogleFonts.roboto(
                  color: AppTheme.signInSignUpColor,
                  fontWeight: FontWeight.bold,
                  fontSize: isTablet ? 16 : 13),
            ),
          ],
        )
      ],
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor("#F1F9FF"),
      body: Stack(children: <Widget>[
        this._backgroundImage(),
        Scaffold(
          appBar: new AppBar(
            leading: BackButton(color: Colors.black),
            backgroundColor: Colors.transparent,
            elevation: 0.0,
          ),
          //resizeToAvoidBottomInset: false,
          resizeToAvoidBottomInset: true,
          backgroundColor: Colors.transparent,
          body: Form(
            key: _formKey,
            child: Padding(
              padding:
                  EdgeInsets.only(top: MediaQuery.of(context).size.width * .04),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25)),
                          color: HexColor("#FFFFFF"),
                          boxShadow: [
                            BoxShadow(
                              color: HexColor("#0D1231").withOpacity(0.08),
                              spreadRadius: 10,
                              blurRadius: 7,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding:  EdgeInsets.only(right: isTablet? 35 : 15.0, left: isTablet? 35 : 15),
                          child: Column(
                            children: [
                              spaceBetween,
                              Center(
                                  child: Text(
                                StringResources.createAccount,
                                style: TextStyle(
                                    color: HexColor("#0D1231"),
                                    fontSize: isTablet? 25 : 20.0,
                                    fontWeight: FontWeight.w500),
                              )),
                              spaceBetween,
                              name,
                              email,
                              mobile,
                              //password,
                              //confirmPassword,
                              address,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  gender,
                                  date,
                                ],
                              ),
                              spaceBetween,
                              Column(
                                children: [
                                  spaceBetween,
                                  spaceBetween,
                                  spaceBetween,
                                  vm.isLoading == true
                                      ? Center(
                                          child: CircularProgressIndicator())
                                      : signUpButton,
                                  spaceBetween,
                                  signIn,
                                  spaceBetween,
                                  termsPolicy
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Container(
                  //   decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  //     BoxShadow(
                  //       color: HexColor("#0D1231").withOpacity(0.08),
                  //       spreadRadius: 10,
                  //       blurRadius: 7,
                  //       offset: Offset(0, 3), // changes position of shadow
                  //     ),
                  //   ]),
                  //   height: height >= 600 ? 200 : 150,
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(right: 15.0, left: 15),
                  //     child: Column(
                  //       children: [
                  //         spaceBetween,
                  //         spaceBetween,
                  //         spaceBetween,
                  //         vm.isLoading==true ? Center(child: CircularProgressIndicator()) : signUpButton,
                  //         spaceBetween,
                  //         signIn,
                  //         spaceBetween,
                  //         termsPolicy
                  //       ],
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }

  Widget _backgroundImage() {
    bool isTablet = Responsive.isTablet(context);
    return Stack(
      children: [
        Positioned(
          top: isTablet
              ? 35
              : MediaQuery.of(context).size.width * .12,
          left: MediaQuery.of(context).size.width * .32,
          right: MediaQuery.of(context).size.width * .32,
          child: Container(
            height: MediaQuery.of(context).size.width * .13,
            alignment: Alignment(0, -0.75),
            child: FadeInImage(
              fit: BoxFit.fitHeight,
              image: AssetImage("assets/images/myhealth.png"),
              placeholder: AssetImage(''),
            ),
          ),
        )
      ],
    );
  }

  void showAlert(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var vm = Provider.of<SignUpViewModel>(context, listen: false);
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
                height: 180,
                width:  isTablet? MediaQuery.of(context).size.width*.7 : 250,
                // child: SizedBox.expand(child: FlutterLogo()),
                //margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
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
                  //borderRadius: 10,
                ),
                child: Padding(
                  padding:  EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding:  EdgeInsets.only(top: isTablet? 25 : 0),
                        child: Text(
                          vm.message,
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "Username : ",
                      //       style: GoogleFonts.poppins(
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //     Text(
                      //       vm.username,
                      //       style: GoogleFonts.poppins(),
                      //     )
                      //   ],
                      // ),
                      // SizedBox(
                      //   height: 5,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "Password: ",
                      //       style: GoogleFonts.poppins(
                      //           fontWeight: FontWeight.w500),
                      //     ),
                      //     Text(
                      //       vm.password,
                      //       style: GoogleFonts.poppins(),
                      //     )
                      //   ],
                      // ),
                      Text("An sms has been sent to your mobile number with your username and password.", textAlign: TextAlign.center,style: GoogleFonts.poppins(fontWeight: FontWeight.w600),),
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
                  ),
                )),
          ),
        );
      },
    );
  }
}
