import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myhealthbd_app/features/appointments/view_model/available_slot_view_model.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/blog_logo_view_model.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/blog_view_model.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/hospital_list_view_model.dart';
import 'package:myhealthbd_app/features/hospitals/view_model/hospital_image_view_model.dart';
import 'package:myhealthbd_app/features/hospitals/view_model/hospital_logo_view_model.dart';
import 'package:myhealthbd_app/features/my_health/view_model/prescription_view_model.dart';
import 'package:myhealthbd_app/features/news/view_model/news_logo_view_model.dart';
import 'package:myhealthbd_app/features/news/view_model/news_view_model.dart';
import 'package:myhealthbd_app/features/hospitals/view_model/filter_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/change_password_view_model.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/features/videos/view_models/video_view_model.dart';
import 'package:myhealthbd_app/main_app/flavour/flavour_config.dart';
import 'package:myhealthbd_app/root.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/find_doctor/view_model/doctor_list_view_model.dart';
import 'features/hospitals/models/company_logo_model.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs= await SharedPreferences.getInstance();
  var accessToken = prefs.getString('accessToken');
  print(accessToken);
  var providers=[

    ChangeNotifierProvider<FilterViewModel>(
      create: (context)=>FilterViewModel()),
    ChangeNotifierProvider<HospitalListViewModel>(create: (context) => HospitalListViewModel()),
    ChangeNotifierProvider<NewsViewModel>(create: (context) => NewsViewModel()),
    ChangeNotifierProvider<DoctorListViewModel>(
        create: (context)=>DoctorListViewModel()),
    ChangeNotifierProvider<AvailableSlotsViewModel>(
        create: (context)=>AvailableSlotsViewModel()),
    ChangeNotifierProvider<PrescriptionListViewModel>(create: (context) => PrescriptionListViewModel()),
    ChangeNotifierProvider<VideoViewModel>(create: (context) => VideoViewModel()),
    ChangeNotifierProvider< UserDetailsViewModel>(create: (context) =>  UserDetailsViewModel()),
    ChangeNotifierProvider< BLogViewModel>(create: (context) =>  BLogViewModel()),
    ChangeNotifierProvider<HospitalLogoViewModel>(create: (context) =>  HospitalLogoViewModel()),
    ChangeNotifierProvider<HospitalImageViewModel>(create: (context) =>  HospitalImageViewModel()),
    ChangeNotifierProvider<NewsLogoViewModel>(create: (context) =>  NewsLogoViewModel()),
    ChangeNotifierProvider<BLogLogoViewModel>(create: (context) =>  BLogLogoViewModel()),
    ChangeNotifierProvider<PasswordChangeViewModel>(create: (context) =>  PasswordChangeViewModel(accessToken: accessToken)),
  ];
  FlavorConfig(
      flavor: Flavor.DEV,
      color: Colors.deepOrange,
  );
  runApp(
    MultiProvider(
      providers: providers,
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Root(accessToken: accessToken)),
    ),
  );
}

