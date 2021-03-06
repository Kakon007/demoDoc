import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/features/find_doctor/view/find_doctor_screen.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:recase/recase.dart';

class CustomCard extends StatelessWidget {
  Uint8List image;
  Uint8List backgroundImage;
  String titleText;
  String addressText;
  String countText;
  String phoneText;
  String emailText;
  String logo;
  String companyNo;
  String orgNo;
  String id;
  String index;
  CustomCard(@required this.image,@required this.backgroundImage,@required this.titleText,@required this.addressText,@required this.countText,this.phoneText,this.emailText,this.logo,this.companyNo,  this.orgNo,this.id,this.index);
  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var width = MediaQuery.of(context).size.width;
    return Container(
      //height: 40,
      width: width<=1250 && width>=1000 ? 380 : width<=999 && width>=650? 340 :300,
      height:width<=1250 && width>=1000 ? 175 : width<=999 && width>=650? 155 :135,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child:Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  height: width<=1250 && width>=1000 ? 140 : width<=999 && width>=650?  115 : 100,
                  width: width<=1250 && width>=1000 ? 110 : width<=999 && width>=650?  105 : 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.memory(image,gaplessPlayback: true,)),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: isTablet? 90 : 70,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(titleText,maxLines:2,overflow: TextOverflow.ellipsis,style: GoogleFonts.poppins(fontSize: width<=1250 && width>=1000 ? 16 : width<=999 && width>=650?  14 :12,fontWeight: FontWeight.bold,),textAlign:TextAlign.start),
                          SizedBox(height: isTablet? 8 : 3,),
                          Text(addressText,maxLines:1,overflow:TextOverflow.ellipsis,style: GoogleFonts.poppins(fontSize: width<=1250 && width>=1000 ? 14 : width<=999 && width>=650?  12 : 8),textAlign:TextAlign.start),
                        ],
                      ),
                    ),
                    // SizedBox(height: 3,),
                    // Row(
                    //   children: [
                    //     CircleAvatar(
                    //       minRadius: 3,
                    //       backgroundColor: HexColor("#1EE573"),
                    //     ),
                    //     SizedBox(width: 3,),
                    //     Text(countText,style:  GoogleFonts.poppins(fontSize: 8,),),
                    //
                    //   ],
                    // ),
                    SizedBox(height: 5,),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>FindYourDoctorScreen(image,backgroundImage,titleText,phoneText,emailText,addressText,orgNo, companyNo , id)));
                      },
                      key: Key('dashboardGetAppointmentButtonKey$index'),
                      child: Material(
                        elevation: 0  ,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        color: HexColor("#354291"),
                        child: Container(

                          width: width<=1250 && width>=1000 ? 170 : width<=999 && width>=650?  155 : 170,
                          height: width<=1250 && width>=1000 ? 40 : width<=999 && width>=650? 35: 30,
                          child: Center(
                            child: Text("Get An Appointment",style:  GoogleFonts.poppins(color: Colors.white,fontSize: width<=1250 && width>=1000 ? 14 : width<=999 && width>=650?   13 :11,fontWeight: FontWeight.w600),),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        elevation:2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        shadowColor: HexColor("#354291").withOpacity(0.2),
      ),
    );
  }
}