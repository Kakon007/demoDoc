import 'dart:convert';
import 'dart:io';
import 'package:bot_toast/bot_toast.dart';
import 'package:dartz/dartz.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:myhealthbd_app/features/appointments/models/auto_slot_generate_model.dart';
import 'package:myhealthbd_app/features/appointments/models/available_slots_model.dart';
import 'package:myhealthbd_app/features/appointments/models/consultation_type_model.dart';
import 'package:myhealthbd_app/features/appointments/models/doctor_info_model.dart';
import 'package:myhealthbd_app/features/appointments/models/patient__fee.dart';
import 'package:myhealthbd_app/features/appointments/models/patient_type_model.dart';
import 'package:myhealthbd_app/features/appointments/models/slot_status.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/resource/urls.dart';

class AvailableSlotsRepository {
  Future<Either<AppError, AvailableSlotListModel>> fetchSlotInfo(
      DateTime pickedAppointDate, String companyNo, String doctorNo, String orgNo) async {
    String date =   DateFormat("yyyy-MM-dd").format(DateTime.parse(pickedAppointDate.toLocal().toString()));
    var url = "${Urls.baseUrl}online-appointment-api/fapi/appointment/getAvailableSlot";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        "appointDate": date,
        "companyNo": companyNo,
        "doctorNo": doctorNo,
        "ogNo": orgNo
      }),
    );
  //  print('${response.body}');
    try {
      if (response.statusCode == 200) {
        AvailableSlotModel data = availableSlotModelFromJson(response.body);
        return Right(AvailableSlotListModel(
          slotList: data.items,
        ));
      } else {
        BotToast.showText(text: StringResources.somethingIsWrong);
        return Left(AppError.serverError);
      }
    } on SocketException catch (e) {
      BotToast.showText(text: StringResources.unableToReachServerMessage);
      return Left(AppError.networkError);
    } catch (e) {
      return Left(AppError.unknownError);
    }
  }
  Future<Either<AppError, AutoSlotGenerateModel>> fetchSlotGenerateInfo(
      DateTime pickedAppointDate, String companyNo, String doctorNo, String orgNo) async {
    String date =   DateFormat("dd/MM/yyyy").format(DateTime.parse(pickedAppointDate.toString()));
    var url = "${Urls.baseUrl}online-appointment-api/fapi/appointment/autoSlotGenerate";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{
        "appointDate":date,
        "companyNo": companyNo,
        "doctorNo": doctorNo,
        "ogNo": orgNo
      }),
    );
   // print("${response.body}");
    try {
      if (response.statusCode == 200) {
        AutoSlotGenerateModel data = autoSlotGenerateModelFromJson(response.body);
        return Right(data);
      } else {
        BotToast.showText(text: StringResources.somethingIsWrong);
        return Left(AppError.serverError);
      }
    } on SocketException catch (e) {
      BotToast.showText(text: StringResources.unableToReachServerMessage);
      return Left(AppError.networkError);
    } catch (e) {
      return Left(AppError.unknownError);
    }
  }
  Future<Either<AppError, DoctorInfoModel>> fetchDoctorInfo(
      String companyNo, String doctorNo, String orgNo) async {
    var url = "${Urls.baseUrl}online-appointment-api/fapi/appointment/getDoctorInfo";
    final http.Response response = await http.post(
      Uri.parse(url),
      body:
          jsonEncode(<String, String>{"companyNo": companyNo, "doctorNo": doctorNo, "ogNo": orgNo}),
    );
    try {
      if (response.statusCode == 200) {
       // print("doctorInfo ${response.body}");
        DoctorInfoModel data = doctorInfoModelFromJson(response.body);
        return Right(DoctorInfoModel(
          obj: data.obj,
        ));
      } else {
        BotToast.showText(text: StringResources.somethingIsWrong);
        return Left(AppError.serverError);
      }
    } on SocketException catch (e) {
      BotToast.showText(text: StringResources.unableToReachServerMessage);
      return Left(AppError.networkError);
    } catch (e) {
      return Left(AppError.unknownError);
    }
  }

  Future<Either<AppError, SlotCheckModel>> fetchStatus(
      String slotNo, String companyNo, String orgNo) async {
    BotToast.showLoading(allowClick: false,);
    var url = "${Urls.baseUrl}online-appointment-api/fapi/appointment/checkSlotStatus";
    final http.Response response = await http.post(
      Uri.parse(url),
      body: jsonEncode(<String, String>{"slotNo": slotNo, "companyNo": companyNo, "ogNo": orgNo}),
    );
    //print(response.body);
    try {
      if (response.statusCode == 200) {
        BotToast.closeAllLoading();
        SlotStatusModel data = slotStatusModelFromJson(response.body);
        return Right(SlotCheckModel(slotStatus: data.model.status));
      } else {
        BotToast.closeAllLoading();
        BotToast.showText(text: StringResources.somethingIsWrong);
        return Left(AppError.serverError);
      }
    } on SocketException catch (e) {
      BotToast.closeAllLoading();
      BotToast.showText(text: StringResources.unableToReachServerMessage);
      return Left(AppError.networkError);
    } catch (e) {
      BotToast.closeAllLoading();
    } // BotToast.showText(text: StringResources.somethingIsWrong);
    return Left(AppError.unknownError);
  }

  Future<Either<AppError, PatientType>> fetchPatType(String doctorNo) async {
    var url =
        "${Urls.baseUrl}online-appointment-api/fapi/appointment/findPatTypeList?doctorNo=$doctorNo";
    var client = http.Client();
    var response = await client.get(Uri.parse(url));
    //print(response.body);
    try {
      if (response.statusCode == 200) {
        PatientTypeModel data = patientTypeModelFromJson(response.body);
        return Right(PatientType(patType: data.patientItem));
      } else {
        BotToast.showText(text: StringResources.somethingIsWrong);
        return Left(AppError.serverError);
      }
    } on SocketException catch (e) {
      //logger.e(e);
      BotToast.showText(text: StringResources.unableToReachServerMessage);
      return Left(AppError.networkError);
    } catch (e) {
    }
    return Left(AppError.unknownError);
  }

  Future<Either<AppError, ConsultTypes>> fetchConType(
      String doctorNo, String selectedType, String companyNo, String orgNo) async {
    var url =
        "${Urls.baseUrl}online-appointment-api/fapi/appointment/findConTypeList?doctorNo=$doctorNo&patTypeNo=$selectedType&companyNo=2&ogNo=2";
    var client = http.Client();
    var response = await client.get(Uri.parse(url));
    //print(response.body);
    try {
      if (response.statusCode == 200) {
        ConsultTypeModel data = consultTypeModelFromJson(response.body);
        return Right(ConsultTypes(consultType: data.consultType));
      } else {
        return Left(AppError.serverError);
      }
    } on SocketException catch (e) {
      return Left(AppError.networkError);
    } catch (e) {
    }
    return Left(AppError.unknownError);
  }

  Future<Either<AppError, FeeCheck>> fetchFee(
      String companyNo, String conTypeNo, String doctorNo, String orgNo, String patNo) async {
    var url = "${Urls.baseUrl}online-appointment-api/fapi/appointment/getConsultationFee";
    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(<String, String>{
          "companyNo": companyNo,
          "conTypeNo": conTypeNo,
          "doctorNo": doctorNo,
          "ogNo": orgNo,
          "patTypeNo": patNo
        }),
      );
      if (response.statusCode == 200) {
        //print(response.body);
        PatientFee data = patientFeeFromJson(response.body);
        return Right(FeeCheck(
          fee: data.obj.toString(),
        ));
      } else {
        return Left(AppError.serverError);
      }
    } on SocketException catch (e) {
      return Left(AppError.networkError);
    } catch (e) {
    }
    return Left(AppError.unknownError);
  }
}

class AvailableSlotListModel {
  List<Items> slotList = new List<Items>();

  AvailableSlotListModel({this.slotList});
}

class PatientType {
  List<PatientItem> patType = new List<PatientItem>();

  PatientType({this.patType});
}

class ConsultTypes {
  List<ConsultType> consultType = new List<ConsultType>();

  ConsultTypes({this.consultType});
}

class SlotCheckModel {
  String slotStatus;

  SlotCheckModel({this.slotStatus});
}

class FeeCheck {
  String fee;

  FeeCheck({this.fee});
}
