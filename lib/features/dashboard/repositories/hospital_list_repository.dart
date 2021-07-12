import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:myhealthbd_app/features/cache/cache_repositories.dart';
import 'package:myhealthbd_app/features/hospitals/models/hospital_list_model.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/resource/urls.dart';

class HospitalListRepositry {
  Future<Either<AppError, HospiitalListM>> fetchHospitalList() async {
    var url = "${Urls.baseUrl}online-appointment-api/fapi/appointment/companyList";
    // List<Item> dataList = new List<Item>();

    try {
      var client = http.Client();
      var response = await client.get(Uri.parse(url));
      print('hospital list ${response.body}');
      print('hospital status ${response.statusCode}');
      if (response.statusCode == 200) {
        HospitalListModel data = hospitalListModelFromJson(response.body);
        CacheRepositories.setCacheAsDecodeJson(response.body, CacheKeys.hospitalList);
       // print('Hospital Data:: ' + data.items[5].companyAddress);
        // return data;

        return Right(HospiitalListM(
          dataList: data.items,
        ));
        //print(data[0]['companySlogan']);
      } else {
        print('some1');
        BotToast.showText(text: StringResources.somethingIsWrong);
        return Left(AppError.serverError);
      }
    } on SocketException catch (e) {
      //logger.e(e);
      BotToast.showText(text: StringResources.unableToReachServerMessage);
      return Left(AppError.networkError);
    } catch (e) {
      //logger.e(e);
      print(e);
      BotToast.showText(text: StringResources.somethingIsWrong);
      return Left(AppError.unknownError);
    }
  }
}

class HospiitalListM {
  List<Item> dataList = new List<Item>();
  HospiitalListM({this.dataList});
}
