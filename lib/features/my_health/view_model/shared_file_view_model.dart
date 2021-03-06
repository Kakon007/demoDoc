import 'package:flutter/material.dart';
import 'package:myhealthbd_app/features/auth/view_model/accessToken_view_model.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/features/my_health/repositories/shared_file_repository.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:myhealthbd_app/features/my_health/models/shared_file_model.dart';
import 'package:provider/provider.dart';

class SharedFileViewModel extends ChangeNotifier{
  List<Item> _sharedFileList =[];
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
  int limit=10;
  int startIndex=0;
  int _fileNo;
  int _regId;


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

  Future<bool> getData({int fileNo}) async {
    print('Enter Shareddd');
    // startIndex=0;
    // _pageCount++;
    _isFetchingData = true;
    //_lastFetchTime = DateTime.now();
    var accessToken=await Provider.of<AccessTokenProvider>(appNavigator.context, listen: false).getToken();
    var res = await SharedFileRepository().fetchSharedFile(accessToken: accessToken,fileNo: fileNo);
    notifyListeners();
    _sharedFileList.clear();
    res.fold((l) {
      _appError = l;
      _isFetchingData = false;
      print('Left Shared');
      notifyListeners();
      return false;
    }, (r) {
     // hasMoreData = r.totalCount-1>startIndex;
      _isFetchingData = false;
      if(r.dataList!=null){
      _sharedFileList.addAll(r.dataList);
      }
      //count = r.totalCount;
      //print('Right Shared ${_sharedFileList.first.remarks}');
      notifyListeners();
      return true;
    });
  }

  // getMoreData(String accessToken) async {
  //   print("Calling from getMoreData:::::");
  //   print("HasMoreData ${hasMoreData}");
  //   print("fetch ${isFetchingMoreData}");
  //   print("fetched ${isFetchingData}");
  //   if (!isFetchingMoreData && !isFetchingData && hasMoreData) {
  //     startIndex+=limit;
  //     _pageCount++;
  //     isFetchingMoreData = true;
  //     Either<AppError, PrescriptioM> result =
  //     await PrescriptionRepository().fetchPrescriptionList(accessToken: accessToken,query: searchQuery,startIndex: startIndex);
  //     return result.fold((l) {
  //       isFetchingMoreData= false;
  //       hasMoreData = false;
  //       logger.i(l);
  //       notifyListeners();
  //       return false;
  //     }, (r) {
  //
  //       hasMoreData = r.totalCount-1>startIndex+limit;
  //       isFetchingMoreData = false;
  //       _prescriptionList.addAll(r.dataListofPrescription);
  //       count = r.totalCount;
  //       notifyListeners();
  //       return true;
  //     });
  //   }
  // }


  fileInfo({
    int fileNo,
    int regId,

  }){
    print("fileNo $fileNo");
    print("regId $regId");
    _fileNo= fileNo;
    _regId=regId;

  }

  Future<bool> refresh(String accessToke) async {
    _pageCount = 1;
    notifyListeners();
    return getData();
  }
  search(String query,String accessToken) {
    _sharedFileList.clear();
    _pageCount = 1;
    searchQuery = query;
    print("Searching for: $query");
    getData();
  }

  toggleIsInSearchMode(String accessToken) {
    _isInSearchMode = !_isInSearchMode;
    count = 0;
    resetPageCounter();
    if (!_isInSearchMode) {
      searchQuery = "";
      getData();
    }
    notifyListeners();
  }

  AppError get appError => _appError;



  bool get isFetchingData => _isFetchingData;

  // bool get isFetchingMoreData => _isFetchingMoreData;
  // set isFetchingMoreData(bool value) {
  //   _isFetchingMoreData = value;
  //   notifyListeners();
  // }

  bool get isInSearchMode => _isInSearchMode;

  set isInSearchMode(bool value) {
    _isInSearchMode = value;
  }

  bool get hasMoreData => _hasMoreData;

  set hasMoreData(bool value) {
    _hasMoreData = value;
    notifyListeners();
  }

  bool get shouldShowNoPrescriptionFound => _sharedFileList.length == 0 && !isFetchingData;

  bool get shouldShowPageLoader =>
      _isFetchingData && _sharedFileList.length == 0;


  List<Item> get sharedFileList => _sharedFileList;
  set sharedFileList(List<Item> value) {
   this._sharedFileList= value;
    notifyListeners();
  }

  void isEdit(int index){
    _sharedFileList[index].isEdit=!_sharedFileList[index].isEdit;
  }
  int get fileNo=>_fileNo;
  int get regId=>_regId;
}