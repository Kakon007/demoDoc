import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myhealthbd_app/features/cache/cache_repositories.dart';
import 'package:myhealthbd_app/features/hospitals/repositories/hospital_list_repository.dart';
import 'package:myhealthbd_app/features/hospitals/models/hospital_list_model.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:myhealthbd_app/main_app/util/common_serviec_rule.dart';
import 'package:provider/provider.dart';


class HospitalListViewModel extends ChangeNotifier{
  List<Item> _hospitalList =[];

  AppError _appError;
  DateTime _lastFetchTime;
  bool _isFetchingMoreData = false;
  bool _isFetchingData = false;
  int _page = 1;
  bool _isLoading;

  Future<void> refresh({bool force}){
    _page = 0;
  _hospitalList.clear();
    return getData(force: force);
  }

  Future<void> getData({bool force=false}) async {

    if(_hospitalList.isEmpty || force){
      print('Hits');
     if(_hospitalList.isEmpty){
       CacheRepositories.loadCachedHospital().then((value) {
         if(value!=null){
           _hospitalList=value.items;
           _hospitalList.removeAt(0);
           notifyListeners();
         }
       });
     }
      _isFetchingData = true;
      //_lastFetchTime = DateTime.now();
      _isLoading = true;
      print('Hitss');
      var res = await HospitalListRepositry().fetchHospitalList();
      notifyListeners();
      _hospitalList.clear();
      res.fold((l) {
        _appError = l;
        _isFetchingMoreData = false;
        print('Hitss worng');
        notifyListeners();
      }, (r) {
        _isLoading= false;
        _isFetchingMoreData = false;
        _hospitalList.addAll(r.dataList);
        _hospitalList.removeAt(0);
        print('Hitss right');
        notifyListeners();
      });
    }
  }

  AppError get appError => _appError;



  bool get isFetchingData => _isFetchingData;

  bool get isFetchingMoreData => _isFetchingMoreData;

  // bool get hasMoreData => _hasMoreData;
  //
  // bool get shouldFetchMoreData =>
  //     _hasMoreData && !_isFetchingData && !_isFetchingMoreData;

  bool get shouldShowPageLoader =>
      _isFetchingData && _hospitalList.length == 0;
  bool get isLoading=> _isLoading;

  List<Item> get hospitalList => _hospitalList;

}