import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:myhealthbd_app/features/appointment_history/models/upcoming_model.dart';
import 'package:myhealthbd_app/features/appointment_history/repositories/upcoming_repository.dart';
import 'package:myhealthbd_app/features/auth/view_model/accessToken_view_model.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/features/cache/cache_repositories.dart';
import 'package:myhealthbd_app/features/user_profile/view_model/userDetails_view_model.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:provider/provider.dart';

class AppointmentUpcomingViewModel extends ChangeNotifier{
  List<Item> _upComingList =[];
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
    CacheRepositories.loadCachedAppointmentHistoryUpcoming().then((value){
      if(value!=null){
        _upComingList=value.obj.data;
        notifyListeners();
      }
    });
    print("CalledfromUpcomingList");
    startIndex=0;
    _pageCount++;
    _isFetchingData = true;
    _lastFetchTime = DateTime.now();
    var accessToken=await Provider.of<AccessTokenProvider>(appNavigator.context, listen: false).getToken();
    var vm = Provider.of<UserDetailsViewModel>(appNavigator.context,listen: false);
    var res = await AppointmentUpcomingRepository().fetchAppointmentUpcomingHistory(pageCount: _pageCount,accessToken:accessToken,query:searchQuery,userName: vm.userDetailsList.hospitalNumber);
    notifyListeners();
    _upComingList.clear();
    res.fold((l) {
      _appError = l;
      _isFetchingData = false;
      notifyListeners();
      return false;
    }, (r) {
      hasMoreData = r.totalCount-1>startIndex;
      _isFetchingData = false;
      _upComingList=r.dataList;
      count=r.totalCount;
      print('DataaaaaaaFromUpcominglist:: ' + _upComingList.toString());
      notifyListeners();
      return true;
    });
  }

  getMoreData() async {
    print("Calling from AppointmentgetMoreData:::::");
    print("HasMoreData ${hasMoreData}");
    print("isFetchingMoreData ${isFetchingMoreData}");
    print("isFetchingData ${isFetchingData}");
    if (!isFetchingMoreData && !isFetchingData && hasMoreData) {
      startIndex+=limit;
      _pageCount++;
      isFetchingMoreData = true;
      var accessToken=await Provider.of<AccessTokenProvider>(appNavigator.context, listen: false).getToken();
      var vm = Provider.of<UserDetailsViewModel>(appNavigator.context,listen: false);
      Either<AppError, Upcoming> result =
      await AppointmentUpcomingRepository().fetchAppointmentUpcomingHistory(pageCount: _pageCount,accessToken:accessToken,query: searchQuery,startIndex: startIndex,userName: vm.userDetailsList.hospitalNumber);
      return result.fold((l) {
        isFetchingMoreData= false;
        hasMoreData = false;
        logger.i(l);
        notifyListeners();
        return false;
      }, (r) {

        hasMoreData = r.totalCount-1>startIndex+limit;
        isFetchingMoreData = false;
        _upComingList.addAll(r.dataList);
        count = r.totalCount;
        notifyListeners();
        return true;
      });
    }
  }


  Future<bool> refresh(String accessToken) async {
    _pageCount = 1;
    notifyListeners();
    return getData();
  }
  search(String query,String accessToken) {
    _upComingList.clear();
   // _pageCount = 1;
    searchQuery = query;
    print("Searching for: $query");
    getData();
  }


  toggleIsInSearchMode(String accessToken) {
    _isInSearchMode = !_isInSearchMode;
    //count = 0;
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

  bool get shouldShowNoPrescriptionFound => _upComingList.length == 0 && !isFetchingData;

  bool get shouldShowPageLoader =>
      _isFetchingData && _upComingList.length == 0;


  List<Item> get upComingAppointmentList => _upComingList;
}