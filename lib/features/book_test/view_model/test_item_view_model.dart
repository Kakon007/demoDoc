import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:myhealthbd_app/features/book_test/model/test_item_model.dart';
import 'package:myhealthbd_app/features/book_test/repository/test_item_repository.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';


class TestItemViewModel extends ChangeNotifier{
  List<TestItem> _testItem =[];
  List<TestItem> _cartList =[];
  List<double> _salesPrice=[];
  List<double> _discountAmt=[];
  List<double> _discountPrice=[];
  AppError _appError;
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



  Future<bool> getData({int companyNo,String buList,String doctorSearch}) async {
    startIndex=0;
    _pageCount++;
    _isFetchingData = true;
    var res = await TestItemListRepository().fetchTestListDataData(companyNo: companyNo,bulist: buList,doctorSearch: doctorSearch);
    notifyListeners();
    res.fold((l) {
      _appError = l;
      _isFetchingData = false;
      notifyListeners();
      return false;
    }, (r) {
     // hasMoreData = r.totalCount-1>startIndex;
      _isFetchingData = false;
      _testItem=r.dataList;
      //count = r.totalCount;
      //print('Dataaaaaaa2222222:: ' + _testItem.toString());
      notifyListeners();
      return true;
    });
  }

  getMoreData({int companyNo,String buList}) async {
  print('scroll');
      startIndex+=limit;
      _pageCount++;
      isFetchingMoreData = true;
      Either<AppError, TestItemMo> result =
      await TestItemListRepository().fetchTestListDataData(companyNo: companyNo,startIndex: startIndex,bulist: buList);
      return result.fold((l) {
        isFetchingMoreData= false;
        hasMoreData = false;
        logger.i(l);
        notifyListeners();
        return false;
      }, (r) {
        hasMoreData = r.totalCount-1>startIndex+limit;
        isFetchingMoreData = false;
        _testItem.addAll(r.dataList);
        count = r.totalCount;
        notifyListeners();
        return true;
      });

  }

  addToCart({TestItem cartList,double salesPrice,double discountAmt,double discountPrice}){
    _cartList.add(cartList);
    _salesPrice.add(salesPrice);
    _discountAmt.add(discountAmt);
    _discountPrice.add(discountPrice);
    notifyListeners();
  }


  Future<bool> refresh(String accessToken) async {
    _pageCount = 1;
    notifyListeners();
    return getData();
  }
  search(String query,String accessToken) {
    _testItem.clear();
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

  bool get isInSearchMode => _isInSearchMode;

  set isInSearchMode(bool value) {
    _isInSearchMode = value;
  }

  bool get hasMoreData => _hasMoreData;

  set hasMoreData(bool value) {
    _hasMoreData = value;
    notifyListeners();
  }

  bool get shouldShowNoPrescriptionFound => _testItem.length == 0 && !isFetchingData;

  bool get shouldShowPageLoader =>
      _isFetchingData && _testItem.length == 0;


  List<TestItem> get testItemList => _testItem;
  List<TestItem> get cartList => _cartList;
  List<double> get salesPrice => _salesPrice;
  List<double> get discountAmt => _discountAmt;
  List<double> get discountPrice => _discountPrice;

  // set testItemList(List<Item> value) {
  //   this._testItem= value;
  //   notifyListeners();
  // }
 void isAdded({int index}){
    _testItem[index].isAdded=!_testItem[index].isAdded;
  }

}