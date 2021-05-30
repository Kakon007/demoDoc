import 'package:flutter/material.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_rectangular_button.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
class CustomCardPat extends StatelessWidget {
  String titleText;
  String subTitleText;
  String countText;
   String name;
   int lastTime;
  //CountdownTimerController controller;
  CustomCardPat(@required this.titleText,@required this.subTitleText,@required this.countText,@required this.name,this.lastTime);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left:15.0,right: 15),
      child: Container(

        //height: 40,
        width: double.infinity,
        height: 125,
        child: Card(
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child:Row(
            children: [
              Container(
                width: 8,
                height: double.infinity,
                color: HexColor("#8592E5"),

              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child:
                // Stack(
                //   children:[ Container(
                //       child: Image.asset("assets/images/clocknew.png"),
                //   ),
                //     Padding(
                //       padding: const EdgeInsets.only(top:35.0,left: 14,bottom:20),
                //       child: Column(
                //         children: [
                //           Text("20:10:33",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                //           Text("Hours Left",style: TextStyle(fontSize: 10),)
                //         ],
                //       ),
                //     )
                //   ]
                // ),

                CountdownTimer(
                  //controller: controller,
                  endTime: lastTime!=null?lastTime:DateTime.now().millisecondsSinceEpoch,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(top:8.0,right: 8,bottom: 8,left: 1),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(titleText,style: TextStyle(fontSize: 8,fontWeight: FontWeight.bold,color: Colors.black54),textAlign:TextAlign.start),
                      SizedBox(height: 8,),
                      Text(subTitleText,style: TextStyle(fontSize: 12,color: HexColor('#354291')),textAlign:TextAlign.start,),
                      SizedBox(height: 12,),
                      Row(
                        children: [
                          Container(
                            width: 3,
                            height: 20,
                            color: HexColor("#354291"),

                          ),
                          SizedBox(width: 2,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(countText,style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold,color: HexColor('#354291')),),
                              Text(name,style: TextStyle(fontSize: 8),),
                            ],
                          ),
                          SizedBox(width: 8,),
                          Material(
                            elevation: 2  ,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            color: HexColor("#354291"),
                            child: SizedBox(
                              width: 130,
                              height: 30,
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Text("View All Appointment",style: TextStyle(color: Colors.white,fontSize: 11),),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10,),
                      // Material(
                      //   elevation: 2  ,
                      //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      //   color: HexColor("#354291"),
                      //   child: SizedBox(
                      //     width: 130,
                      //     height: 30,
                      //     child: Center(
                      //       child: Padding(
                      //         padding: const EdgeInsets.all(8.0),
                      //         child: Text("Get An Appointment",style: TextStyle(color: Colors.white,fontSize: 11),),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          elevation:1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color:  HexColor("#8592E5").withOpacity(0.3),
              width: 1,
            ),
          ),

          shadowColor: HexColor("#354291").withOpacity(0.5),
        ),
      ),
    );
  }
}