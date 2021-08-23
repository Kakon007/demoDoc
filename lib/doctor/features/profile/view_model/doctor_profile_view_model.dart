import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myhealthbd_app/doctor/features/profile/models/designation_model.dart';
import 'package:myhealthbd_app/doctor/features/profile/models/personal_info_model.dart';
import 'package:myhealthbd_app/doctor/features/profile/models/specialization_name_model.dart';
import 'package:myhealthbd_app/doctor/features/profile/repositories/personal_info_repository.dart';
import 'package:myhealthbd_app/main_app/failure/app_error.dart';
import 'package:provider/provider.dart';

class DoctorProfileViewModel extends ChangeNotifier {
    bool _isDoctorInfoEditing=false;
    bool _isPersonalInfoEditing=false;
    List<SpecializationListElement> _specializationName = [];
    List<DesignationList> _designationItems = [];
    AppError _appError;
    DateTime _lastFetchTime;
    bool _isFetchingMoreData = false;
    bool _isFetchingData = false;
    bool _isLoading= false;
    bool _isDesignationLoading= false;
    bool _isSpecializationLoading= false;
    PersonalInfoData _personalInfoData;
    static DoctorProfileViewModel read(BuildContext context) =>
        context.read<DoctorProfileViewModel>();
    static DoctorProfileViewModel watch(BuildContext context) =>
        context.watch<DoctorProfileViewModel>();
    Future<void> getPersonalInfo({bool force=false}) async {
        if(_personalInfoData==null || force){
            _isLoading = true;
            notifyListeners();
            var res = await PersonalInfoRepository().fetchPersonalInfo();
            res.fold((l) {
                _appError = l;
                _isLoading = false;
                notifyListeners();
            }, (r) {
                _personalInfoData = r.obj;
                _isLoading = false;
                notifyListeners();

            });
        }
    }
    Future<void> getSpecializationName({bool force=false}) async {
     if(_specializationName.isEmpty || force){
         _isSpecializationLoading = true;
         notifyListeners();
         var res = await PersonalInfoRepository().fetchSpecializationName();
         res.fold((l) {
             _appError = l;
             _isSpecializationLoading = false;
             notifyListeners();
         }, (r) {
             _specializationName = r.obj.specializationList;
             _isSpecializationLoading= false;
             notifyListeners();
         });
     }
    }
    Future<void> getDesignationList({bool force=false}) async {
    if(_designationItems.isEmpty|| force){
        _isDesignationLoading = true;
        notifyListeners();
        var res = await PersonalInfoRepository().fetchDesignationList();
        res.fold((l) {
            _appError = l;
            _isDesignationLoading = false;
            notifyListeners();
        }, (r) {
            // _isLoading = false;
            _designationItems = r.items;
            _isDesignationLoading = false;
            notifyListeners();
        });
    }
    }
    editingDoctorInfo({bool isDoctorInfoEditing}) {
    _isDoctorInfoEditing =isDoctorInfoEditing;
    notifyListeners();
    }
    editingPersonalInfo({bool isPersonalInfoEditing}) {
        _isPersonalInfoEditing = isPersonalInfoEditing;
       // notifyListeners();
    }
    bool get isLoading => _isLoading;
    bool get isDesignationLoading => _isDesignationLoading;
    bool get isSpecializationLoading => _isSpecializationLoading;
    bool get isDoctorInfoEditing => _isDoctorInfoEditing;
    bool get isPersonalInfoEditing => _isPersonalInfoEditing;
    PersonalInfoData get personalInfoData => _personalInfoData;
    List<SpecializationListElement> get specializationName =>  _specializationName;
    List<DesignationList> get designationItems => _designationItems;
}
