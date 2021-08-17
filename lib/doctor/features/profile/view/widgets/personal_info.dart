import 'package:dashed_container/dashed_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/doctor/features/profile/view/widgets/change_password_prompt.dart';
import 'package:myhealthbd_app/doctor/features/profile/view/widgets/upload_digital_signature.dart';
import 'package:myhealthbd_app/doctor/features/profile/view_model/doctor_profile_view_model.dart';
import 'package:myhealthbd_app/doctor/main_app/views/doctor_form_field.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/const.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:myhealthbd_app/main_app/util/validator.dart';
import 'package:provider/provider.dart';

class PersonalInfo extends StatefulWidget {
  const PersonalInfo({Key key}) : super(key: key);

  @override
  _PersonalInfoState createState() => _PersonalInfoState();
}

class _PersonalInfoState extends State<PersonalInfo> {
  TextEditingController _userMobile = TextEditingController();
  TextEditingController _userEmail = TextEditingController();
  final _formKey = new GlobalKey<FormState>();
  String errorText;
  bool isReadOnly = true;

  @override
  void initState() {
    var companyInfoVm = Provider.of<UserImageViewModel>(context, listen: false);
    _userMobile.text =
        companyInfoVm.details?.userMobile.toString().substring(1);
    _userEmail.text = companyInfoVm.details?.userEmail;
    isReadOnly = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vm = Provider.of<DoctorProfileViewModel>(context, listen: false);
    var companyInfoVm = Provider.of<UserImageViewModel>(context, listen: true);
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var spaceBetween = SizedBox(
      height: 10,
    );
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var nameHeading = Padding(
      padding: const EdgeInsets.only(left: 13.0, bottom: 5, top: 5),
      child: Row(
        children: [
          Text(
            'Name',
            style: GoogleFonts.poppins(fontSize: isTablet ? 14 : 12),
          ),
          Text(
            '*',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
          ),
        ],
      ),
    );
    var doctorName = Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: DoctorFormField(
        enabledBorderColor: isReadOnly ? "#AFBBFF" : "#EAEBED",
        readOnly: isReadOnly,
        validator: Validator().nullFieldValidate,
        minimizeBottomPadding: true,
        hintText: 'Enter Your Name',
      ),
    );

    //     Padding(
    //   padding: const EdgeInsets.only(left: 8.0, right: 8),
    //   child: Container(
    //     height: 50,
    //     width: width,
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //         color: HexColor("#FFFFFF"),
    //         border: Border.all(color: HexColor('#AFBBFF'))
    //         // boxShadow: [
    //         //   BoxShadow(
    //         //     color: HexColor("#0D1231").withOpacity(0.08),
    //         //     spreadRadius: 2,
    //         //     blurRadius: 2,
    //         //     offset: Offset(0, 1), // changes position of shadow
    //         //   ),
    //         // ]
    //         ),
    //     child: Align(
    //       alignment: Alignment.centerLeft,
    //       child: Padding(
    //         padding: const EdgeInsets.only(left: 15.0),
    //         child: Text(
    //           companyInfoVm.isLoading ? '' : companyInfoVm.details?.name ?? '',
    //           style: GoogleFonts.poppins(),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    var designationHeading = Padding(
      padding: const EdgeInsets.only(left: 13.0, bottom: 5, top: 5),
      child: Row(
        children: [
          Text(
            'Designation',
            style: GoogleFonts.poppins(fontSize: isTablet ? 14 : 12),
          ),
          Text(
            '*',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
          ),
        ],
      ),
    );
    var designation =
        // vm.isPersonalInfoEditing?
        Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: DoctorFormField(
        validator: Validator().nullFieldValidate,
        enabledBorderColor: isReadOnly ? "#AFBBFF" : "#EAEBED",
        readOnly: isReadOnly,
        minimizeBottomPadding: true,
        hintText: 'Enter Your Designation',
      ),
    );
    //     :
    //     Padding(
    //   padding: const EdgeInsets.only(left: 8.0, right: 8),
    //   child: Container(
    //     height: 50,
    //     width: width,
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //         color: HexColor("#FFFFFF"),
    //         border: Border.all(color: HexColor('#AFBBFF'))
    //         // boxShadow: [
    //         //   BoxShadow(
    //         //     color: HexColor("#0D1231").withOpacity(0.08),
    //         //     spreadRadius: 2,
    //         //     blurRadius: 2,
    //         //     offset: Offset(0, 1), // changes position of shadow
    //         //   ),
    //         // ]
    //         ),
    //     child: Align(
    //       alignment: Alignment.centerLeft,
    //       child: Padding(
    //         padding: const EdgeInsets.only(left: 15.0),
    //         child: Text(
    //           'MBBS',
    //           style: GoogleFonts.poppins(),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    var specializationHeading = Padding(
      padding: const EdgeInsets.only(left: 13.0, bottom: 5, top: 5),
      child: Row(
        children: [
          Text(
            'Specialization',
            style: GoogleFonts.poppins(fontSize: isTablet ? 14 : 12),
          ),
          Text(
            '*',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
          ),
        ],
      ),
    );
    var specialization =
        // vm.isPersonalInfoEditing?
        Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: DoctorFormField(
        validator: Validator().nullFieldValidate,
        enabledBorderColor: isReadOnly ? "#AFBBFF" : "#EAEBED",
        readOnly: isReadOnly,
        minimizeBottomPadding: true,
        hintText: 'Enter Your specialization',
      ),
    );
    var mobileText = Padding(
      padding: const EdgeInsets.only(left: 13.0, bottom: 5),
      child: Row(
        children: [
          Text(
            'Mobile',
            style: GoogleFonts.poppins(fontSize: isTablet ? 14 : 12),
          ),
          Text(
            vm.isPersonalInfoEditing ? '*' : "",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
          ),
        ],
      ),
    );
    var degreeHeading = Padding(
        padding: const EdgeInsets.only(left: 13.0, bottom: 5, top: 5),
        child: Row(
          children: [
            Text(
              'Degree',
              style: GoogleFonts.poppins(fontSize: isTablet ? 14 : 12),
            ),
            Text(
              '*',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
            ),
          ],
        ));
    var degree =
        //vm.isDoctorInfoEditing ?
        Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: DoctorFormField(
        validator: Validator().nullFieldValidate,
        enabledBorderColor: isReadOnly ? "#AFBBFF" : "#EAEBED",
        readOnly: isReadOnly,
        minimizeBottomPadding: true,
        hintText: 'Enter Degree',
      ),
    );
    //     : Padding(
    //   padding: const EdgeInsets.only(left: 8.0, right: 8),
    //   child: Container(
    //     height: 50,
    //     width: width,
    //     decoration: BoxDecoration(
    //         borderRadius: BorderRadius.circular(10),
    //         color: HexColor("#FFFFFF"),
    //         border: Border.all(color: HexColor('#AFBBFF'))
    //       // boxShadow: [
    //       //   BoxShadow(
    //       //     color: HexColor("#0D1231").withOpacity(0.08),
    //       //     spreadRadius: 2,
    //       //     blurRadius: 2,
    //       //     offset: Offset(0, 1), // changes position of shadow
    //       //   ),
    //       // ]
    //     ),
    //     child: Align(
    //       alignment: Alignment.centerLeft,
    //       child: Padding(
    //         padding: const EdgeInsets.only(left: 15.0),
    //         child: Text(
    //           'BCS(Health), MD(Chest)',
    //           style: GoogleFonts.poppins(),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
    var addMoreButton = Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: SizedBox(
        child: FlatButton(
            minWidth: MediaQuery.of(context).size.width * .1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: AppTheme.buttonActiveColor,
            onPressed: () {},
            child: Row(
              children: [
                Icon(
                  Icons.add,
                  color: Colors.white,
                ),
                //SizedBox(width: 10,),
                Text(
                  'Add More',
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: isTablet ? 18 : 15),
                ),
              ],
            )),
      ),
    );
    var bmdcNoHeading = Padding(
        padding: const EdgeInsets.only(left: 13.0, bottom: 5, top: 5),
        child: Row(
          children: [
            Text(
              'BMDC No',
              style: GoogleFonts.poppins(fontSize: isTablet ? 14 : 12),
            ),
          ],
        ));
    var bmdcNo = Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8),
      child: Container(
        height: 50,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xffF9F9F9),
        ),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Text(
              'A 187',
              style: GoogleFonts.poppins(),
            ),
          ),
        ),
      ),
    );
    var mobileField =
        // vm.isPersonalInfoEditing?
        Column(
      children: [
        Container(
          child: Stack(
            children: [
              DoctorFormField(
                enabledBorderColor: isReadOnly ? "#AFBBFF" : "#EAEBED",
                readOnly: isReadOnly,
                leftContentPadding: 85,
                controller: _userMobile,
                validator: Validator().validateDoctorPhoneNumber,
                hintText: '1310000000',
                minimizeBottomPadding: true,
              ),
              Positioned(
                top: 3,
                left: 6.5,
                child: Container(
                  height: 46,
                  width: 70,
                  child: Center(
                      child: Text(
                    '+880',
                    style: GoogleFonts.poppins(),
                  )),
                  decoration: BoxDecoration(
                      color: HexColor('#E8E8E8'),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8))),
                ),
              )
            ],
          ),
        ),
      ],
    );
    //    :
    // Padding(
    //         padding: const EdgeInsets.only(right: 10, left: 10),
    //         child: Container(
    //           width: width,
    //           height: 50,
    //           decoration: BoxDecoration(
    //               borderRadius: BorderRadius.circular(10),
    //               border: Border.all(
    //                   color: vm.isPersonalInfoEditing
    //                       ? Colors.white
    //                       : HexColor("#AFBBFF"),
    //                   width: 1)),
    //           child: Stack(
    //             children: [
    //               Padding(
    //                 padding: EdgeInsets.only(left: 85.0, right: 10),
    //                 child: Align(
    //                   alignment: Alignment.centerLeft,
    //                   child: Text(
    //                     companyInfoVm.isLoading
    //                         ? ''
    //                         : companyInfoVm.details?.userMobile
    //                                 .toString()
    //                                 .substring(1) ??
    //                             '',
    //                     style: GoogleFonts.poppins(),
    //                   ),
    //                 ),
    //               ),
    //               Positioned(
    //                 top: 0,
    //                 left: 0,
    //                 child: Container(
    //                   height: 48,
    //                   width: 70,
    //                   child: Center(
    //                       child: Text(
    //                     '+880',
    //                     style: GoogleFonts.poppins(),
    //                   )),
    //                   decoration: BoxDecoration(
    //                       color: HexColor('#E8E8E8'),
    //                       borderRadius: BorderRadius.only(
    //                           topLeft: Radius.circular(9),
    //                           bottomLeft: Radius.circular(9))),
    //                 ),
    //               )
    //             ],
    //           ),
    //         ),
    //       );

    // Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     Padding(
    //       padding: const EdgeInsets.only(left: 7.0, right: 5),
    //       child: Container(
    //         width: width,
    //         decoration: BoxDecoration(
    //             borderRadius: BorderRadius.circular(10),
    //             border: Border.all(
    //                 color: errorText != null
    //                     ? Colors.red.shade700
    //                     : vm.isPersonalInfoEditing
    //                         ? Colors.white
    //                         : HexColor("#AFBBFF"),
    //                 width: 1)),
    //         child: Row(
    //           children: [
    //             Container(
    //               height: 50,
    //               width: 70,
    //               child: Center(child: Text('+880')),
    //               decoration: BoxDecoration(
    //                   color: HexColor('#E8E8E8'),
    //                   borderRadius: BorderRadius.only(
    //                       topLeft: Radius.circular(10),
    //                       bottomLeft: Radius.circular(10))),
    //             ),
    //             Container(
    //               width: width <= 330
    //                   ? width * .55
    //                   : MediaQuery.of(context).size.width * .67,
    //               child: vm.isPersonalInfoEditing
    //                   ? TextFormField(
    //                       controller: _userMobile,
    //                       //validator: Validator().validatePhoneNumber,
    //                       decoration: new InputDecoration(
    //                         border: InputBorder.none,
    //                         hintStyle: GoogleFonts.poppins(
    //                             fontSize: 12, color: HexColor("#D2D2D2")),
    //                         focusedBorder: OutlineInputBorder(
    //                           borderSide: BorderSide(
    //                               color: errorText != null
    //                                   ? Colors.white: HexColor("#D6DCFF"), width: 1.0),
    //                           borderRadius: BorderRadius.only(
    //                               bottomRight: Radius.circular(10),
    //                               topRight: Radius.circular(10)),
    //                         ),
    //                         contentPadding:
    //                             EdgeInsets.fromLTRB(15.0, 25, 40.0, 0.0),
    //                         enabledBorder: OutlineInputBorder(
    //                           borderSide: BorderSide(
    //                               color: HexColor("#EAEBED"), width: 1.0),
    //                           borderRadius: BorderRadius.only(
    //                               bottomRight: Radius.circular(10),
    //                               topRight: Radius.circular(10)),
    //                         ),
    //                         focusedErrorBorder: OutlineInputBorder(
    //                           borderSide: BorderSide(
    //                               color: HexColor("#EAEBED"), width: 1.0),
    //                           borderRadius: BorderRadius.only(
    //                               bottomRight: Radius.circular(10),
    //                               topRight: Radius.circular(10)),
    //                         ),
    //                         errorBorder: OutlineInputBorder(
    //                           borderSide:
    //                               BorderSide(color: Colors.red, width: 1.0),
    //                           borderRadius: BorderRadius.only(
    //                               bottomRight: Radius.circular(10),
    //                               topRight: Radius.circular(10)),
    //                         ),
    //                         hintText: '1310000000',
    //                       ),
    //                     )
    //                   : Container(
    //                       child: Padding(
    //                         padding: EdgeInsets.only(left: 15.0, right: 10),
    //                         child: Text(
    //                           companyInfoVm.isLoading
    //                               ? ''
    //                               : companyInfoVm.details?.userMobile
    //                                       .toString()
    //                                       .substring(1) ??
    //                                   '',
    //                           style: GoogleFonts.poppins(fontSize: 15),
    //                         ),
    //                       ),
    //                     ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //     errorText != null
    //         ? Padding(
    //             padding: const EdgeInsets.only(left: 22.0, top: 8),
    //             child: Text(
    //               errorText,
    //               style: TextStyle(color: Colors.red.shade700, fontSize: 12),
    //             ),
    //           )
    //         : SizedBox()
    //   ],
    // );
    var doctorSignatureHeading = Padding(
        padding: const EdgeInsets.only(left: 13.0, bottom: 5, top: 5),
        child: Row(
          children: [
            Text(
              "Doctor's signature",
              style: GoogleFonts.poppins(fontSize: isTablet ? 14 : 12),
            ),
            Text(
              '*',
              style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
            ),
          ],
        ));
    var doctorSignature = Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: DoctorFormField(
        validator: Validator().nullFieldValidate,
        enabledBorderColor: isReadOnly ? "#AFBBFF" : "#EAEBED",
        readOnly: isReadOnly,
        minimizeBottomPadding: true,
        hintText: 'Enter Signature',
        maxLines: 5,
      ),
    );
    var digitalSignatureHeading = Padding(
        padding: const EdgeInsets.only(left: 13.0, bottom: 5, top: 5),
        child: Text(
          "Digital signature",
          style: GoogleFonts.poppins(fontSize: isTablet ? 14 : 12),
        ));
    var digitalSignature = Align(
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          DashedContainer(
            dashColor: HexColor("#E9ECFE"),
            borderRadius: 10.0,
            dashedLength: 10.0,
            blankLength: 2.0,
            child: Container(
              //  constraints: BoxConstraints(maxHeight: 200.0,),
              height: 120.0,
              width: width * .6,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset(
                  uploadImageIcon,
                  height: 60,
                  width: 60,
                  fit: BoxFit.fitHeight,
                ),
              ),
              // child: Icon(Icons.insert_photo_rounded,size: 80,color: Colors.grey.shade200,),
            ),
          ),
          spaceBetween,
          FlatButton(
            minWidth: width * .6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: AppTheme.buttonActiveColor,
            onPressed: () {
              _uploadSignature(context);
            },
            child: Text(
              'Upload Your Signature',
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 18 : 15),
            ),
          ),
          spaceBetween,
        ],
      ),
    );
    var emailHeading = Padding(
      padding: const EdgeInsets.only(left: 13.0, bottom: 5, top: 5),
      child: Row(
        children: [
          Text(
            'Email',
            style: GoogleFonts.poppins(fontSize: isTablet ? 14 : 12),
          ),
          Text(
            '*',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.red),
          ),
        ],
      ),
    );

    var email =
        // vm.isPersonalInfoEditing
        //     ?
        Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4),
      child: DoctorFormField(
        enabledBorderColor: isReadOnly ? "#AFBBFF" : "#EAEBED",
        readOnly: isReadOnly,
        validator: Validator().validateEmail,
        controller: _userEmail,
        minimizeBottomPadding: true,
        hintText: 'Enter Your Email',
      ),
    );
    // : Padding(
    //     padding: const EdgeInsets.only(left: 8.0, right: 8),
    //     child: Container(
    //       height: 50,
    //       width: width,
    //       decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(10),
    //           color: HexColor("#FFFFFF"),
    //           border: Border.all(color: HexColor('#AFBBFF'))
    //           // boxShadow: [
    //           //   BoxShadow(
    //           //     color: HexColor("#0D1231").withOpacity(0.08),
    //           //     spreadRadius: 2,
    //           //     blurRadius: 2,
    //           //     offset: Offset(0, 1), // changes position of shadow
    //           //   ),
    //           // ]
    //           ),
    //       child: Align(
    //         alignment: Alignment.centerLeft,
    //         child: Padding(
    //           padding: const EdgeInsets.only(left: 15.0),
    //           child: Text(
    //             companyInfoVm.isLoading
    //                 ? ''
    //                 : companyInfoVm.details?.userEmail ?? '',
    //             style: GoogleFonts.poppins(),
    //           ),
    //         ),
    //       ),
    //     ),
    //   );
    var editButton = !vm.isPersonalInfoEditing
        ? FlatButton(
            minWidth: MediaQuery.of(context).size.width,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            color: AppTheme.buttonActiveColor,
            onPressed: () {
              setState(() {
                vm.editingPersonalInfo(isPersonalInfoEditing: true);
                isReadOnly = false;
              });
            },
            child: Text(
              'Edit Your Profile',
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: isTablet ? 18 : 15),
            ))
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                  minWidth: MediaQuery.of(context).size.width * .4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: AppTheme.buttonActiveColor,
                  onPressed: () {
                    setState(() {
                      vm.editingPersonalInfo(isPersonalInfoEditing: false);
                      errorText = null;
                      isReadOnly = true;
                    });
                  },
                  child: Text(
                    'Cancel',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 18 : 15),
                  )),
              FlatButton(
                  minWidth: MediaQuery.of(context).size.width * .4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  color: AppTheme.buttonActiveColor,
                  onPressed: () async {
                    // setState(() {
                    //   errorText = Validator()
                    //       .validateDoctorPhoneNumber(_userMobile.text);
                    //   print(errorText);
                    // });
                    if (_formKey.currentState.validate()) {
                      // setState(() {
                      //   errorText = Validator().validateDoctorPhoneNumber(_userMobile.text);
                      //   print(errorText);
                      // });
                      isReadOnly = true;
                      await companyInfoVm.updateDoctorProfile(
                          userEmail: _userEmail.text,
                          userMobile: _userMobile.text,
                          hospitalNo: companyInfoVm.details.name,
                          id: companyInfoVm.details.userId.toString());
                      if (companyInfoVm.resDoctorStatusCode == '200') {
                        vm.editingPersonalInfo(isPersonalInfoEditing: false);
                      }
                    }
                  },
                  child: Text(
                    'Save',
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: isTablet ? 18 : 15),
                  ))
            ],
          );
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: HexColor("#FFFFFF"),
                boxShadow: [
                  BoxShadow(
                    color: HexColor("#0D1231").withOpacity(0.08),
                    spreadRadius: 3,
                    blurRadius: 3,
                    offset: Offset(3, 1), // changes position of shadow
                  ),
                ]),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  spaceBetween,
                  spaceBetween,
                  spaceBetween,
                  nameHeading,
                  doctorName,
                  spaceBetween,
                  designationHeading,
                  designation,
                  spaceBetween,
                  specializationHeading,
                  specialization,
                  spaceBetween,
                  degreeHeading,
                  degree,
                  spaceBetween,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(),
                      addMoreButton,
                    ],
                  ),
                  bmdcNoHeading,
                  bmdcNo,
                  spaceBetween,
                  doctorSignatureHeading,
                  doctorSignature,
                  spaceBetween,
                  digitalSignatureHeading,
                  digitalSignature,
                  spaceBetween,
                  mobileText,
                  mobileField,
                  spaceBetween,
                  emailHeading,
                  email,
                  spaceBetween,
                  spaceBetween,
                ],
              ),
            ),
          ),
          spaceBetween,
          spaceBetween,
          editButton
        ],
      ),
    );
  }

  void _showAlertDialogForPassword(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return ChangeDoctorPasswordAlert();
        });
  }

  void _uploadSignature(BuildContext context) {
    showDialog(
        //barrierColor: Color(0x00ffffff),
        context: context,
        builder: (context) {
          return DoctorSignaturePrompt();
        });
  }
}
