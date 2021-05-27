import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:myhealthbd_app/features/auth/view_model/accessToken_view_model.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/features/my_health/view/patient_portal_screen.dart';
import 'package:myhealthbd_app/features/my_health/view_model/file_type_view_model.dart';
import 'package:myhealthbd_app/features/my_health/view_model/upload_documents_view_model.dart';
import 'package:myhealthbd_app/features/notification/view/notification_screen.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/views/widgets/loader.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';

class UploadDocumentScreen extends StatefulWidget {
  const UploadDocumentScreen({Key key}) : super(key: key);

  @override
  _UploadDocumentScreenState createState() => _UploadDocumentScreenState();
}

class _UploadDocumentScreenState extends State<UploadDocumentScreen> {
  DateTime pickBirthDate;
  TextEditingController _descriptionTextEditingController = TextEditingController();
  var _searchFieldFocusNode2 = FocusNode();
  File file;
  int filesize;

  String _selectedDocumentType;
  @override
  void initState() {
    // TODO: implement initState
    pickBirthDate=DateTime.now();
    _selectedDocumentType=null;
    var vm= Provider.of<FileTypeViewModel>(context,listen: false);
    Future.delayed(Duration.zero, () async {
      await Provider.of<UploadDocumentsViewModel>(context, listen: false).uploadDocuments();
    });
    vm.getData();
    super.initState();
  }


  File _image;
  final picker = ImagePicker();
  bool isEdit = false;
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      print("ish ${await _image.length()}");
      setState(() {
        isEdit = true;
      });
    } else {
      print('No image selected.');
    }
  }


  @override
  Widget build(BuildContext context) {
    var cardHeight = MediaQuery.of(context).size.height * 0.1537;
    var vm= Provider.of<FileTypeViewModel>(context,listen: true);
    var vm2 = Provider.of<UploadDocumentsViewModel>(context, listen: true);
    String _reportDate = DateFormat("yyyy-MM-dd").format(pickBirthDate);

    //print('FileTYpe::: ${vm.fileTypeList.first.typeName}');


    String color = "#8592E5";
    var docType = Row(
      children: [
        GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 35.0,
                  width: MediaQuery.of(context).size.width*.6,
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0,left:5,right:10),
                    child: Text("Select Document Type",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: HexColor('#333132'),fontSize: 12),),
                  )),
              Container(
                height: 45.0,
                width:MediaQuery.of(context).size.width*.89,
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
                                hint: Text('Document Type', style:  GoogleFonts.roboto(fontSize: 13, color: HexColor("#333132")),), // Not necessary for Option 1
                                value: _selectedDocumentType,
                                onChanged: (newValue) {
                                  setState(() {
                                    _selectedDocumentType = newValue;
                                    print('SelectValue::::: $_selectedDocumentType');
                                  });
                                },
                                items: vm.fileTypeList.map((fileType) {
                                  return DropdownMenuItem(
                                    child: new Text(
                                      fileType.typeName,
                                      style: GoogleFonts.roboto(fontSize: 14),
                                    ),
                                    value: fileType.typeNo.toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 300.0, top: 5),
                          child: Icon(Icons.keyboard_arrow_down_sharp, color: HexColor("#8592E5"),size: 30,),
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



    String abc = "#8592E5";

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
      print('Dattedd::::: ${pickBirthDate.toString()}');
      print('Dattedddd::::: ${DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSSZ").format(pickBirthDate).toString()}');
    }



    var dateOfDocumentdate = Row(
      children: [
        GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  height: 35.0,
                  width: MediaQuery.of(context).size.width*.8,
                  child: Padding(
                    padding: const EdgeInsets.only(top:8.0,left:5,right:10),
                    child: Text("Select Date mentioned on the Document",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: HexColor('#333132'),fontSize: 12),),
                  )),
              Container(
                height: 48.0,
                width: MediaQuery.of(context).size.width * 0.89,
                decoration: BoxDecoration(
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
                            : "${DateFormat("dd-MM-yyyy").format(pickBirthDate)}",
                        style: TextStyle(fontSize: 13.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Container(
                          height: 18,
                          child:
                          Image.asset("assets/images/caa.png")),
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

    var writeDetailsField=Container(
      width: MediaQuery.of(context).size.width*.89,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        //color: Colors.white,
        border: Border.all(color: HexColor('#8592E5')),
      ),
      child:
      Padding(
        padding: const EdgeInsets.only(left:15.0,bottom: 8),
        child: TextField(
          autofocus: false,
          textInputAction: TextInputAction.search,
          focusNode: _searchFieldFocusNode2,
          controller: _descriptionTextEditingController,
          cursorColor: HexColor('#C5CAE8'),
          decoration: InputDecoration(
              border: InputBorder.none,
             // hintText: 'Search here',
              hintStyle: GoogleFonts.poppins(fontSize: 11,fontWeight: FontWeight.w400),
              fillColor: Colors.white,
              // suffixIcon:IconButton(
              //   icon:Icon(Icons.search_sharp,color: Colors.grey,),
              //   onPressed: (){
              //     vm2.search(_searchTextEditingController2.text,widget.accessToken);
              //
              //   },
              // )
          ),
          onSubmitted: (v){
            //vm2.search(_searchTextEditingController2.text,widget.accessToken);
          },

        ),
      ),
    );


    final String assetName = "assets/images/camm.svg";
    final String assetName2 = "assets/images/uyp.svg";

    final Widget upCam = SvgPicture.asset(
      assetName,
      height:35,
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );

    final Widget fileUp = SvgPicture.asset(
      assetName2,
      height:35,
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );


    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor('#354291'),
        title: Text('Upload Document',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500),),
        actions: [
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NotificationScreen()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:8.0,left:10,right:10),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    InkWell(
                      onTap: (){
                        getImage();
                      },
                      child: Container(
                        height: cardHeight*0.9,
                        width: 160,
                        margin: EdgeInsets.only(top: 8,bottom: 5,right: 12,left: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.bottomRight, stops: [
                            1.0,
                          ], colors: [
                            //HexColor('#C5CAE8'),
                            HexColor('#8592E5'),

                          ]),
                          //color: Colors.white,
                          // border: Border.all(
                          //   color: HexColor("#E9ECFE"),
                          //   width: 1,
                          // ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top:30.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              upCam,
                              SizedBox(height: 5,),
                              Text("Capture Document",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 12),),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () async{
                        FilePickerResult result =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ['pdf', 'zip', 'doc', 'docx'],
                        );
                        if (result != null) {
                          file = File(result.files.single.path);
                          filesize = file.lengthSync();
                          setState(() {});
                        }
                        print('FileTapped:::');
                      },
                      child: Container(
                        height: cardHeight*0.9,
                        width: 160,
                        margin: EdgeInsets.only(top: 8,bottom: 5,right: 10,left: 10),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(begin: Alignment.bottomRight, stops: [
                            1.0,
                          ], colors: [
                            //HexColor('#C5CAE8'),
                            HexColor('#8592E5'),

                          ]),
                          //color: Colors.white,
                          // border: Border.all(
                          //   color: HexColor("#E9ECFE"),
                          //   width: 1,
                          // ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top:25.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              fileUp,
                              SizedBox(height: 5,),
                              Text("Upload Document\n(JPG,PNG,PDF only)",style: GoogleFonts.poppins(fontWeight: FontWeight.w600,color: Colors.white,fontSize: 12),),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.only(top:8.0,left:10,right:10),
                  child: docType,
                ),

                Padding(
                  padding: const EdgeInsets.only(top:8.0,left:10,right:10),
                  child: dateOfDocumentdate,
                ),
                Padding(
                  padding: const EdgeInsets.only(top:8.0,left:15,right:10),
                  child: Text("Attachment Description",style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: HexColor('#333132'),fontSize: 12),),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:8.0,left:10,right:10),
                  child: writeDetailsField,
                ),

                Padding(
                  padding: const EdgeInsets.only(top:15.0,left:10,right:10),
                  child: InkWell(
                    onTap: () async{
                      var accessToken=await Provider.of<AccessTokenProvider>(appNavigator.context, listen: false).getToken();
                      var details = Provider.of<UserDetailsViewModel>(appNavigator.context,listen: false);
                     await vm2.uploadDocuments(file: file==null?_image:file,accessToken: accessToken,attachmentTypeNo: _selectedDocumentType,pickDate:_reportDate,regID: details.userDetailsList.id,username: details.userDetailsList.hospitalNumber,description: _descriptionTextEditingController.text);
                      print("Upload Doc tapped");
                      // await Future.delayed(Duration(seconds: 3));
    Future.delayed(Duration.zero, () async {
      file==null?Loader():
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) =>
          // DoctorHomeScreen(
          PrescriptionListScreen(accessToken: accessToken

          )));
    });

                    },
                    child: Material(
                      elevation: 2  ,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      color:file==null && _image==null||_selectedDocumentType==null?HexColor("#B8C2F8"):HexColor("#354291"),
                      child: SizedBox(
                        width: double.infinity,
                        height:  MediaQuery.of(context).size.width >600? 35 : 40,
                        child: Center(
                          child: Text("Upload Document",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DateUtil {

  static const DATE_FORMAT = 'yyyy-MM-dd HH:mm:ss';
  String formattedDate(DateTime dateTime) {
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}