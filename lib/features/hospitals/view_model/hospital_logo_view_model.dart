
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:myhealthbd_app/features/hospitals/models/company_logo_model.dart';
import 'package:myhealthbd_app/features/hospitals/repositories/hospital_logo_repository.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:myhealthbd_app/main_app/util/common_serviec_rule.dart';
import 'package:provider/provider.dart';

class HospitalLogoViewModel extends ChangeNotifier{
  List<Item> _hospitalLogoList =[];

  AppError _appError;
  DateTime _lastFetchTime;
  bool _isFetchingMoreData = false;
  bool _isFetchingData = false;
  int _page = 1;
  bool _isLoading;

  Future<void> refresh(){
    _page = 0;
    _hospitalLogoList.clear();
    return getData();
  }

  Future<void> getData({bool isFromOnPageLoad = false}) async {
    // if (isFromOnPageLoad) {
    //   if (_lastFetchTime != null) if (_lastFetchTime
    //       .difference(DateTime.now()) <
    //       CommonServiceRule.onLoadPageReloadTime) return;
    // }

    print("DATA fromLOGO List:::::");
    _isFetchingData = true;
    _lastFetchTime = DateTime.now();
    _isLoading = true;
    var res = await HospitalLogoRepository().fetchHospitalLogo();
    notifyListeners();
    _hospitalLogoList.clear();
    res.fold((l) {
      _appError = l;
      _isFetchingMoreData = false;
      notifyListeners();
    }, (r) {
      _isLoading= false;
      _isFetchingMoreData = false;
      _hospitalLogoList.addAll(r.dataList);
      notifyListeners();
      print("DATA fromLOGO List:::::" + _hospitalLogoList.last.companyLogo);
    });
  }

  AppError get appError => _appError;



  bool get isFetchingData => _isFetchingData;

  bool get isFetchingMoreData => _isFetchingMoreData;

  // bool get hasMoreData => _hasMoreData;
  //
  // bool get shouldFetchMoreData =>
  //     _hasMoreData && !_isFetchingData && !_isFetchingMoreData;

  bool get shouldShowPageLoader =>
      _isFetchingData && _hospitalLogoList.length == 0;
  bool get isLoading=> _isLoading;

  List<Item> get hospitalLogoList => _hospitalLogoList;


}