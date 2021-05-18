import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:myhealthbd_app/features/auth/view_model/accessToken_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/views/widgets/SignUpField.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class EditProfileAlert extends StatefulWidget {
  @override
  _EditProfileAlertState createState() => _EditProfileAlertState();
}

class _EditProfileAlertState extends State<EditProfileAlert> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _mobile = TextEditingController();
  final _address = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  DateTime pickBirthDate;
  String abc = "#EAEBED";

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
      initialDate: pickBirthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null && date != pickBirthDate) {
      setState(() {
        pickBirthDate = date;
      });
    }
  }

  String _selectedGender;
  String _selectedBlood;
  String color = "#EAEBED";

  @override
  void initState() {
    var vm = Provider.of<UserDetailsViewModel>(context, listen: false);
    Future.delayed(Duration.zero, () async {
      var vm = Provider.of<UserDetailsViewModel>(context, listen: false);
      vm.getData();
      _username.text = vm.userDetailsList.fname;
      _email.text = vm.userDetailsList.email;
      _mobile.text = vm.userDetailsList.phoneMobile;
      _address.text = vm.userDetailsList.address;
    });
    pickBirthDate = vm.userDetailsList.dob != null
        ? DateFormat("yyyy-MM-dd")
            .parse(vm.userDetailsList.dob)
            .add(Duration(days: 1))
        : pickBirthDate;
    _selectedBlood = vm.userDetailsList.bloodGroup != null
        ? vm.userDetailsList.bloodGroup
        : _selectedBlood;
    _selectedGender = vm.userDetailsList.gender != null
        ? vm.userDetailsList.gender == "M"
            ? "Male"
            : "Female"
        : _selectedBlood;
    // _selectedGender= vm.userDetailsList.gender!=null? vm.userDetailsList.gender : _selectedGender;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String _formatDate = DateFormat("yyyy-MM-dd").format(pickBirthDate);
    var vm = Provider.of<UserDetailsViewModel>(context, listen: true);
    var userId = vm.userDetailsList.id;
    var hospitalNumber = vm.userDetailsList.hospitalNumber;
    var regDate = vm.userDetailsList.regDate;
    var width = MediaQuery.of(context).size.width * 0.44;
    var name = SignUpFormField(
      labelText: "Name",
      isRequired: true,
      controller: _username,
      margin: EdgeInsets.only(
        top: 2,
      ),
      contentPadding: EdgeInsets.all(15),
      hintText: 'Name',
    );
    var email = SignUpFormField(
      labelText: "Email",
      isRequired: true,
      controller: _email,
      margin: EdgeInsets.only(top: 2),
      contentPadding: EdgeInsets.all(15),
      hintText: 'Email',
    );
    var mobile = SignUpFormField(
      labelText: "Mobile",
      isRequired: true,
      controller: _mobile,
      margin: EdgeInsets.only(top: 2),
      contentPadding: EdgeInsets.all(15),
      hintText: 'Mobile',
    );
    var address = SignUpFormField(
      labelText: "Address",
      isRequired: true,
      controller: _address,
      margin: EdgeInsets.only(top: 2),
      contentPadding: EdgeInsets.all(15),
      hintText: 'Address',
    );

    var gender = Row(
      children: [
        GestureDetector(
          child: Column(
            children: [
              Container(
                  height: 35.0,
                  width: MediaQuery.of(context).size.width * .4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Text(StringResources.gender,
                            style: GoogleFonts.roboto(fontSize: 12)),
                        Text(
                          " *",
                          style: GoogleFonts.roboto(color: HexColor("#FF5B71")),
                        )
                      ],
                    ),
                  )),
              Container(
                height: 45.0,
                width: 162,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: HexColor(color)),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Container(
                            width: 145,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                iconSize: 0.0,
                                hint: Text(
                                  StringResources.gender,
                                  style: GoogleFonts.roboto(
                                      fontSize: 15, color: HexColor("#D2D2D2")),
                                ),
                                // Not necessary for Option 1
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 120.0, top: 5),
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: HexColor("#D2D2D2"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );

    var bloodGroup = Row(
      children: [
        GestureDetector(
          child: Column(
            children: [
              Container(
                  height: 35.0,
                  width: MediaQuery.of(context).size.width * .4,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Row(
                      children: [
                        Text(StringResources.bloodGroup,
                            style: GoogleFonts.roboto(fontSize: 12)),
                      ],
                    ),
                  )),
              Container(
                height: 45.0,
                width: 162,
                decoration: BoxDecoration(
                    color: Colors.transparent,
                    border: Border.all(color: HexColor(color)),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Container(
                            width: 145,
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                iconSize: 0.0,
                                hint: Text(
                                  'Blood Group',
                                  style: GoogleFonts.roboto(
                                      fontSize: 15, color: HexColor("#D2D2D2")),
                                ),
                                // Not necessary for Option 1
                                value: _selectedBlood,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedBlood = newValue;
                                  });
                                },
                                items: StringResources.bloodGroupList
                                    .map((gender) {
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
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 120.0, top: 5),
                          child: Icon(
                            Icons.keyboard_arrow_down_sharp,
                            color: HexColor("#D2D2D2"),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
    //String formatBirthDate = DateFormat("dd/MM/yyyy").format(pickBirthDate);
    var dateOfBirth = Row(
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
                            style: GoogleFonts.roboto(fontSize: 12)),
                        Text(
                          " *",
                          style: GoogleFonts.roboto(color: HexColor("#FF5B71")),
                        )
                      ],
                    ),
                  )),
              Container(
                height: 45.0,
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
                        pickBirthDate == DateTime.now()
                            ? "Date of birth"
                            : "$_formatDate",
                        style: TextStyle(fontSize: 13.0),
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
    return Center(
        child: SingleChildScrollView(
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          constraints: BoxConstraints(maxWidth: 400, maxHeight: 650),
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
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, bottom: 15),
                      child: Row(
                        children: <Widget>[
                          Container(
                            // padding: new EdgeInsets.all(10.0),
                            child: new Text(
                              'Edit Personal Info',
                              style: GoogleFonts.poppins(
                                  color: AppTheme.appbarPrimary,
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500),
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
                          dateOfBirth,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              gender,
                              bloodGroup,
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 2.0, top: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: width * .9,
                                  height: width * .25,
                                  child: FlatButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    textColor: AppTheme.appbarPrimary,
                                    color: HexColor("#FFFFFF"),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        side: BorderSide(
                                            color: AppTheme.appbarPrimary,
                                            width: 1)),
                                    child: Text(
                                      StringResources.cancelText,
                                      style: GoogleFonts.poppins(),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width * .9,
                                  height: width * .25,
                                  child: FlatButton(
                                    textColor: Colors.white,
                                    onPressed: () {
                                      vm.updateProfile(
                                          userId.toString(),
                                          _username.text,
                                          _email.text,
                                          _mobile.text,
                                          _address.text,
                                          _formatDate,
                                          _selectedGender,
                                          _selectedBlood,
                                          hospitalNumber,
                                          regDate);
                                      Fluttertoast.showToast(
                                          msg: "Profile updated successfully!",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          backgroundColor: Colors.green,
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                      Navigator.pop(context);
                                    },
                                    color: AppTheme.appbarPrimary,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      "Submit",
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
                  ]),
            ),
          ),
        ),
      ),
    ));
  }
}
