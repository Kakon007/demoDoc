import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_rectangular_button.dart';

class CustomCard extends StatelessWidget {
  String titleText;
  String subTitleText;
  String countText;
  CustomCard(@required this.titleText,@required this.subTitleText,@required this.countText,);
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 40,
      width: 265,
      height: 120,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child:Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 100,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.asset("assets/images/dummyimg.png")),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titleText,style: GoogleFonts.poppins(fontSize: 12,fontWeight: FontWeight.bold,),textAlign:TextAlign.start),
                    SizedBox(height: 3,),
                    Text(subTitleText,style: GoogleFonts.poppins(fontSize: 8),textAlign:TextAlign.start),
                    SizedBox(height: 3,),
                    Row(
                      children: [
                        CircleAvatar(
                          minRadius: 3,
                          backgroundColor: HexColor("#1EE573"),
                        ),
                        SizedBox(width: 3,),
                        Text(countText,style:  GoogleFonts.poppins(fontSize: 8,),),

                      ],
                    ),
                    SizedBox(height: 10,),
                    Material(
                      elevation: 0  ,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      color: HexColor("#354291"),
                      child: SizedBox(
                        width: 130,
                        height: 30,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Get An Appointment",style:  GoogleFonts.poppins(color: Colors.white,fontSize: 11,fontWeight: FontWeight.w600),),
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