import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';

import '../../../constant.dart';

class AppointSuccess extends StatefulWidget {
  String hospitalName;
  String appointDate;
  String doctorName;
  String slotSl;
  String startTime;

  AppointSuccess(
      {this.startTime,
      this.slotSl,
      this.hospitalName,
      this.doctorName,
      this.appointDate});

  @override
  _AppointSuccessState createState() => _AppointSuccessState();
}

class _AppointSuccessState extends State<AppointSuccess> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Align(
        alignment: Alignment.center,
        child: Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Container(
                height: 400,
                width: 355,
                //color: Colors.red,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 0, left: 20, right: 20),
                    child: Container(
                      height: 320,
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
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 50.0, left: 40,right: 40),
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Booked Successfully!",
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#037BB7"),
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Serial No ",
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "#" + widget.slotSl.toString(),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            color: HexColor("#037BB7")),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Date : ",
                                        style: GoogleFonts.poppins(),
                                      ),
                                      Text(
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(widget.appointDate
                                                    .toString())
                                                .toLocal()),
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        "Time : ",
                                        style: GoogleFonts.poppins(),
                                      ),
                                      Text(
                                        DateFormat("hh:mm a").format(
                                            DateTime.parse(
                                                    widget.startTime.toString())
                                                .toLocal()),
                                        style: GoogleFonts.poppins(),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    widget.doctorName,
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#037BB7"),
                                        fontSize: 13),
                                  ),
                                  Text(
                                    widget.hospitalName,
                                    style: GoogleFonts.poppins(
                                        color: HexColor("#037BB7"),
                                        fontSize: 13),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Text(
                                    " * Please proceed with the payment",
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                  Text(
                                    "    confirm this appointment",
                                    style: GoogleFonts.poppins(fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 8,
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
                                    style: GoogleFonts.poppins(
                                        color: Colors.white),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 295,
                //top: MediaQuery.of(context).size.height / 1.8,
                left: 100,
                right: 110,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: Constants.avatarRadius,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(
                          Radius.circular(Constants.avatarRadius)),
                      child: Image.asset(
                        "assets/images/confirm.png",
                        height: 90,
                        width: 90,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}