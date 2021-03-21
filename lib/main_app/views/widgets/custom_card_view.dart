import 'package:flutter/material.dart';
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
      height: 110,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child:Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 95,
                  width: 90,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Image.asset("assets/images/dum2.png")),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(titleText,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,),textAlign:TextAlign.start),
                    SizedBox(height: 3,),
                    Text(subTitleText,style: TextStyle(fontSize: 8,fontWeight: FontWeight.bold),textAlign:TextAlign.start),
                    SizedBox(height: 3,),
                    Row(
                      children: [
                        CircleAvatar(
                          minRadius: 3,
                          backgroundColor: HexColor("#1DBF6D"),
                        ),
                        SizedBox(width: 3,),
                        Text(countText,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),),

                      ],
                    ),
                    SizedBox(height: 10,),
                    Material(
                      elevation: 2  ,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      color: HexColor("#354291"),
                      child: SizedBox(
                        width: 130,
                        height: 30,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Get An Appointment",style: TextStyle(color: Colors.white,fontSize: 11),),
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