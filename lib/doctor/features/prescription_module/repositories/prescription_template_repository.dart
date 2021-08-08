

import 'dart:io';

import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/models/prescription_template_model.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/resource/urls.dart';
import 'package:http/http.dart' as http;

class PrescriptionTemplateRepository {
  Future<Either<AppError, PrescriptionTemplateM>> fetchPrescriptionTemplateList(
      {var accessToken}) async {
    // var url =
    //     "${Urls.baseUrl}prescription-service-api/api/prescription/getTemplateListByDoctor";
    try {
      var headers = {
        'Authorization': 'Bearer 5e85391a-addb-4b45-8aba-ca9fb090cdaa'
      };
      var request = http.Request('POST', Uri.parse('https://qa.myhealthbd.com:9096/prescription-service-api/api/prescription/getTemplateListByDoctor'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();
      print(response.statusCode);
      if (response.statusCode == 200) {
        var body=await response.stream.bytesToString();
        PrescriptionTemplateModel data = prescriptionTemplateModelFromJson(body);
        //CacheRepositories.setCacheAsDecodeJson(response.body, CacheKeys.prescriptionList(startIndex));
        return Right(
            PrescriptionTemplateM(dataListofPrescription: data.items));
      } else {
        // BotToast.showText(text: StringResources.somethingIsWrong);
        return Left(AppError.serverError);
      }
    } on SocketException catch (e) {
      print("FromprescriptionTemplateRepo:::" + e.toString());
      BotToast.showText(text: StringResources.unableToReachServerMessage);
      return Left(AppError.networkError);
    } catch (e) {
      // BotToast.showText(text: StringResources.somethingIsWrong);
      return Left(AppError.unknownError);
    }
  }
}

class PrescriptionTemplateM {
  List<Item> dataListofPrescription = List<Item>();
  int totalCount;
  PrescriptionTemplateM({this.dataListofPrescription, this.totalCount});
}
