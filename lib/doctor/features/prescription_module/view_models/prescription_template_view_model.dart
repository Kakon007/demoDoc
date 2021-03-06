import 'package:flutter/cupertino.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/prescription_template_repository.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/models/prescription_template_model.dart';

class PrescriptionTamplateViewModel extends ChangeNotifier {
  List<Item> _prescriptionTamplateList = [];
  AppError _appError;
  DateTime _lastFetchTime;
  bool _isFetchingMoreData = false;
  bool _isFetchingData = false;
  int _pageCount = 0;
  bool _hasMoreData = false;
  String searchQuery = '';
  bool _isInSearchMode = false;
  var count = 0;
  get logger => null;
  int limit = 10;
  int startIndex = 0;
  var _id;

  void resetPageCounter() {
    _pageCount = 1;
  }

  int get totalCount => count;

  set totalCount(int value) {
    count = value;
    notifyListeners();
  }

  bool get isFetchingMoreData => _isFetchingMoreData;

  set isFetchingMoreData(bool value) {
    _isFetchingMoreData = value;
    notifyListeners();
  }

  Future<bool> getData() async {
    print('Enterer');
    startIndex = 0;
    _pageCount++;
    _isFetchingData = true;
    _lastFetchTime = DateTime.now();
    // var accessToken=await Provider.of<AccessTokenProvider>(appNavigator.context, listen: false).getToken();
    // var vm = Provider.of<UserDetailsViewModel>(appNavigator.context,listen: false);
    var res =
        await PrescriptionTemplateRepository().fetchPrescriptionTemplateList();
    notifyListeners();
    _prescriptionTamplateList.clear();
    res.fold((l) {
      _appError = l;
      _isFetchingData = false;
      print('false:: ');
      notifyListeners();
      return false;
    }, (r) {
      //hasMoreData = r.totalCount-1>startIndex;
      _isFetchingData = false;
      _prescriptionTamplateList.addAll(r.dataListofPrescription);
      count = r.totalCount;
      print('Dataaaaaaa2222222:: ' + _prescriptionTamplateList.toString());
      notifyListeners();
      return true;
    });
  }

  getIdForTemplate({var id}) {
    _id = id;
    print('id new $_id');
  }

  AppError get appError => _appError;
  bool get isFetchingData => _isFetchingData;
  bool get isInSearchMode => _isInSearchMode;

  set isInSearchMode(bool value) {
    _isInSearchMode = value;
  }

  bool get hasMoreData => _hasMoreData;

  set hasMoreData(bool value) {
    _hasMoreData = value;
    notifyListeners();
  }

  bool get shouldShowNoPrescriptionFound =>
      _prescriptionTamplateList.length == 0 && !isFetchingData;

  bool get shouldShowPageLoader =>
      _isFetchingData && _prescriptionTamplateList.length == 0;

  List<Item> get prescriptionTamplateList => _prescriptionTamplateList;
  int get id => _id;
}
