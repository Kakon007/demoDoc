import 'package:flutter/cupertino.dart';
import 'package:myhealthbd_app/features/auth/repositories/policy_repository.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';

class PolicyViewModel extends ChangeNotifier{
  var _hospitalList ;

  AppError _appError;
  DateTime _lastFetchTime;
  bool _isFetchingMoreData = false;
  bool _isFetchingData = false;
  int _page = 1;
  bool _isLoading;

  Future<void> refresh(){
    _page = 0;
    _hospitalList.clear();
    return getData();
  }

  Future<void> getData() async {
    _isFetchingData = true;
    //_lastFetchTime = DateTime.now();
    _isLoading = true;
    var res = await PolicyRepositry().fetchPolicy();
    print('Nesrestcallllk');
    notifyListeners();
    //_hospitalList.clear();
    res.fold((l) {
      _appError = l;
      _isFetchingMoreData = false;
      print('worst');
      notifyListeners();
    }, (r) {
      _isLoading= false;
      _isFetchingMoreData = false;
      _hospitalList=r.dataList;
      print('right');
      //_hospitalList.removeAt(0);
      notifyListeners();
    });
  }

  AppError get appError => _appError;



  bool get isFetchingData => _isFetchingData;

  bool get isFetchingMoreData => _isFetchingMoreData;

  // bool get hasMoreData => _hasMoreData;
  //
  // bool get shouldFetchMoreData =>
  //     _hasMoreData && !_isFetchingData && !_isFetchingMoreData;

  // bool get shouldShowPageLoader =>
  //     _isFetchingData && _hospitalList.length == 0;
  bool get isLoading=> _isLoading;

  String get policy => _hospitalList;

}