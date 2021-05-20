import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:myhealthbd_app/features/appointment_history/models/zoom_model.dart';
import 'package:myhealthbd_app/features/appointment_history/view_model/previous_vew_model.dart';
import 'package:myhealthbd_app/features/appointment_history/view_model/upcoming_view_model.dart';
import 'package:myhealthbd_app/features/appointment_history/view_model/zoom_view_model.dart';
import 'package:myhealthbd_app/features/appointments/models/previous_appointment_model.dart';
import 'package:myhealthbd_app/features/appointments/models/upcoming_appointment_model.dart';
import 'package:myhealthbd_app/features/appointments/view/appointments_screen.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/hospital_list_view_model.dart';
import 'package:myhealthbd_app/features/find_doctor/view_model/doctor_list_view_model.dart';
import 'package:myhealthbd_app/features/notification/view/notification_screen.dart';
import 'package:myhealthbd_app/main_app/api_helper/url_launcher_helper.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/views/widgets/SignUpField.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_text_field_rounded.dart';
import 'package:myhealthbd_app/main_app/views/widgets/pdf_viewer.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart' as pp;

class GetAppointment extends StatefulWidget {
  String accessToken;
  final Function onTapFeaturedCompany;
  GetAppointment({this.accessToken,this.onTapFeaturedCompany});
  @override
  _GetAppointmentState createState() => _GetAppointmentState();
}

class _GetAppointmentState extends State<GetAppointment> {
  ScrollController _scrollController = ScrollController();
  ScrollController _scrollController2 = ScrollController();
  bool checkedValue=false;
  DateTime pickBirthDate;
  Future<Null> selectBirthDate(BuildContext context) async {
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
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 6)),
    );

    if (date != null && date != pickBirthDate) {
      setState(() {
        pickBirthDate = date;
      });
    }
  }
  String color = "#EAEBED";


  Future fetchPDF(String prescriptionNo,String companyAlias) async {
    try {
      print("FETCHPDFDATAFromAppointmentHistory");
      print('INDEX'+prescriptionNo);
      var headers = {
        'Authorization': 'Bearer ${widget.accessToken}'
      };
      var request = http.MultipartRequest('POST', Uri.parse('https://qa.myhealthbd.com:9096/prescription-service-api/api/report/prescription'));
      request.fields.addAll({
        'prescriptionId': prescriptionNo,
        'pClient': companyAlias,
        'pLayout': '1'
      });

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        var body = await response.stream.toBytes();
        print("BODYOFSTRING:::"+body.toString());
        return body;
      }
      else {
        print("ERROROFSTRING::::"+response.reasonPhrase);
        return null;
      }
    } on Exception catch (e) {
      // TODO
      print("PDFDATAERROR");
      print(e.toString());
      return null;
    }

  }

  Future<File> _createPdfFileFromString(String prescriptionNo,String companyAlias) async {
    // final encodedStr='''''';
    // Uint8List bytes = base64.decode(encodedStr);
    String dir = (await pp.getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".pdf");
    await file.writeAsBytes(await fetchPDF(prescriptionNo,companyAlias),flush: true);
    print("FILEEEEE"+file.toString());
    return file;
  }

  loadLogo(String image){
    Uint8List  _bytesImage = Base64Decoder().convert(image);

    return Image.memory(
      _bytesImage,
      fit: BoxFit.fill,
      width: 80,
      height: 60,
      gaplessPlayback: true,
    );
  }

  TextEditingController _searchTextEditingController1 = TextEditingController();
  var _searchFieldFocusNode = FocusNode();

  TextEditingController _searchTextEditingController2 = TextEditingController();
  var _searchFieldFocusNode2 = FocusNode();
  String zoomLinkList;
  String message;


  Future<void> getZoomLink({String con}){
    var vm5 = Provider.of<ZoomViewModel>(context, listen: false);
    vm5.getData(accessToken: widget.accessToken,consultationId: con);
  }
  @override
  void initState() {
    // TODO: implement initState
    var vm = Provider.of<AppointmentUpcomingViewModel>(context, listen: false);
    vm.getData(widget.accessToken);
    var vm2 = Provider.of<AppointmentPreviousViewModel>(context, listen: false);
    vm2.getData();
    getZoomLink();
    //fetchZoomLink(accessToken: widget.accessToken);
    // var vm4 = appNavigator.getProvider<HospitalListViewModel>();
    // var vm3 = Provider.of<DoctorListViewModel>(context, listen: false);
    // vm3.getDoctor(orgNo:widget.orgNo, companyNo:widget.companyNo, deptItem:null, specialSelectedItem:null, doctorSearch:"");
    super.initState();

    _scrollController.addListener(() {


      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent-500) {
        print('scrolklinggtatg');
        vm.getMoreData(widget.accessToken);
      }

    });

    _scrollController2.addListener(() {


      if (_scrollController2.position.pixels >=
          _scrollController2.position.maxScrollExtent-500) {
        print('scrolklinggtatg');
        vm2.getMoreData(widget.accessToken);
      }

    });
  }
  @override
  Widget build(BuildContext context) {
    var deviceHeight = MediaQuery.of(context).size.height;
    var cardWidth = MediaQuery.of(context).size.width * 0.3435;
    double bottomTextSize=  MediaQuery.of(context).size.width >600? 12 :11;
    var deviceWidth = MediaQuery.of(context).size.width;
    var contrainerWidth = deviceWidth >= 400 ? double.infinity : 400.00;
    var width = MediaQuery.of(context).size.width * 0.44;

    var vm = Provider.of<AppointmentUpcomingViewModel>(context,listen: true);
    var vm2 = Provider.of<AppointmentPreviousViewModel>(context,listen: true);
    var vm3 = Provider.of<DoctorListViewModel>(context);
    var vm5 = Provider.of<ZoomViewModel>(context);

    final Widget filtericon = SvgPicture.asset(
      "assets/icons/fliter.svg",
      width: 10,
      height: 18,
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );

    final Widget calenderIcon = SvgPicture.asset(
      "assets/icons/calen.svg",
      width: 10,
      height: 18,
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );

    var searchField=Padding(
      padding: const EdgeInsets.only(left:12.0,right: 0,top:8,bottom: 3),
      child: Container(
        width: MediaQuery.of(context).size.width*.70,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          border: Border.all(color: HexColor('#E1E1E1')),
        ),
        child:
        Padding(
          padding: const EdgeInsets.only(left:15.0,bottom: 8),
          child: TextField(
            autofocus: false,
            textInputAction: TextInputAction.search,
            focusNode: _searchFieldFocusNode,
            controller: _searchTextEditingController1,
            cursorColor: HexColor('#C5CAE8'),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search here',
                hintStyle: GoogleFonts.poppins(fontSize: 11,fontWeight: FontWeight.w400),
                //labelText: "Resevior Name",
                fillColor: Colors.white,
                // focusedBorder:UnderlineInputBorder(
                //   borderSide:  BorderSide(color: HexColor('#354291').withOpacity(0.5), width: 1.5),
                //   //borderRadius: BorderRadius.circular(25.0),
                // ),
                suffixIcon:IconButton(
                  icon:Icon(Icons.search_sharp,color: Colors.grey,),
                  onPressed: (){
                    vm.search(_searchTextEditingController1.text,widget.accessToken);

                  },
                )
            ),
            // onChanged: (text) {
            //   //value = text;
            // },
            onSubmitted: (v){
              vm.search(_searchTextEditingController1.text,widget.accessToken);
            },

          ),
        ),
      ),
    );

    var searchField2=Padding(
      padding: const EdgeInsets.only(left:12.0,right: 0,top:8,bottom: 3),
      child: Container(
        width: MediaQuery.of(context).size.width*.70,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          border: Border.all(color: HexColor('#E1E1E1')),
        ),
        child:
        Padding(
          padding: const EdgeInsets.only(left:15.0,bottom: 8),
          child: TextField(
            autofocus: false,
            textInputAction: TextInputAction.search,
            focusNode: _searchFieldFocusNode2,
            controller: _searchTextEditingController2,
            cursorColor: HexColor('#C5CAE8'),
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search here',
                hintStyle: GoogleFonts.poppins(fontSize: 11,fontWeight: FontWeight.w400),
                //labelText: "Resevior Name",
                fillColor: Colors.white,
                // focusedBorder:UnderlineInputBorder(
                //   borderSide:  BorderSide(color: HexColor('#354291').withOpacity(0.5), width: 1.5),
                //   //borderRadius: BorderRadius.circular(25.0),
                // ),
                suffixIcon:IconButton(
                  icon:Icon(Icons.search_sharp,color: Colors.grey,),
                  onPressed: (){
                    vm2.search(_searchTextEditingController2.text,widget.accessToken);

                  },
                )
            ),
            // onChanged: (text) {
            //   //value = text;
            // },
            onSubmitted: (v){
              vm2.search(_searchTextEditingController2.text,widget.accessToken);
            },

          ),
        ),
      ),
    );
    final String assetName5="assets/icons/med.svg";
    final Widget upComingBlank = SvgPicture.asset(
      assetName5,
      width: 80,
      height: 100,
      fit: BoxFit.fitWidth,
      allowDrawingOutsideViewBox: true,
      matchTextDirection: true,
      //semanticsLabel: 'Acme Logo'
    );
    return Scaffold(
      appBar: AppBar(
        //leading: Icon(Icons.notes),
        backgroundColor: HexColor('#354291'),
        title: Text('Appointments',style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500),),
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
      body:
      DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              constraints: BoxConstraints(maxHeight: 150.0),
              child: Material(
                color: HexColor('#E9ECFE'),
                child: TabBar(
                  indicatorColor: HexColor('#8592E5'),
                  indicatorWeight:4,
                  tabs: [
                    Container(
                      height: 40,
                      //width: 10.0,
                      child:Center(child: Text('Upcoming',style: GoogleFonts.roboto(color: HexColor('#354291',),fontWeight: FontWeight.w500),)),
                    ),
                    Container(
                      height: 40,
                      child: Center(child: Text('Previous',style: GoogleFonts.roboto(color: HexColor('#354291'),fontWeight: FontWeight.w500),)),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  RefreshIndicator(
                    onRefresh: (){
                      return vm.refresh(widget.accessToken);
                    },
                    child: WillPopScope(
                      child: Scaffold(
                          body:
                          Column(
                            children: [
                              Container(
                                height: 55,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(vm.isInSearchMode ? Icons.close : Icons.search,color: Colors.grey,),
                                      onPressed: () {
                                        _searchTextEditingController1?.clear();
                                        vm.toggleIsInSearchMode(widget.accessToken);

                                        if (vm.isInSearchMode) {
                                          _searchFieldFocusNode.requestFocus();
                                        } else {
                                          _searchFieldFocusNode.unfocus();
                                        }
                                      },
                                    ),
                                    if (vm.isInSearchMode)searchField,
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right:15.0),
                                      child: GestureDetector(
                                          onTap: (){
                                            showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(25),
                                                        topRight: Radius.circular(25))),
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) {

                                                  return Container(
                                                    height: 480,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 20,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(),
                                                            Text("Filter",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600,color: HexColor('#333132')),),
                                                            // SizedBox(width: 100,),
                                                            GestureDetector(onTap: (){
                                                              Navigator.pop(context);
                                                            },child: Icon(Icons.close,size: 30,)),
                                                          ],
                                                        ),
                                                        SingleChildScrollView(
                                                          child:
                                                          Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets.only(top:15.0,left: 10),
                                                                child: Text(
                                                                  'Select Date',style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w600,color: HexColor('#333132')),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  selectBirthDate(context);
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 10.0),
                                                                  child: Container(
                                                                    height: 50.0,
                                                                    width: MediaQuery.of(context).size.width*0.88,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.transparent,
                                                                        border: Border.all(color: HexColor(color)),
                                                                        borderRadius: BorderRadius.circular(10)),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 20.0),
                                                                          child: Text(
                                                                              pickBirthDate == DateTime.now()
                                                                                  ? "Select Date"
                                                                                  : "From: 22/02/2021",
                                                                              style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500,color: HexColor('#354291'),)
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 8.0),
                                                                          child: Container(
                                                                            height: 18,
                                                                            child:
                                                                            calenderIcon,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(height: 10,),
                                                              GestureDetector(
                                                                onTap: (){
                                                                  selectBirthDate(context);
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 10.0),
                                                                  child: Container(
                                                                    height: 50.0,
                                                                    width: MediaQuery.of(context).size.width*0.88,
                                                                    decoration: BoxDecoration(
                                                                        color: Colors.transparent,
                                                                        border: Border.all(color: HexColor(color)),
                                                                        borderRadius: BorderRadius.circular(10)),
                                                                    child: Row(
                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(left: 15.0),
                                                                          child: Text(
                                                                              pickBirthDate == DateTime.now()
                                                                                  ? "Select Date"
                                                                                  : "To:",
                                                                              style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500,color: HexColor('#354291'),)
                                                                          ),
                                                                        ),
                                                                        Padding(
                                                                          padding: const EdgeInsets.only(right: 8.0),
                                                                          child: Container(
                                                                            height: 18,
                                                                            child:
                                                                            calenderIcon,
                                                                          ),
                                                                        ),

                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(top:15.0,left: 10),
                                                                child: Text(
                                                                  'Consultation type',style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w600,color: HexColor('#333132')),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex:2,
                                                                    child: CheckboxListTile(
                                                                      title: Text("Fresh visit",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 11,color: HexColor('#333132'))),
                                                                      value: checkedValue,
                                                                      onChanged: (newValue) {
                                                                        setState(() {
                                                                          checkedValue = newValue;
                                                                        });
                                                                      },
                                                                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex:2,
                                                                    child: CheckboxListTile(
                                                                      title: Text('Report check',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 11,color: HexColor('#333132'))),
                                                                      value: checkedValue,
                                                                      onChanged: (newValue) {
                                                                        setState(() {
                                                                          checkedValue = newValue;
                                                                        });
                                                                      },
                                                                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Expanded(
                                                                    flex:2,
                                                                    child: CheckboxListTile(
                                                                      title: Text("Follow up",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 11,color: HexColor('#333132'))),
                                                                      value: checkedValue,
                                                                      onChanged: (newValue) {
                                                                        setState(() {
                                                                          checkedValue = newValue;
                                                                        });
                                                                      },
                                                                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    flex:2,
                                                                    child: CheckboxListTile(
                                                                      title: Text('2nd Follow up',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 11,color: HexColor('#333132'))),
                                                                      value: checkedValue,
                                                                      onChanged: (newValue) {
                                                                        setState(() {
                                                                          checkedValue = newValue;
                                                                        });
                                                                      },
                                                                      controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                                                    ),
                                                                  ),

                                                                ],
                                                              ),
                                                              Padding(
                                                                padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 22),
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    SizedBox(
                                                                      width: width * .9,
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
                                                                          "Clear Filter",
                                                                          style: GoogleFonts.poppins(),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: width * .9,
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
                                                                          "Apply Filter",
                                                                          style: GoogleFonts.poppins(),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                          ,
                                                        )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: filtericon),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: vm.shouldShowPageLoader?Center(
                                  child: Center(
                                    child: CircularProgressIndicator(  valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        AppTheme.appbarPrimary),),
                                  ),
                                ):vm.upComingAppointmentList.length==0&&!vm.isInSearchMode?Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:120.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text('You have no upcoming \nappointment.',textAlign: TextAlign.center,style: GoogleFonts.poppins(color: HexColor('#333132'),fontWeight: FontWeight.w500,fontSize: 17),),
                                          SizedBox(height: 30,),
                                          upComingBlank,
                                          SizedBox(height: 30,),
                                          GestureDetector(
                                            onTap: widget.onTapFeaturedCompany,
                                            child: Material(
                                              elevation: 2  ,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                              color: HexColor("#354291"),
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width >600? 35 : 300,
                                                height:  MediaQuery.of(context).size.width >600? 35 : 45,
                                                child: Center(
                                                  child: Text("Get an appointment",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ): ListView.builder(
                                     controller: _scrollController,
                                     shrinkWrap: true,
                                     itemCount:vm.upComingAppointmentList.length,
                                     itemBuilder: (BuildContext context, int index) {
                                       //print("LIIIISSSYYSY:::" + list[index].consultationId);
                                       if(index==vm.upComingAppointmentList.length){
                                         return vm.isFetchingMoreData?SizedBox(height:60 ,child: Center(child: CircularProgressIndicator())):SizedBox();
                                         //return SizedBox(height: 15,);

                                       }
                                       return  Stack(
                                             children:[
                                               InkWell(
                                                 child: Container(
                                                   height: MediaQuery.of(context).size.width >600? 200 : 185,
                                                   margin: EdgeInsets.only(top: 8,bottom: 5,right: 10,left: 10),
                                                   decoration: BoxDecoration(
                                                     color:HexColor('#F0F2FF'),
                                                     borderRadius: BorderRadius.circular(15),
                                                   ),
                                                   child: Padding(
                                                     padding: EdgeInsets.only(left:10.0,right:10),
                                                     child: Column(
                                                       children: [
                                                         Row(
                                                           children: [
                                                             Container(
                                                              // height: 60,
                                                               //width: 20,
                                                               child: vm.upComingAppointmentList[index].photo!=null?loadLogo(vm.upComingAppointmentList[index].photo):Image.asset(
                                       "assets/icons/dct.png",
                                       fit: BoxFit.fill,
                                       width: 80,
                                       height: 60,
                                       ),
                                                             ),
                                                             SizedBox(width: 5,),
                                                             Padding(
                                                               padding: EdgeInsets.only(bottom: deviceWidth>600? 20 : 5,left: 1),
                                                               child: Column(
                                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                                                 children: [
                                                                   SizedBox(height: deviceWidth >600? 8 : 3,),
                                                                   Text(vm.upComingAppointmentList[index].doctorName,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: HexColor('#393939'),fontSize: 12),),
                                                                   Text(vm.upComingAppointmentList[index]?.doctorSpecialtyName??'',style: GoogleFonts.poppins(color: HexColor('#354291'),fontSize: 12,fontWeight: FontWeight.w500),),
                                                                   Container(
                                                                       width:MediaQuery.of(context).size.width*.65,child: Text(vm.upComingAppointmentList[index].companyName,maxLines: 2,overflow:TextOverflow.ellipsis,style: GoogleFonts.poppins(color: HexColor('#354291'),fontSize: 12))),
                                                                 ],
                                                               ),

                                                             ),
                                                             // Container(width:45,child: rx),
                                                             // (controller.isSelecting)?
                                                             // Padding(
                                                             //   padding: const EdgeInsets.only(bottom:40.0,right: 10),
                                                             //   child: righticon,
                                                             // ):


                                                           ],
                                                         ),
                                                         Divider(thickness: 1,),
                                                         Padding(
                                                           padding:  EdgeInsets.only(top:5.0,right: 2,bottom: 8,left: deviceHeight>650 ? 10 :5),
                                                           child: Column(
                                                             crossAxisAlignment: CrossAxisAlignment.start,
                                                             children: [
                                                               SizedBox(height: 3,),
                                                               Row(
                                                                 children: [
                                                                   Row(
                                                                     children: [
                                                                       Text("Serial No: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                       Text(vm.upComingAppointmentList[index].slotSl.toString(),style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#8592E5'),fontSize:  deviceWidth> 420 ? bottomTextSize: 10),),

                                                                     ],
                                                                   ),
                                                                   SizedBox(width:  MediaQuery.of(context).size.width >600? 10 :5,),
                                                                   Row(
                                                                     children: [
                                                                       Text("Date: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize:  deviceWidth> 420 ? bottomTextSize: 10),),
                                                                       Text(DateUtil().formattedDate(DateTime.parse(vm.upComingAppointmentList[index].appointDate).toLocal()),style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#8592E5'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),

                                                                     ],
                                                                   ),
                                                                   SizedBox(width:  MediaQuery.of(context).size.width >600? 10 : 5,),
                                                                   Row(
                                                                     children: [
                                                                       Text("Time: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                       Text(TimeUtil().formattedDate(DateTime.parse(vm.upComingAppointmentList[index].appointDate).toUtc()),style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#8592E5'),fontSize:  deviceWidth> 420 ? bottomTextSize: 10),),
                                                                     ],
                                                                   ),
                                                                 ],
                                                               ),
                                                               SizedBox(height: MediaQuery.of(context).size.width >600? 10 :5,),
                                                               Row(
                                                                 children: [
                                                                   Row(
                                                                     children: [
                                                                       Text("Consultation Type: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                       Text(vm.upComingAppointmentList[index].consultTypeName,style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#8592E5'),fontSize: deviceWidth> 450 ? bottomTextSize: 10),),

                                                                     ],
                                                                   ),
                                                                   SizedBox(width: 10,),
                                                                   Row(
                                                                     children: [
                                                                       Text("Status: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                       Text(vm.upComingAppointmentList[index].status==1?"Waiting":"Pending",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color:vm.upComingAppointmentList[index].status==1? HexColor('#EEB329'):HexColor('#FFA7A7'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),

                                                                     ],
                                                                   ),
                                                                 ],
                                                               ),

                                                             ],
                                                           ),

                                                         ),
                                                         SizedBox(height:  MediaQuery.of(context).size.width >600? 5 : 3,),
                                                         GestureDetector(
                                                           onTap:(){
                                                             getZoomLink(con: vm.upComingAppointmentList[index].consultationId);
                                                               if (vm5.zoomDetailsList.joinUrl.isNotEmpty)
                                                                 UrlLauncherHelper.launchUrl(vm5.zoomDetailsList?.joinUrl??'');
                                                           },
                                                           child: Material(
                                                             elevation: 2  ,
                                                             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                             color:vm.upComingAppointmentList[index].consultationId==null?HexColor("#99A0C8"):HexColor("#354291"),
                                                             child: SizedBox(
                                                               width: double.infinity,
                                                               height:  MediaQuery.of(context).size.width >600? 35 : 28,
                                                               child: Center(
                                                                 child: Text("Start Consultation",style: TextStyle(color: Colors.white,fontSize: 13,fontWeight: FontWeight.w500),),
                                                               ),
                                                             ),
                                                           ),
                                                         ),
                                                       ],
                                                     ),
                                                   ),
                                                 ),
                                               ),
                                             ]
                                         );
                                     }),
                              ),
                            ],
                          )

                      ),
                    ),
                  ),


                  //Previous Appointment

                  RefreshIndicator(
                    onRefresh: (){
                      return vm2.refresh(widget.accessToken);
                    },
                    child: WillPopScope(
                      child: Scaffold(
                          body:
                          Column(
                            children: [
                              Container(
                                height: 55,
                                child: Row(
                                  children: [
                                    IconButton(
                                      key: Key('featuredJobSearchToggleButtonKey'),
                                      icon: Icon(vm2.isInSearchMode ? Icons.close : Icons.search,color: Colors.grey,),
                                      onPressed: () {
                                        _searchTextEditingController2?.clear();
                                        vm2.toggleIsInSearchMode(widget.accessToken);

                                        if (vm2.isInSearchMode) {
                                          _searchFieldFocusNode2.requestFocus();
                                        } else {
                                          _searchFieldFocusNode2.unfocus();
                                        }
                                      },
                                    ),
                                    if (vm2.isInSearchMode)searchField2,
                                    Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.only(right:15.0),
                                      child: GestureDetector(
                                          onTap: (){
                                            showModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft: Radius.circular(25),
                                                        topRight: Radius.circular(25))),
                                                context: context,
                                                isScrollControlled: true,
                                                builder: (context) {

                                                  return Container(
                                                    height: 480,
                                                    child: Column(
                                                      children: [
                                                        SizedBox(height: 20,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(),
                                                            Text("Filter",style: GoogleFonts.poppins(fontSize: 16,fontWeight: FontWeight.w600,color: HexColor('#333132')),),
                                                           // SizedBox(width: 100,),
                                                            GestureDetector(onTap: (){
                                                              Navigator.pop(context);
                                                            },child: Icon(Icons.close,size: 30,)),
                                                          ],
                                                        ),
                                                      SingleChildScrollView(
                                                        child:
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.only(top:15.0,left: 10),
                                                              child: Text(
                                                                'Select Date',style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w600,color: HexColor('#333132')),
                                                              ),
                                                            ),
                                                            SizedBox(height: 10,),
                                                            GestureDetector(
                                                              onTap: (){
                                                                selectBirthDate(context);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 10.0),
                                                                child: Container(
                                                                  height: 50.0,
                                                                  width: MediaQuery.of(context).size.width*0.88,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.transparent,
                                                                      border: Border.all(color: HexColor(color)),
                                                                      borderRadius: BorderRadius.circular(10)),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 20.0),
                                                                        child: Text(
                                                                          pickBirthDate == DateTime.now()
                                                                              ? "Select Date"
                                                                              : "From: 22/02/2021",
                                                                          style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500,color: HexColor('#354291'),)
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(right: 8.0),
                                                                        child: Container(
                                                                            height: 18,
                                                                            child:
                                                                            calenderIcon,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(height: 10,),
                                                            GestureDetector(
                                                              onTap: (){
                                                                selectBirthDate(context);
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.only(left: 10.0),
                                                                child: Container(
                                                                  height: 50.0,
                                                                  width: MediaQuery.of(context).size.width*0.88,
                                                                  decoration: BoxDecoration(
                                                                      color: Colors.transparent,
                                                                      border: Border.all(color: HexColor(color)),
                                                                      borderRadius: BorderRadius.circular(10)),
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(left: 15.0),
                                                                        child: Text(
                                                                          pickBirthDate == DateTime.now()
                                                                              ? "Select Date"
                                                                              : "To:",
                                                                            style: GoogleFonts.poppins(fontSize: 14,fontWeight: FontWeight.w500,color: HexColor('#354291'),)
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.only(right: 8.0),
                                                                        child: Container(
                                                                            height: 18,
                                                                            child:
                                                                            calenderIcon,
                                                                        ),
                                                                      ),

                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(top:15.0,left: 10),
                                                              child: Text(
                                                                  'Consultation type',style: GoogleFonts.poppins(fontSize: 17,fontWeight: FontWeight.w600,color: HexColor('#333132')),
                                                              ),
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex:2,
                                                                  child: CheckboxListTile(
                                                                    title: Text("Fresh visit",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 11,color: HexColor('#333132'))),
                                                                    value: checkedValue,
                                                                    onChanged: (newValue) {
                                                                      setState(() {
                                                                        checkedValue = newValue;
                                                                      });
                                                                    },
                                                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex:2,
                                                                  child: CheckboxListTile(
                                                                    title: Text('Report check',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 11,color: HexColor('#333132'))),
                                                                    value: checkedValue,
                                                                    onChanged: (newValue) {
                                                                      setState(() {
                                                                        checkedValue = newValue;
                                                                      });
                                                                    },
                                                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Row(
                                                              children: [
                                                                Expanded(
                                                                  flex:2,
                                                                  child: CheckboxListTile(
                                                                    title: Text("Follow up",style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 11,color: HexColor('#333132'))),
                                                                    value: checkedValue,
                                                                    onChanged: (newValue) {
                                                                      setState(() {
                                                                        checkedValue = newValue;
                                                                      });
                                                                    },
                                                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  flex:2,
                                                                  child: CheckboxListTile(
                                                                    title: Text('2nd Follow up',style: GoogleFonts.poppins(fontWeight: FontWeight.w500,fontSize: 11,color: HexColor('#333132'))),
                                                                    value: checkedValue,
                                                                    onChanged: (newValue) {
                                                                      setState(() {
                                                                        checkedValue = newValue;
                                                                      });
                                                                    },
                                                                    controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                                                                  ),
                                                                ),

                                                              ],
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 30.0,right: 30.0,top: 22),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: width * .9,
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
                                                                        "Clear Filter",
                                                                        style: GoogleFonts.poppins(),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width: width * .9,
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
                                                                        "Apply Filter",
                                                                        style: GoogleFonts.poppins(),
                                                                      ),
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                        ,
                                                      )
                                                      ],
                                                    ),
                                                  );
                                                });
                                          },
                                          child: filtericon),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child:
                                vm2.shouldShowPageLoader?Center(
                                  child: Center(
                                    child: CircularProgressIndicator(  valueColor:
                                    AlwaysStoppedAnimation<Color>(
                                        AppTheme.appbarPrimary),),
                                  ),
                                ):vm2.previousAppointmentList.length==0&&!vm2.isInSearchMode?Align(
                                  alignment: Alignment.center,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top:120.0),
                                    child: Container(
                                      child: Column(
                                        children: [
                                          Text('You have no previous \nappointment.',textAlign: TextAlign.center,style: GoogleFonts.poppins(color: HexColor('#333132'),fontWeight: FontWeight.w500,fontSize: 17),),
                                          SizedBox(height: 30,),
                                          upComingBlank,
                                          SizedBox(height: 30,),
                                          GestureDetector(
                                            onTap: widget.onTapFeaturedCompany,
                                            child: Material(
                                              elevation: 2  ,
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                              color: HexColor("#354291"),
                                              child: SizedBox(
                                                width: MediaQuery.of(context).size.width >600? 35 : 300,
                                                height:  MediaQuery.of(context).size.width >600? 35 : 45,
                                                child: Center(
                                                  child: Text("Get an appointment",style: TextStyle(color: Colors.white,fontSize: 15,fontWeight: FontWeight.w500),),
                                                ),
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ),
                                ):
                                ListView.builder(
                                  controller: _scrollController2,
                                    shrinkWrap: true,
                                    itemCount:vm2.previousAppointmentList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      //print("LIIIISSSYYSY:::" + list[index].consultationId);
                                      if(index==vm2.previousAppointmentList.length){
                                        return vm2.isFetchingMoreData?SizedBox(height:60 ,child: Center(child: CircularProgressIndicator())):SizedBox();
                                        //return SizedBox(height: 15,);

                                      }
                                      return  Stack(
                                          children:[
                                            InkWell(
                                              child: Container(
                                                height: deviceWidth>650 ? 210 :200,
                                                margin: EdgeInsets.only(top: 8,bottom: 5,right: 10,left: 10),
                                                decoration: BoxDecoration(
                                                  color:HexColor('#F0F2FF'),
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.only(left:10.0,right:10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Container(
                                                            height: 60,
                                                            //width: 20,
                                                            child: vm2.previousAppointmentList[index].photo!=null?loadLogo(vm2.previousAppointmentList[index].photo):Image.asset(
                                                              "assets/icons/dct.png",
                                                              fit: BoxFit.fill,
                                                              width: 80,
                                                              height: 60,
                                                            ),
                                                          ),
                                                          SizedBox(width: 5,),
                                                          Padding(
                                                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).size.height>650 ? 20 :10,left: 1),
                                                            child: Column(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                SizedBox(height: 8,),
                                                                Text(vm2.previousAppointmentList[index].doctorName,style: GoogleFonts.poppins(fontWeight: FontWeight.bold,color: HexColor('#393939'),fontSize: 12),),
                                                                Text(vm2.previousAppointmentList[index]?.doctorSpecialtyName??'',style: GoogleFonts.poppins(color: HexColor('#354291'),fontSize: 12,fontWeight: FontWeight.w500),),
                                                                Container(   width:MediaQuery.of(context).size.width*.65,child: Text(vm2.previousAppointmentList[index].companyName,maxLines: 2,overflow:TextOverflow.ellipsis,style: GoogleFonts.poppins(color: HexColor('#354291'),fontSize: 12))),
                                                              ],
                                                            ),

                                                          ),
                                                          // Container(width:45,child: rx),
                                                          // (controller.isSelecting)?
                                                          // Padding(
                                                          //   padding: const EdgeInsets.only(bottom:40.0,right: 10),
                                                          //   child: righticon,
                                                          // ):


                                                        ],
                                                      ),
                                                      Divider(thickness: 1,),
                                                      Padding(
                                                        padding:  EdgeInsets.only(top:0.0,right: 2,bottom: 8,left: deviceHeight>650 ? 20 :10),
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(height: 3,),
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text("Serial No: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                    Text(vm2.previousAppointmentList[index].slotSl.toString(),style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#8592E5'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),

                                                                  ],
                                                                ),
                                                                SizedBox(width:MediaQuery.of(context).size.width>650 ?10:5,),
                                                                Row(
                                                                  children: [
                                                                    Text("Date: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                    Text(DateUtil().formattedDate(DateTime.parse(vm2.previousAppointmentList[index].appointDate).toLocal()),style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#8592E5'),fontSize:deviceWidth> 420 ? bottomTextSize: 10),),

                                                                  ],
                                                                ),
                                                                SizedBox(width: MediaQuery.of(context).size.width>650 ?10:5,),
                                                                Row(
                                                                  children: [
                                                                    Text("Time: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                    Text(TimeUtil().formattedDate(DateTime.parse(vm2.previousAppointmentList[index].appointDate).toLocal()),style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#8592E5'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: MediaQuery.of(context).size.width>650 ?10:5,),
                                                            Row(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text("Consultation Type: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                    Text(vm2.previousAppointmentList[index].consultTypeName,style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#8592E5'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),

                                                                  ],
                                                                ),
                                                                SizedBox(width:MediaQuery.of(context).size.width>650 ?10:5,),
                                                                Row(
                                                                  children: [
                                                                    Text("Status: ",style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#333132'),fontSize: deviceWidth> 420 ? bottomTextSize: 10),),
                                                                    Text(vm2.previousAppointmentList[index].status==2?"Completed":'',style: GoogleFonts.poppins(fontWeight:FontWeight.w500,color: HexColor('#32C974'),fontSize:deviceWidth> 420 ? bottomTextSize: 10),),

                                                                  ],
                                                                ),
                                                              ],
                                                            ),

                                                          ],
                                                        ),

                                                      ),
                                                      SizedBox(height: 5,),
                                                      // InkWell(
                                                      //   // onTap:(){
                                                      //   //   Navigator.push(context,MaterialPageRoute(builder: (context){
                                                      //   //     return AppointmentScreen(doctorNo: vm2.previousAppointmentList[index]?.doctorNo.toString() == null
                                                      //   //         ? ""
                                                      //   //         : vm2.previousAppointmentList[index]?.doctorNo.toString(),
                                                      //   //     //
                                                      //   //     //   logo:vm2.previousAppointmentList[index].photo!=null?loadLogo(vm2.previousAppointmentList[index].photo):Image.asset(
                                                      //   //     //   "assets/icons/dct.png",
                                                      //   //     //   fit: BoxFit.fill,
                                                      //   //     //   width: 80,
                                                      //   //     //   height: 60,
                                                      //   //     // ),jobTitle:  vm3.doctorList[index].jobtitle!=null?vm3.doctorList[index].jobtitle:"",name: vm2.previousAppointmentList[index]?.doctorName == null
                                                      //   //     //     ? ""
                                                      //   //     //     : vm2.previousAppointmentList[index]?.doctorName,specialist: vm2.previousAppointmentList[index]?.doctorSpecialtyName == null
                                                      //   //     //     ? ""
                                                      //   //     //     : vm2.previousAppointmentList[index]?.doctorSpecialtyName,hospitalName: vm2.previousAppointmentList[index].companyName,designation: vm3.doctorList[index]?.docDegree == null
                                                      //   //     //     ? ""
                                                      //   //     //     : vm3.doctorList[index]?.docDegree,fee: vm3.doctorList[index]?.consultationFee.toString() ==
                                                      //   //     //     null
                                                      //   //     //     ? ""
                                                      //   //     //     : vm3.doctorList[index]?.consultationFee
                                                      //   //     //     .toString(),companyNo: vm3.doctorList[index]?.companyNo.toString() == null
                                                      //   //     //     ? ""
                                                      //   //     //     : vm3.doctorList[index]?.companyNo.toString(),orgNo: vm3.doctorList[index]?.ogNo.toString() == null
                                                      //   //     //     ? ""
                                                      //   //     //     : vm3.doctorList[index]?.ogNo.toString(),
                                                      //   //
                                                      //   //     );
                                                      //   //   }));
                                                      //   // },
                                                      //   child: Material(
                                                      //     elevation: 0  ,
                                                      //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                      //     color: HexColor("#354291"),
                                                      //     child: SizedBox(
                                                      //       width: deviceWidth*.4,
                                                      //       height: MediaQuery.of(context).size.width>650 ? 32 : 27,
                                                      //       child: Center(
                                                      //         child: Text("Rebook",style:  GoogleFonts.poppins(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w600),),
                                                      //       ),
                                                      //     ),
                                                      //   ),
                                                      // ),
                                                      // SizedBox(width: MediaQuery.of(context).size.width>650 ? 20 : 15,),
                                                      InkWell(
                                                        onTap: () async{
                                                          print('ButtonPredfromAppointmentscreen');
                                                          final file=await _createPdfFileFromString(vm2.previousAppointmentList[index].prescriptionNo.toString(),vm2.previousAppointmentList[index].companyAlias.toString());
                                                          Navigator.push(context, PageTransition(
                                                            type: PageTransitionType.rightToLeft,
                                                            child:PdfViewerScreen(file),
                                                          ),);
                                                        },
                                                        child: Material(
                                                          elevation: 0  ,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                                          color:vm2.previousAppointmentList[index].prescriptionNo==null || vm2.previousAppointmentList[index].companyAlias==null? HexColor("#99A0C8"):HexColor("#354291"),
                                                          child: SizedBox(
                                                            width: double.infinity,
                                                            height: MediaQuery.of(context).size.width>650 ? 35 : 28,
                                                            child: Center(
                                                              child: Text("View Prescription",style:  GoogleFonts.poppins(color: Colors.white,fontSize: 12,fontWeight: FontWeight.w600),),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ]
                                      );
                                    }),
                              ),
                            ],
                          )

                      ),
                    ),
                  ),



                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class DateUtil {
  static const DATE_FORMAT = 'yyyy-MM-dd ';
  String formattedDate(DateTime dateTime) {
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}

class TimeUtil {
  static const DATE_FORMAT = 'HH:mm:ss';
  String formattedDate(DateTime dateTime) {
    print('dateTime ($dateTime)');
    return DateFormat(DATE_FORMAT).format(dateTime);
  }
}