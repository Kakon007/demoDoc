import 'package:flutter/cupertino.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/models/common_prescription_search_items_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/models/get_template_data_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/models/prescription_save_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/models/prescription_template_save_data_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/get_template_data_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/save_prescription_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/save_prescription_template_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view/widgets/disposal_widget.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view/widgets/investigations_findings_widget.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view/widgets/medication_widget.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view_models/vitals_list_setup_view_model.dart';
import 'package:myhealthbd_app/doctor/main_app/prescription_favourite_type.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:provider/provider.dart';

class GetTamplateDataViewModel extends ChangeNotifier {
  static GetTamplateDataViewModel read(BuildContext context) =>
      context.read<GetTamplateDataViewModel>();
  static GetTamplateDataViewModel watch(BuildContext context) =>
      context.watch<GetTamplateDataViewModel>();

  Obj _prescriptionTamplateList;
  AppError _appError;
  bool _isFetchingData = false;
  bool _hasMoreData = false;
  get logger => null;
  String templateName = '';
  //Disposal
  String chosenDisposalValue;
  TextEditingController disposalDurationController =
      new TextEditingController();
  String disposalDurationType;
  DateTime disposalSelectedDate = DateTime.now();
//OPD
  String referredOPDSelectedItems;
  //Doctor
  String referredDoctorSelectedItems;
  List<CommonPrescriptionSearchItems> investigationSelectedItems = [];
  List<String> clinicalHistorySelectedItems = [];
  List<String> pastIllnessSelectedItems = [];
  List<String> chiefComplaintSelectedItems = [];
  List<String> diseaseSelectedItems = [];
  List<String> provisionalDiagnosisSelectedItems = [];
  List<String> adviceSelectedItems = [];
  List<AddMultiDoseController> multiDoseControlerList = [];
  List<SaveVitalList> vitals = [];
  List<MultiDose> multiDoseItemList = [];
  List<MedicineList> medicineList = [];
  List<String> procedureSelectedItems = [];
  List<DisposalItem> disposeSelectedItems = [];
  List<String> opdSelectedItems = [];
  List<String> doctorSelectedItems = [];
  List<String> orthosisSelectedItems = [];
  List<Findings> investigationFindingItems = [];
  // List<VitalsController> vitalControllerList = [];
  TextEditingController noteTextEditingController = TextEditingController();
  //vitals
  TextEditingController tempTextEditingController = TextEditingController();
  TextEditingController pulseTextEditingController = TextEditingController();
  TextEditingController heartRateTextEditingController =
      TextEditingController();
  TextEditingController spo2TextEditingController = TextEditingController();
  TextEditingController resRateTextEditingController = TextEditingController();
  TextEditingController bpSysTextEditingController = TextEditingController();
  TextEditingController bpDiaTextEditingController = TextEditingController();
  TextEditingController minBpTextEditingController = TextEditingController();
  TextEditingController weightTextEditingController = TextEditingController();
  TextEditingController heightTextEditingController = TextEditingController();

  // (pulseTextEditingController.text == null ||
  //     pulseTextEditingController.text == "") &&
  // (heartRateTextEditingController.text == null ||
  //     heartRateTextEditingController.text == "") &&
  // (tempTextEditingController.text == null ||
  //     tempTextEditingController.text == "") &&
  // (spo2TextEditingController.text == null ||
  //     spo2TextEditingController.text == "") &&
  // (resRateTextEditingController.text == null ||
  //     resRateTextEditingController.text == "") &&
  // (bpSysTextEditingController.text == null ||
  //     bpSysTextEditingController.text == "") &&
  // (bpDiaTextEditingController.text == null ||
  //     bpDiaTextEditingController.text == "") &&
  // (minBpTextEditingController.text == null ||
  //     minBpTextEditingController.text == "") &&
  // (weightTextEditingController.text == null ||
  //     weightTextEditingController.text == "") &&
  // (heightTextEditingController.text == null ||
  //     heightTextEditingController.text == "");
  bool vitalsShowReport = true;
  bool chiefComplentShowReport = true;
  bool clinicalHistoryShowReport = true;
  bool pastIllnessShowReport = true;
  bool provisionalDiagnosisShowReport = true;
  bool diseaseShowReport = true;
  bool investigationShowReport = true;
  bool investigationFindingsShowReport = true;
  bool orthosisShowReport = true;
  bool adviceShowReport = true;
  bool procedureShowReport = true;
  bool referredDoctorShowReport = true;
  bool referredOPDShowReport = true;
  bool disposalShowReport = true;
  bool medicationShowReport = true;
  bool noteShowReport = true;
  Future<bool> getData({var templateId}) async {
    investigationSelectedItems.clear();
    provisionalDiagnosisSelectedItems.clear();
    adviceSelectedItems.clear();
    chiefComplaintSelectedItems.clear();
    pastIllnessSelectedItems.clear();
    diseaseSelectedItems.clear();
    clinicalHistorySelectedItems.clear();
    print('Enterer');
    _isFetchingData = true;
    var res = await GetTemplateDataRepository()
        .fetchTemplateData(templateId: templateId);
    notifyListeners();
    res.fold((l) {
      _appError = l;
      _isFetchingData = false;

      print('falsew:: ');
      notifyListeners();
      return false;
    }, (r) {
      _isFetchingData = false;
      //investigation
      r.dataList.investigationList.forEach((element) {
        if (investigationSelectedItems.contains(element.preDiagnosisVal)) {
          print('already added');
        } else {
          investigationSelectedItems.add(CommonPrescriptionSearchItems(
              itemName: element.preDiagnosisVal,
              itemTypeNo: element.preDiagnosisValType,
              itemNo: element.preDiagnosisValType));
        }
        print('shakil ${investigationSelectedItems.length}');
      });
//clinical History
      r.dataList.clinicalHistory3List.forEach((element) {
        if (clinicalHistorySelectedItems.contains(element.preDiagnosisVal)) {
          print('already added');
        } else {
          clinicalHistorySelectedItems.add(element.preDiagnosisVal);
        }
        print('shakil ${clinicalHistorySelectedItems.length}');
      });
//pastillness
      r.dataList.clinicalHistory2List.forEach((element) {
        if (pastIllnessSelectedItems.contains(element.preDiagnosisVal)) {
          print('already added');
        } else {
          pastIllnessSelectedItems.add(element.preDiagnosisVal);
        }
      });

      //Chief Complaints
      r.dataList.chiefComplainList.forEach((element) {
        if (chiefComplaintSelectedItems.contains(element.preDiagnosisVal)) {
          print('already added');
        } else {
          chiefComplaintSelectedItems.add(element.preDiagnosisVal);
        }
      });

      //diseaseList
      r.dataList.diseaseList.forEach((element) {
        if (diseaseSelectedItems.contains(element.preDiagnosisVal)) {
          print('already added');
        } else {
          diseaseSelectedItems.add(element.preDiagnosisVal);
          print('monir ${diseaseSelectedItems.length}');
        }
      });
      //Diagnosis
      r.dataList.diagnosisList.forEach((element) {
        print('aaaaaaa');
        if (provisionalDiagnosisSelectedItems
            .contains(element.preDiagnosisVal)) {
          print('already added');
        } else {
          provisionalDiagnosisSelectedItems.add(element.preDiagnosisVal);
        }
        print('shakil ${provisionalDiagnosisSelectedItems.length}');
      });
      //Advice
      r.dataList.adviceList.forEach((element) {
        print('aaaaaaa');
        if (adviceSelectedItems.contains(element.preDiagnosisVal)) {
          print('already added');
        } else {
          adviceSelectedItems.add(element.preDiagnosisVal);
        }
        print('shakil ${provisionalDiagnosisSelectedItems.length}');
      });
      //mediaction
      r.dataList.medicationList.forEach((element) {
        print('aaaaaaa');
        if (medicineList.contains(element.brandName)) {
          print('already added');
        } else {
          medicineList.add(MedicineList(
            brandName: element.brandName,
            genericName: element.genericName,
            //Todo: add this in multidose
            // duration: element.presMedDtlList.first.duration,
            // dose: element.presMedDtlList.first.dosage,
            // instruction: element.presMedDtlList.first.medicineComment,
            // durationType: element.presMedDtlList.first.durationMu,
            multiDoseList: [],
          ));
        }
        print('shakil ${provisionalDiagnosisSelectedItems.length}');
      });
      _prescriptionTamplateList = r.dataList;
      notifyListeners();
      return true;
    });
  }

  setPrescriptionData() {
    var prescriptionData = PrescriptionTemplateSaveModel(
      prescriptionTemp:
          PrescriptionTempData(templateName: templateName, activeStatus: 1),
      adviceList: adviceSelectedItems
          .map((e) =>
              AdviceListElement(preDiagnosisVal: e, preDiagnosisValType: 8))
          .toList(),
      chiefComplainList: chiefComplaintSelectedItems
          .map((e) =>
              AdviceListElement(preDiagnosisVal: e, preDiagnosisValType: 7))
          .toList(),
      diseaseList: diseaseSelectedItems
          .map((e) =>
              AdviceListElement(preDiagnosisVal: e, preDiagnosisValType: 24))
          .toList(),
      clinicalHistory3List: clinicalHistorySelectedItems
          .map((e) =>
              AdviceListElement(preDiagnosisVal: e, preDiagnosisValType: 32))
          .toList(),
      clinicalHistory2List: pastIllnessSelectedItems
          .map((e) =>
              AdviceListElement(preDiagnosisVal: e, preDiagnosisValType: 9))
          .toList(),
      diagnosisList: provisionalDiagnosisSelectedItems
          .map((e) =>
              AdviceListElement(preDiagnosisVal: e, preDiagnosisValType: 6))
          .toList(),
      investigationList: investigationSelectedItems
          .map((e) => InvestigationList(
                preDiagnosisVal: e.itemName,
                preDiagnosisValType: 1,
                itemTypeNo: e.itemTypeNo,
              ))
          .toList(),
      medicationList: medicineList
          .map((e) => MedicationList2(
                genericName: e.genericName,
                brandName: e.genericName,
                preDiagnosisValType: 4,
                route: e.route,
                presMedDtlList: e.multiDoseList
                    .map((e2) => PresMedDtlList2(
                          dosage: e2.multiDose,
                          duration: e2.multiDoseDuration,
                          durationMu: e2.multiDoseDurationType,
                          medicineComment: e2.multiDoseInstruction,
                        ))
                    .toList(),
              ))
          .toList(),
    );
    SavePrescripTionTemplateRepository().fetchFileType(prescriptionData);
  }

  savePrescriptionData(
      {String id,
      String name,
      String age,
      String gender,
      String bloodGroup,
      String phoneNumber,
      String consultationTime,
      String consultType,
      int serial,
      int regNo,
      int doctorNo,
      String consultationId,
      String consultationTypeNo,
      var patTypeNumber,
      var appointmentNumber,
      var departmentNumber,
      String departmentName,
      var consultationNumber,
      var isPatientOut,
      var ipdFlag,
      var companyNumber}) {
    var vVm = appNavigator.context.read<VitalsListSetupViewModel>();
    var vitals2 = vVm.vitalsSetupList
        .map((e) => (SaveVitalList(
              findings: e.vitalsController.text,
              preDiagnosisValType: 53,
              preDiagnosisVal: e.preDiagnosisVal,
            )))
        .toList();
    print("vitals2.length ${vitals2.length}");
    // if (tempTextEditingController.text != null ||
    //     tempTextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: tempTextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "Body Temp",
    //   ));
    // }
    // if (pulseTextEditingController.text != null ||
    //     pulseTextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: pulseTextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "Pulse",
    //   ));
    // }
    // if (heartRateTextEditingController.text != null ||
    //     heartRateTextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: heartRateTextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "Heart Rate",
    //   ));
    // }
    // if (spo2TextEditingController.text != null ||
    //     spo2TextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: spo2TextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "SPO2",
    //   ));
    // }
    // if (resRateTextEditingController.text != null ||
    //     resRateTextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: resRateTextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "Res.Rate",
    //   ));
    // }
    // if (bpDiaTextEditingController.text != null ||
    //     bpDiaTextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: bpDiaTextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "BP_Dia",
    //   ));
    // }
    // if (bpSysTextEditingController.text != null ||
    //     bpSysTextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: bpSysTextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "BP_SYS",
    //   ));
    // }
    //
    // if (minBpTextEditingController.text != null ||
    //     minBpTextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: minBpTextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "Min_BP",
    //   ));
    // }
    //
    // if (weightTextEditingController.text != null ||
    //     weightTextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: weightTextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "Weight",
    //   ));
    // }
    //
    // if (heightTextEditingController.text != null ||
    //     heightTextEditingController.text != '') {
    //   vitals.add(SaveVitalList(
    //     findings: heightTextEditingController.text,
    //     preDiagnosisValType: 53,
    //     preDiagnosisVal: "Height",
    //   ));
    // }

    print("vitals l ${vitals.length}");
    disposeSelectedItems = [];
    disposeSelectedItems.add(DisposalItem(
      disposal: chosenDisposalValue,
      disposalDate: disposalSelectedDate,
      disposalDuration: disposalDurationController.text,
      disposalDurationType: disposalDurationType,
    ));
    // doctorSelectedItems = [];
    // doctorSelectedItems.add(referredDoctorSelectedItems);
    opdSelectedItems = [];
    opdSelectedItems.add(referredOPDSelectedItems);
    print("DHUURR $departmentName");
    var prescription = PrescriptionSaveModel(
      prescription: Prescription(
          consultationTypeNo: consultationTypeNo.toString(),
          patientTypeNo: 1,
          shiftNo: 0,
          id: null,
          appointmentNo: int.parse(appointmentNumber),
          registrationNo: regNo,
          hospitalId: id,
          consultationNo: consultationNumber,
          consultationId: consultationId,
          departmentNo: departmentNumber,
          departmentName: departmentName,
          isPatientOut: isPatientOut,
          ipdFlag: 0,
          companyNo: companyNumber),
      vitalList: vitals2,
      chiefComplainList: chiefComplaintSelectedItems
          .map(
            (e) => SaveChiefComplainList(
              preDiagnosisVal: e,
              preDiagnosisValType: 7,
              selected: chiefComplentShowReport == true ? "1" : "0",
            ),
          )
          .toList(),
      note: SaveNote(
          preDiagnosisVal: noteTextEditingController.text,
          preDiagnosisValType: PrescriptionFavouriteType.note),
      clinicalHistory3List: clinicalHistorySelectedItems
          .map(
            (e) => SaveAdviceListElement(
              preDiagnosisValType: PrescriptionFavouriteType.clinicalHistory,
              preDiagnosisVal: e,
              selected: noteShowReport == true ? "1" : "0",
            ),
          )
          .toList(),
      clinicalHistory2List: pastIllnessSelectedItems
          .map(
            (e) => SaveClinicalHistory2ListElement(
              preDiagnosisVal: e,
              preDiagnosisValType:
                  PrescriptionFavouriteType.pastIllness.toString(),
              selected: pastIllnessShowReport == true ? "1" : "0",
            ),
          )
          .toList(),
      diagnosisList: provisionalDiagnosisSelectedItems
          .map(
            (e) => SaveAdviceListElement(
              preDiagnosisValType:
                  PrescriptionFavouriteType.provisionalDiagnosis,
              preDiagnosisVal: e,
              selected: provisionalDiagnosisShowReport == true ? "1" : "0",
            ),
          )
          .toList(),
      orthosisList: orthosisSelectedItems
          .map(
            (e) => SaveAdviceListElement(
              preDiagnosisVal: e,
              preDiagnosisValType: PrescriptionFavouriteType.orthosis,
              selected: orthosisShowReport == true ? "1" : "0",
            ),
          )
          .toList(),
      investigationFindingsList: investigationFindingItems
          .map(
            (e) => SaveInvestigationList(
              preDiagnosisValType:
                  PrescriptionFavouriteType.investigationFindings,
              preDiagnosisVal: e.name,
              findings: e.finding,
            ),
          )
          .toList(),
      disposalList: chosenDisposalValue == null
          ? []
          : disposeSelectedItems
              .map(
                (e) => SaveDisposalList(
                  preDiagnosisVal: e.disposal,
                  preDiagnosisValType:
                      PrescriptionFavouriteType.disposal.toString(),
                  followUpDate: e.disposalDate,
                  durationMu: e.disposalDurationType,
                  duration: e.disposalDuration,
                  selected: disposalShowReport == true ? "1" : "0",
                ),
              )
              .toList(),
      treatmentList: procedureSelectedItems
          .map(
            (e) => SaveClinicalHistory2ListElement(
              preDiagnosisValType:
                  PrescriptionFavouriteType.procedure.toString(),
              preDiagnosisVal: e,
              selected: procedureShowReport == true ? "1" : "0",
            ),
          )
          .toList(),
      diseaseList: diseaseSelectedItems
          .map(
            (e) => SaveClinicalHistory2ListElement(
              preDiagnosisVal: e,
              preDiagnosisValType: PrescriptionFavouriteType.disease.toString(),
              selected: diseaseShowReport == true ? "1" : "0",
            ),
          )
          .toList(),
      adviceList: adviceSelectedItems
          .map(
            (e) => SaveAdviceListElement(
              preDiagnosisVal: e,
              preDiagnosisValType: PrescriptionFavouriteType.advice,
              selected: adviceShowReport == true ? "1" : "0",
            ),
          )
          .toList(),
      referralList: referredOPDSelectedItems == null ||
              referredOPDSelectedItems == ''
          ? []
          : [referredDoctorSelectedItems]
              .map(
                (e) => SaveClinicalHistory2ListElement(
                  preDiagnosisValType: PrescriptionFavouriteType.opd.toString(),
                  preDiagnosisVal: e,
                  selected: referredDoctorShowReport == true ? "1" : "0",
                ),
              )
              .toList(),
      referralDoctorList:
          referredDoctorSelectedItems == null || referredOPDSelectedItems == ''
              ? []
              : [referredDoctorSelectedItems]
                  .map(
                    (e) => SaveClinicalHistory2ListElement(
                      preDiagnosisVal: e,
                      preDiagnosisValType:
                          PrescriptionFavouriteType.doctor.toString(),
                      selected: referredOPDShowReport == true ? "1" : "0",
                    ),
                  )
                  .toList(),
      investigationList: investigationSelectedItems
          .map(
            (e) => SaveInvestigationList(
              preDiagnosisValType:
                  PrescriptionFavouriteType.investigationFindingsSearch,
              preDiagnosisVal: e.itemName,
              itemTypeNo: e.itemTypeNo,
            ),
          )
          .toList(),
      medicationList: medicineList
          .map((e) => SaveMedicationList(
              brandName: e.brandName,
              genericName: e.genericName,
              preDiagnosisValType: 4,
              presMedDtlList: e.multiDoseList
                  .map(
                    (e2) => SavePresMedDtlList(
                      medicineComment: e2.multiDoseInstruction,
                      durationMu: e2.multiDoseDurationType,
                      dosage: e2.multiDose,
                      duration: e2.multiDoseDuration,
                    ),
                  )
                  .toList()))
          .toList(),
    );
    SavePrescriptionRepository().postPrescription(prescription);
  }

  AppError get appError => _appError;
  bool get isFetchingData => _isFetchingData;
  Obj get prescriptionTamplateListData => _prescriptionTamplateList;
}
