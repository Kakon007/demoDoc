import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:myhealthbd_app/features/appointments/models/available_slots_model.dart';
import 'package:myhealthbd_app/features/appointments/models/doctor_info_model.dart';
import 'package:myhealthbd_app/features/appointments/view/widgets/add_patient.dart';
import 'package:myhealthbd_app/features/appointments/view/widgets/no_available_slots.dart';
import 'package:myhealthbd_app/features/appointments/view/widgets/sign_required_propmt.dart';
import 'package:myhealthbd_app/features/appointments/view_model/available_slot_view_model.dart';
import 'package:myhealthbd_app/features/auth/view_model/accessToken_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/user_image_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class AppointmentScreen extends StatefulWidget {
  String doctorNo;
  String companyNo;
  String orgNo;
  String hospitalName;
  String phoneNumber;

  AppointmentScreen(
      {this.companyNo,
      this.doctorNo,
      this.orgNo,
      this.hospitalName,
      this.phoneNumber});

  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  DateTime pickedAppointDate;
  DateTime pickedAppointDate2;
  bool isClicked;
  String status;

  Future<Null> selectAppointDate(BuildContext context) async {
    final DateTime date = await showDatePicker(
      context: context,
      builder: (BuildContext context, Widget child) {
        return Container(
          child: Theme(
            data: ThemeData.light().copyWith(
              primaryColor: AppTheme.appbarPrimary,
              accentColor: AppTheme.appbarPrimary,
              colorScheme: ColorScheme.light(primary: AppTheme.appbarPrimary),
              buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
            ),
            child: child,
          ),
        );
      },
      initialDate: pickedAppointDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (date != null && date != pickedAppointDate) {
      setState(() {
        pickedAppointDate = date;
      });
    }
    if (pickedAppointDate != pickedAppointDate2) {
      var vm = Provider.of<AvailableSlotsViewModel>(context, listen: false);
      Future.delayed(Duration.zero, () async {
        await vm.getSlotGenerateInfo(
            date, widget.companyNo, widget.doctorNo, widget.orgNo);
        if (vm.slotGenerateMessage == 'Slot Successfully Generated!') {
          await vm.getSlots(pickedAppointDate, widget.companyNo,
              widget.doctorNo, widget.orgNo);
        }
        pickedAppointDate2 = pickedAppointDate;
        length = vm.slotList.length;
        selectedCard = -1;
        isSelected = false;
      });
    }
  }

  int selectedCard = -1;
  bool isSelected;
  var slotNo;
  var slotSl;
  var appointDate;
  var shiftdtlNo;
  var shift;
  var startTime;
  var endTime;
  var durationMin;
  var extraSlot;
  var slotSplited;
  var ssCreatedOn;
  var ssCreator;
  var remarks;
  var appointStatus;
  bool isLoading = false;
  bool isStatusOk;
  AvailableSlotModel slotItem;
  var selectedPatientType = "";
  var selectedConsultationType = "";
  String color = "#EAEBED";

  // var accessToken;
  // Future<void> accesstoken() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   accessToken = prefs.getString('accessToken');
  // }
  loadLogo(String image) {
    Uint8List _bytesImage = Base64Decoder().convert(image);
    return Image.memory(
      _bytesImage,
      fit: BoxFit.contain,
      gaplessPlayback: true,
    );
  }

  var length;
  Obj doctorInformation;

  @override
  void initState() {
    status = "Not Ok";
    isClicked = false;
    isStatusOk = false;
    isSelected = false;
    pickedAppointDate = DateTime.now();
    pickedAppointDate2 = DateTime.now();
    var vm = Provider.of<AvailableSlotsViewModel>(context, listen: false);
    doctorInformation = null;
    Future.delayed(Duration.zero, () async {
      await Provider.of<UserImageViewModel>(context, listen: false).userImage();
      var vm = Provider.of<AvailableSlotsViewModel>(context, listen: false);
      await vm.getDoctorInfo(widget.companyNo, widget.doctorNo, widget.orgNo);
      await vm.getSlotGenerateInfo(
          pickedAppointDate, widget.companyNo, widget.doctorNo, widget.orgNo);
      if (vm.slotGenerateMessage == 'Slot Successfully Generated!') {
        await vm.getSlots(
            pickedAppointDate, widget.companyNo, widget.doctorNo, widget.orgNo);
      }

      doctorInformation = vm.doctorInfo;
      length = vm.slotList.length;
      vm.getButtonColor("#141D53", "#FFFFFF", "#00FFFFFF", "#8389A9");
      vm.getAppointType(true, false);
    });
  }

  BorderRadiusGeometry radius = BorderRadius.only(
    topLeft: Radius.circular(25.0),
    topRight: Radius.circular(25.0),
  );
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    // print('shakil ${MediaQuery.of(context).size.width}');
    bool isMobile = Responsive.isMobile(context);
    int _crossAxisCount = width > 850
        ? 6
        : width <= 850 && width >= 650
            ? 5
            : width > 360
                ? 4
                : width <= 360 && width >= 300
                    ? 3
                    : 2;
    double _crossAxisSpacing = isTablet
            ? 12
            : MediaQuery.of(context).size.height > 550
                ? 8
                : 3,
        _mainAxisSpacing = isTablet
            ? 12
            : MediaQuery.of(context).size.height > 550
                ? 8
                : 3,
        _aspectRatio = MediaQuery.of(context).size.height > 650 ? .6 : .5;
    var height = MediaQuery.of(context).size.height;
    var vm = Provider.of<AvailableSlotsViewModel>(context, listen: true);
    var accessTokenVM =
        Provider.of<AccessTokenProvider>(context, listen: false);
    var userImageVm = Provider.of<UserImageViewModel>(context, listen: true);
    var profileImage = userImageVm.details?.photo ?? "";
    //length= vm.slotList.length;
    // var doctorDegree=  doctorInformation?.docDegree == null
    //     ? ""
    //     : vm.doctorInfo?.docDegree;
    // var jobTitle=   doctorInformation?.jobtitle??"";
    var photo = doctorInformation?.doctorPhoto ?? "";
    // print('jobtitle $jobTitle');
    // print('degress $doctorDegree');
    var doctorDetails = doctorInformation?.jobtitle == null
        ? doctorInformation?.docDegree == null
            ? ''
            : "${doctorInformation?.docDegree}"
        : doctorInformation?.docDegree == null
            ? "${doctorInformation?.jobtitle}"
            : '${doctorInformation?.jobtitle}, ${doctorInformation?.docDegree}';
    var consultFee = doctorInformation?.consultationFee ?? '';
    List<Items> list = vm.slotList;
    var spaceBetween = SizedBox(
      height: 10,
    );
    String _formatDate = DateFormat("dd/MM/yyyy").format(pickedAppointDate);
    var appointmentDate = Row(
      children: [
        GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  constraints: BoxConstraints(minHeight: 20),
                  //height: 20.0,
                  // width: MediaQuery.of(context).size.width,
                  child: Row(
                    children: [
                      Text("Select Date",
                          style: GoogleFonts.poppins(
                              fontSize: isTablet ? 18 : 14,
                              fontWeight: FontWeight.w600)),
                    ],
                  )),
              spaceBetween,
              Container(
                height: 45.0,
                width: isTablet
                    ? width * .94
                    : width <= 330
                        ? MediaQuery.of(context).size.width * .87
                        : MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: HexColor("#D6DCFF")),
                    borderRadius: BorderRadius.circular(8)),
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$_formatDate",
                        style: GoogleFonts.poppins(
                            color: AppTheme.signInSignUpColor,
                            fontSize: isTablet ? 18 : 13.0),
                      ),
                      Container(
                          height: 18,
                          child: Icon(
                            Icons.calendar_today_outlined,
                            color: AppTheme.appbarPrimary,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
          key: Key('selectAppointmentDateKey'),
          onTap: () {
            selectAppointDate(context);
          },
        ),
      ],
    );
    var proceedButton = vm.isLoading == true
        ? SizedBox()
        : Container(
            width: MediaQuery.of(context).size.width,
            height: isTablet ? 60 : 45,
            child: AbsorbPointer(
              absorbing: isSelected == false ? true : false,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                color: isSelected == false
                    ? HexColor("#969EC8")
                    : AppTheme.appbarPrimary,
                onPressed: () async {
                  if (accessTokenVM.accessToken != null) {
                    await vm.getSlotStatus(
                        slotNo.toString(), widget.companyNo, widget.orgNo);
                    setState(() {
                      isClicked = true;
                      if (vm.slotStatus == "OK")
                        setState(() {
                          isStatusOk = true;
                          vm.getAppointInfo(
                              widget.doctorNo,
                              vm.doctorInfo.doctorName,
                              appointDate,
                              shiftdtlNo.toString(),
                              shift.toString(),
                              slotNo.toString(),
                              slotSl.toString(),
                              startTime,
                              endTime,
                              durationMin.toString(),
                              extraSlot.toString(),
                              slotSplited.toString(),
                              ssCreatedOn,
                              ssCreator.toString(),
                              remarks,
                              appointStatus.toString(),
                              widget.companyNo,
                              widget.orgNo,
                              widget.phoneNumber);
                        });
                    });
                  } else {
                    signInRequired(context);
                  }
                },
                key: Key('proceedButtonKey'),
                textColor: Colors.white,
                child: Text(
                  "Proceed",
                  style: GoogleFonts.poppins(
                      fontSize: isTablet
                          ? 20
                          : height <= 600
                              ? 15
                              : 15,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
    var selectType = Padding(
      padding:
          EdgeInsets.only(left: isTablet ? 15 : 0, right: isTablet ? 15 : 0),
      child: Container(
        height: isTablet ? 90 : 65.0,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: HexColor("#E9ECFE"),
            borderRadius: BorderRadius.circular(13)),
        child: Padding(
          padding: EdgeInsets.only(
              left: isTablet ? 30 : 10.0, right: isTablet ? 30 : 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                child: Container(
                  decoration: BoxDecoration(
                      color: HexColor(vm.forMeBackColor),
                      borderRadius: BorderRadius.circular(10)),
                  height:
                      isTablet ? 60 : MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width * .4,
                  child: Center(
                      child: Text(
                    "For Me",
                    key: Key('forMeKey'),
                    style: GoogleFonts.poppins(
                        fontSize: isTablet ? 20 : 15,
                        color: HexColor(vm.forMeTextColor)),
                  )),
                ),
                onTap: () {
                  vm.getAppointType(true, false);
                  if (vm.addPatient == false) {
                    vm.getButtonColor(
                        "#141D53", "#FFFFFF", "#00FFFFFF", "#8389A9");
                  }
                },
              ),
              InkWell(
                child: Container(
                    decoration: BoxDecoration(
                        color: HexColor(vm.addPatientBackColor),
                        borderRadius: BorderRadius.circular(10)),
                    height: isTablet
                        ? 65
                        : MediaQuery.of(context).size.height * 0.06,
                    width: MediaQuery.of(context).size.width * .4,
                    child: Center(
                        child: Text(
                      "Add patient",
                      key: Key('addPatientKey'),
                      style: GoogleFonts.poppins(
                          fontSize: isTablet ? 20 : 15,
                          color: HexColor(vm.addPatientTextColor)),
                    ))),
                onTap: () {
                  vm.getAppointType(false, true);
                  if (vm.forMe == false) {
                    vm.getButtonColor(
                        "#00FFFFFF", "#8389A9", "#141D53", "#FFFFFF");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
    var doctorCard = doctorInformation == null
        ? Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(
                  left: isTablet ? 30 : 20.0,
                  right: isTablet ? 30 : 20,
                  top: 10),
              child: Container(
                //constraints: BoxConstraints(minHeight: isTablet? 140 : 120,),
                height: isTablet ? 140 : 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Shimmer.fromColors(
                  baseColor: Colors.grey[300],
                  highlightColor: Colors.white,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[300],
                    ),
                    height: isTablet ? 140 : 120,
                  ),
                ),
              ),
            ),
          )
        : Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.only(
                  left: isTablet ? 30 : 20.0,
                  right: isTablet ? 30 : 20,
                  top: 10),
              child: Container(
                //constraints: BoxConstraints(minHeight: isTablet? 140 : 120,),
                height: isTablet
                    ? 140
                    : width < 330
                        ? 90
                        : 120,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: HexColor("#FFFFFF"),
                    boxShadow: [
                      BoxShadow(
                        color: HexColor("#0D1231").withOpacity(0.08),
                        spreadRadius: 10,
                        blurRadius: 15,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ]),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            //constraints: BoxConstraints(minHeight: isTablet? 140 : 120,),
                            height: isTablet ? 140 : 80,
                            width: isTablet
                                ? 180
                                : width < 330
                                    ? 90
                                    : 80,
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              child: photo != ""
                                  ? loadLogo(vm.doctorInfo.doctorPhoto)
                                  : Image.asset(
                                      "assets/icons/dct.png",
                                      fit: BoxFit.contain,
                                    ),
                            ),
                          ),
                          SizedBox(
                            width: width < 350 ? 15 : 20,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: isTablet
                                    ? width * .65
                                    : width < 330
                                        ? 170
                                        : 185,
                                child: Text(
                                  doctorInformation?.specializationName ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      height: 1.5,
                                      color: AppTheme.appbarPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isTablet
                                          ? 18
                                          : width < 330
                                              ? 13
                                              : 15),
                                ),
                              ),
                              Container(
                                  width: width < 330 ? width * .54 : width * .5,
                                  child: Text(
                                    doctorInformation?.doctorName ?? "",
                                    style: GoogleFonts.poppins(
                                        fontSize: isTablet
                                            ? 18
                                            : width < 330
                                                ? 11
                                                : 12,
                                        fontWeight: FontWeight.w700),
                                  )),
                              SizedBox(
                                height: 1,
                              ),
                              Container(
                                width: isTablet
                                    ? width * .65
                                    : width < 330
                                        ? 170
                                        : 185,
                                child: Text(doctorDetails,
                                    //jobTitle==""? "": doctorDegree=='' ? jobTitle :'$jobTitle, ' + doctorDegree,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.poppins(
                                        height: 1.2,
                                        fontSize: isTablet ? 15 : 11)),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          );

    return Scaffold(
        resizeToAvoidBottomInset: width <= 360 ? true : true,
        //key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(
            "Book your appointment",
            key: Key('bookYourAppointmentAppbarKey'),
            style: GoogleFonts.poppins(fontSize: isTablet ? 20 : 15),
          ),
        ),
        //drawer: Drawer(),
        body: width > 650
            ? Stack(
                children: <Widget>[
                  Positioned(
                    child: Padding(
                      padding: EdgeInsets.only(top: 90.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
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
                        child: Padding(
                            padding:
                                EdgeInsets.only(left: 20.0, right: 20, top: 60),
                            child: isStatusOk == true
                                ? Column(
                                    children: [
                                      isTablet
                                          ? SizedBox(
                                              height: 40,
                                            )
                                          : SizedBox(),
                                      selectType,
                                      AddPatient(
                                          doctorNo: widget.doctorNo,
                                          companyNo: widget.companyNo,
                                          orgNo: widget.orgNo,
                                          hospitalName: widget.hospitalName),
                                    ],
                                  )
                                : Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      isTablet
                                          ? SizedBox(
                                              height: 40,
                                            )
                                          : SizedBox(),
                                      appointmentDate,
                                      spaceBetween,
                                      Text("Available Slots",
                                          style: GoogleFonts.poppins(
                                              fontSize: isTablet ? 18 : 14,
                                              fontWeight: FontWeight.w600)),

                                      spaceBetween,
                                      vm.isLoading == true
                                          ? Center(
                                              child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      AppTheme.appbarPrimary),
                                            ))
                                          : Expanded(
                                              child: length == 0
                                                  ? NoAvailableSlots()
                                                  : GridView.builder(
                                                      scrollDirection:
                                                          Axis.horizontal,
                                                      itemCount: list.length,
                                                      itemBuilder:
                                                          (context, index) =>
                                                              GestureDetector(
                                                        onTap: () {
                                                          setState(() {
                                                            isSelected = true;
                                                            selectedCard =
                                                                index;
                                                            slotNo = vm
                                                                .slotList[index]
                                                                .slotNo;
                                                            print(slotNo);
                                                            slotSl = vm
                                                                .slotList[index]
                                                                .slotSl;
                                                            appointDate = DateFormat(
                                                                    "yyyy-MM-dd")
                                                                .format(DateTime.parse(vm
                                                                        .slotList[
                                                                            index]
                                                                        .appointDate
                                                                        .toString())
                                                                    .toLocal());
                                                            shiftdtlNo = vm
                                                                .slotList[index]
                                                                .shiftdtlNo;
                                                            shift = vm
                                                                .slotList[index]
                                                                .shift;
                                                            startTime = vm
                                                                .slotList[index]
                                                                .startTime;
                                                            endTime = vm
                                                                .slotList[index]
                                                                .endTime;
                                                            durationMin = vm
                                                                .slotList[index]
                                                                .durationMin;
                                                            extraSlot = vm
                                                                .slotList[index]
                                                                .extraSlot;
                                                            slotSplited = vm
                                                                .slotList[index]
                                                                .slotSplited;
                                                            ssCreatedOn = DateFormat(
                                                                    "yyyy-MM-dd")
                                                                .format(DateTime.parse(vm
                                                                        .slotList[
                                                                            index]
                                                                        .ssCreatedOn
                                                                        .toString())
                                                                    .toLocal());
                                                            ssCreator = vm
                                                                .slotList[index]
                                                                .ssCreator;
                                                            remarks = vm
                                                                .slotList[index]
                                                                .remarks;
                                                            appointStatus = vm
                                                                .slotList[index]
                                                                .appointStatus;
                                                          });
                                                        },
                                                        key: Key(
                                                            'availableSlot$index'),
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .bottomRight,
                                                                stops: [
                                                                  1.0,
                                                                  1.0
                                                                ],
                                                                colors: [
                                                                  isSelected ==
                                                                          false
                                                                      ? HexColor(
                                                                          "#8592E5")
                                                                      : selectedCard ==
                                                                              index
                                                                          ? HexColor(
                                                                              "#8592E5")
                                                                          : HexColor(
                                                                              "#C1C8F1"),
                                                                  isSelected ==
                                                                          false
                                                                      ? HexColor(
                                                                          "#F6F8FB")
                                                                      : selectedCard ==
                                                                              index
                                                                          ? HexColor(
                                                                              "#F6F8FB")
                                                                          : HexColor(
                                                                              "#FAFBFC"),
                                                                ]),
                                                            border: Border.all(
                                                              color: isSelected ==
                                                                      false
                                                                  ? HexColor(
                                                                      "#8592E5")
                                                                  : selectedCard ==
                                                                          index
                                                                      ? HexColor(
                                                                          "#8592E5")
                                                                      : HexColor(
                                                                          "#C1C8F1"),
                                                              width: 1,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Serial - " +
                                                                        list[index]
                                                                            .slotSl
                                                                            .toString(),
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: isTablet
                                                                            ? 18
                                                                            : MediaQuery.of(context).size.height > 650
                                                                                ? 14
                                                                                : MediaQuery.of(context).size.height > 550
                                                                                    ? 12
                                                                                    : 10,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: isSelected == false
                                                                            ? HexColor("#354291")
                                                                            : selectedCard == index
                                                                                ? HexColor("#354291")
                                                                                : HexColor("#999FC7")),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                flex: 1,
                                                                child:
                                                                    Container(
                                                                  alignment:
                                                                      Alignment
                                                                          .center,
                                                                  child: Text(
                                                                    "Time : " +
                                                                        DateFormat("hh:mm a")
                                                                            .format(DateTime.parse(list[index].startTime.toString()).toLocal()),
                                                                    style: GoogleFonts.poppins(
                                                                        fontSize: isTablet
                                                                            ? 18
                                                                            : MediaQuery.of(context).size.height > 650
                                                                                ? 14
                                                                                : MediaQuery.of(context).size.height > 550
                                                                                    ? 12
                                                                                    : 10,
                                                                        fontWeight: FontWeight.w600,
                                                                        color: Colors.white),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      gridDelegate:
                                                          SliverGridDelegateWithFixedCrossAxisCount(
                                                        crossAxisCount:
                                                            _crossAxisCount,
                                                        crossAxisSpacing:
                                                            _crossAxisSpacing,
                                                        mainAxisSpacing:
                                                            _mainAxisSpacing,
                                                        childAspectRatio:
                                                            _aspectRatio,
                                                      ),
                                                    )),
                                      //  AvailableSlots(selectDate: _formatDate,doctorNo: widget.doctorNo, orgNo: widget.orgNo,companyNo: widget.companyNo,),
                                      spaceBetween,
                                      vm.slotList.length == 0
                                          ? SizedBox()
                                          : proceedButton,
                                      spaceBetween,
                                    ],
                                  )),
                      ),
                    ),
                  ),
                  doctorCard,
                ],
              )
            : ListView(
                children: [
                  Stack(
                    children: <Widget>[
                      Positioned(
                        child: Padding(
                          padding: EdgeInsets.only(top: 90.0),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: width <= 330
                                ? MediaQuery.of(context).size.height * .7
                                : MediaQuery.of(context).size.height * .8,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(25),
                                    topRight: Radius.circular(25)),
                                color: HexColor("#FFFFFF"),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        HexColor("#0D1231").withOpacity(0.08),
                                    spreadRadius: 10,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ]),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: 20.0, right: 20, top: 60),
                                child: isStatusOk == true
                                    ? Container(
                                        constraints: BoxConstraints(
                                          maxHeight: width <= 330
                                              ? MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .5
                                              : MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  .6,
                                        ),

                                        //   height: MediaQuery.of(context).size.height*.76,
                                        child: Column(
                                          children: [
                                            isTablet
                                                ? SizedBox(
                                                    height: 40,
                                                  )
                                                : SizedBox(
                                                    height: 8,
                                                  ),
                                            selectType,
                                            AddPatient(
                                                doctorNo: widget.doctorNo,
                                                companyNo: widget.companyNo,
                                                orgNo: widget.orgNo,
                                                hospitalName:
                                                    widget.hospitalName),
                                          ],
                                        ),
                                      )
                                    : SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            isTablet
                                                ? SizedBox(
                                                    height: 40,
                                                  )
                                                : SizedBox(
                                                    height: 10,
                                                  ),
                                            appointmentDate,
                                            spaceBetween,
                                            Text("Available Slots",
                                                style: GoogleFonts.poppins(
                                                    fontSize:
                                                        isTablet ? 18 : 14,
                                                    fontWeight:
                                                        FontWeight.w600)),

                                            spaceBetween,
                                            vm.isLoading == true
                                                ? Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                    valueColor:
                                                        AlwaysStoppedAnimation<
                                                                Color>(
                                                            AppTheme
                                                                .appbarPrimary),
                                                  ))
                                                : Container(
                                                    constraints: BoxConstraints(
                                                      maxHeight: width <= 360
                                                          ? MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .32
                                                          : MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              .47,
                                                    ),
                                                    //  height: width<=360?  MediaQuery.of(context).size.height*.32: MediaQuery.of(context).size.height*.45,
                                                    child: length == 0
                                                        ? NoAvailableSlots()
                                                        : GridView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount:
                                                                list.length,
                                                            itemBuilder: (context,
                                                                    index) =>
                                                                GestureDetector(
                                                              onTap: () {
                                                                setState(() {
                                                                  isSelected =
                                                                      true;
                                                                  selectedCard =
                                                                      index;
                                                                  slotNo = vm
                                                                      .slotList[
                                                                          index]
                                                                      .slotNo;
                                                                  print(slotNo);
                                                                  slotSl = vm
                                                                      .slotList[index]
                                                                      .slotSl;
                                                                  appointDate = DateFormat("yyyy-MM-dd").format(DateTime.parse(vm
                                                                          .slotList[index]
                                                                          .appointDate
                                                                          .toString())
                                                                      .toLocal());
                                                                  shiftdtlNo = vm
                                                                      .slotList[index]
                                                                      .shiftdtlNo;
                                                                  shift = vm
                                                                      .slotList[index]
                                                                      .shift;
                                                                  startTime = vm
                                                                      .slotList[index]
                                                                      .startTime;
                                                                  endTime = vm
                                                                      .slotList[index]
                                                                      .endTime;
                                                                  durationMin = vm
                                                                      .slotList[index]
                                                                      .durationMin;
                                                                  extraSlot = vm
                                                                      .slotList[index]
                                                                      .extraSlot;
                                                                  slotSplited = vm
                                                                      .slotList[index]
                                                                      .slotSplited;
                                                                  ssCreatedOn = DateFormat("yyyy-MM-dd").format(DateTime.parse(vm
                                                                          .slotList[index]
                                                                          .ssCreatedOn
                                                                          .toString())
                                                                      .toLocal());
                                                                  ssCreator = vm
                                                                      .slotList[index]
                                                                      .ssCreator;
                                                                  remarks = vm
                                                                      .slotList[index]
                                                                      .remarks;
                                                                  appointStatus = vm
                                                                      .slotList[index]
                                                                      .appointStatus;
                                                                });
                                                              },
                                                              key: Key(
                                                                  'availableSlot$index'),
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  gradient: LinearGradient(
                                                                      begin: Alignment
                                                                          .bottomRight,
                                                                      stops: [
                                                                        1.0,
                                                                        1.0
                                                                      ],
                                                                      colors: [
                                                                        isSelected ==
                                                                                false
                                                                            ? HexColor("#8592E5")
                                                                            : selectedCard == index
                                                                                ? HexColor("#8592E5")
                                                                                : HexColor("#C1C8F1"),
                                                                        isSelected ==
                                                                                false
                                                                            ? HexColor("#F6F8FB")
                                                                            : selectedCard == index
                                                                                ? HexColor("#F6F8FB")
                                                                                : HexColor("#FAFBFC"),
                                                                      ]),
                                                                  border: Border
                                                                      .all(
                                                                    color: isSelected ==
                                                                            false
                                                                        ? HexColor(
                                                                            "#8592E5")
                                                                        : selectedCard ==
                                                                                index
                                                                            ? HexColor("#8592E5")
                                                                            : HexColor("#C1C8F1"),
                                                                    width: 1,
                                                                  ),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                ),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          "Serial - " +
                                                                              list[index].slotSl.toString(),
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: isTablet
                                                                                  ? 18
                                                                                  : MediaQuery.of(context).size.height > 650
                                                                                      ? 14
                                                                                      : MediaQuery.of(context).size.height > 550
                                                                                          ? 12
                                                                                          : 10,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: isSelected == false
                                                                                  ? HexColor("#354291")
                                                                                  : selectedCard == index
                                                                                      ? HexColor("#354291")
                                                                                      : HexColor("#999FC7")),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      flex: 1,
                                                                      child:
                                                                          Container(
                                                                        alignment:
                                                                            Alignment.center,
                                                                        child:
                                                                            Text(
                                                                          "Time : " +
                                                                              DateFormat("hh:mm a").format(DateTime.parse(list[index].startTime.toString()).toLocal()),
                                                                          style: GoogleFonts.poppins(
                                                                              fontSize: isTablet
                                                                                  ? 18
                                                                                  : MediaQuery.of(context).size.height > 650
                                                                                      ? 14
                                                                                      : MediaQuery.of(context).size.height > 550
                                                                                          ? 12
                                                                                          : 10,
                                                                              fontWeight: FontWeight.w600,
                                                                              color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                            gridDelegate:
                                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount:
                                                                  _crossAxisCount,
                                                              crossAxisSpacing:
                                                                  _crossAxisSpacing,
                                                              mainAxisSpacing:
                                                                  _mainAxisSpacing,
                                                              childAspectRatio:
                                                                  _aspectRatio,
                                                            ),
                                                          ),
                                                  ),
                                            //  AvailableSlots(selectDate: _formatDate,doctorNo: widget.doctorNo, orgNo: widget.orgNo,companyNo: widget.companyNo,),
                                            spaceBetween,
                                            vm.slotList.length == 0
                                                ? SizedBox()
                                                : proceedButton,
                                            spaceBetween,
                                          ],
                                        ),
                                      )),
                          ),
                        ),
                      ),
                      doctorCard,
                    ],
                  ),
                ],
              ));
  }

  void signInRequired(BuildContext context) {
    showGeneralDialog(
      barrierLabel: "Label",
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return SignInRequired();
      },
    );
  }
}
