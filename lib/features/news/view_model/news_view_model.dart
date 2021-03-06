import 'package:flutter/cupertino.dart';
import 'package:myhealthbd_app/features/news/model/news_model.dart';
import 'package:myhealthbd_app/features/news/repositories/news_repository.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:myhealthbd_app/main_app/util/common_serviec_rule.dart';

class NewsViewModel extends ChangeNotifier {
  List<Item> _newsList = [];

  AppError _appError;
  DateTime _lastFetchTime;
  bool _isFetchingMoreData = false;
  bool _isFetchingData = false;
  int _page = 1;

  Future<void> refresh() {
    _newsList.clear();
    return getData();
  }

  Future<void> getData({bool isFromOnPageLoad = false}) async {
    if (_newsList.isEmpty) {
      if (isFromOnPageLoad) {
        if (_lastFetchTime != null) if (_lastFetchTime
                .difference(DateTime.now()) <
            CommonServiceRule.onLoadPageReloadTime) return;
      }
      _isFetchingData = true;
      _lastFetchTime = DateTime.now();
      var res = await NewsRepository().fetchNewspdate();
      notifyListeners();
      _newsList.clear();
      res.fold((l) {
        _appError = l;
        _isFetchingMoreData = false;
        notifyListeners();
      }, (r) {
        _isFetchingMoreData = false;
        _newsList.addAll(r.dataList);
        notifyListeners();
      });
    }
  }

  AppError get appError => _appError;

  bool get shouldShowAppError => _appError != null && _newsList.length == 0;

  bool get isFetchingData => _isFetchingData;

  bool get isFetchingMoreData => _isFetchingMoreData;

  bool get shouldShowNoNewsFound => _newsList.length == 0 && !isFetchingData;

  bool get shouldShowPageLoader => _isFetchingData && _newsList.length == 0;

  List<Item> get newsList => _newsList;
}
