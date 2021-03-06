import 'dart:convert';
import 'dart:typed_data';

import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/hospital_list_view_model.dart';
import 'package:myhealthbd_app/features/hospitals/models/hospital_list_model.dart';
import 'package:myhealthbd_app/features/hospitals/models/nearest_hospital_model.dart';
import 'package:myhealthbd_app/features/hospitals/view/widgets/hospitalListCard.dart';
import 'package:myhealthbd_app/features/hospitals/view_model/hospital_image_view_model.dart';
import 'package:myhealthbd_app/features/hospitals/view_model/hospital_logo_view_model.dart';
import 'package:myhealthbd_app/features/hospitals/view_model/nearest_hospital_view_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/util/responsiveness.dart';
import 'package:myhealthbd_app/main_app/views/widgets/SignUpField.dart';
import 'package:myhealthbd_app/main_app/views/widgets/loader.dart';
import 'package:provider/provider.dart';

class HospitalScreen extends StatefulWidget {
  //bool isNotNave;
  FocusNode f1;
  LocationData locationData;
  List<Items> hospitalList2;

  HospitalScreen({this.f1, this.locationData, this.hospitalList2});

  @override
  _HospitalScreenState createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> with AfterLayoutMixin {
  var accessToken;
  ScrollController _scrollController;

  loadImage(String image) {
    Uint8List _bytesImage = Base64Decoder().convert(image);
    return _bytesImage;
  }

  loadLogo(String image) {
    Uint8List _bytesImage = Base64Decoder().convert(image);
    return _bytesImage;
  }

  TextEditingController hospitalController = TextEditingController();
  TextEditingController hospitalController2 = TextEditingController();
  List<Item> hospitalList;
  List<Items> hospitalList2;
  var hospitalItems = List<Item>();
  var hospitalItems2 = List<Items>();
  bool isSearched = false;

  @override
  void afterFirstLayout(BuildContext context) {
    _scrollController = ScrollController();
    Future.delayed(Duration.zero, () async {
      var vm = Provider.of<HospitalListViewModel>(context, listen: false);
      var vm5 = Provider.of<HospitalLogoViewModel>(context, listen: false);
      vm5.getData();
      var vm6 = Provider.of<HospitalImageViewModel>(context, listen: false);
      vm6.getImageData();
      //await vm.getData();
      hospitalList = vm.hospitalList;

      if (widget.locationData != null) {
        hospitalList2 = widget.hospitalList2;
        hospitalItems2.addAll(hospitalList2);
      }
    });
  }

  void hospitalSearch(String query) {
    List<Item> initialHospitalSearch = List<Item>();
    hospitalList.forEach((element) {
      initialHospitalSearch.add(element);
    });
    if (query.isNotEmpty) {
      List<Item> initialHospitalSearchItems = List<Item>();
      initialHospitalSearch.forEach((item) {
        if (item.companyName.toLowerCase().contains(query.toLowerCase())) {
          initialHospitalSearchItems.add(item);
        }
      });
      setState(() {
        isSearched = true;
        hospitalItems.clear();
        hospitalItems.addAll(initialHospitalSearchItems);
      });
      return;
    } else {
      setState(() {
        hospitalItems.clear();
        hospitalItems.addAll(hospitalList);
      });
    }
  }

  void nearestHospitalSearch(String query) {
    List<Items> initialHospitalSearch = List<Items>();
    hospitalList2.forEach((element) {
      initialHospitalSearch.add(element);
    });
    if (query.isNotEmpty) {
      List<Items> initialHospitalSearchItems2 = List<Items>();
      initialHospitalSearch.forEach((item) {
        if (item.companyName.toLowerCase().contains(query.toLowerCase())) {
          initialHospitalSearchItems2.add(item);
        }
      });
      setState(() {
        isSearched = true;
        hospitalItems2.clear();
        hospitalItems2.addAll(initialHospitalSearchItems2);
      });
      return;
    } else {
      setState(() {
        hospitalItems2.clear();
        hospitalItems2.addAll(hospitalList2);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    bool isTablet = Responsive.isTablet(context);
    bool isMobile = Responsive.isMobile(context);
    var searchField = SignUpFormField(
      focusNode: widget.f1,
      onChanged: (value) {
        hospitalSearch(value);
      },
      textFieldKey: Key('hospitalSearchFieldKey'),
      focusBorderColor: "#8592E5",
      controller: hospitalController,
      borderRadius: 30,
      minimizeBottomPadding: true,
      hintSize: isTablet ? 17 : 12,
      hintText: StringResources.searchBoxHint,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(
          Icons.search_rounded,
          //color: Colors.grey,
        ),
      ),
    );
    var searchField2 = SignUpFormField(
      focusNode: widget.f1,
      onChanged: (value) {
        nearestHospitalSearch(value);
      },
      textFieldKey: Key('hospitalSearchFieldKey2'),
      focusBorderColor: "#8592E5",
      controller: hospitalController2,
      borderRadius: 30,
      minimizeBottomPadding: true,
      hintSize: isTablet ? 17 : 12,
      hintText: StringResources.searchBoxHint,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(
          Icons.search_rounded,
          //color: Colors.grey,
        ),
      ),
    );
    var vm = Provider.of<HospitalListViewModel>(context);
    var vm5 = Provider.of<HospitalLogoViewModel>(context);
    var vm6 = Provider.of<HospitalImageViewModel>(context);
    var vm9 = appNavigator.getProviderListener<NearestHospitalViewModel>();
    List<Item> list = vm.hospitalList;
    List<Items> list2 = vm9.hospitalList2;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.appbarPrimary,
        title: Text(
          StringResources.hospitalListAppbar,
          key: Key('hospitalAppbarKey'),
          style: GoogleFonts.poppins(fontSize: isTablet ? 20 : 15),
        ),
        actions: <Widget>[
          accessToken != null
              ? Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/images/alok.png"),
                    radius: 15.0,
                  ),
                )
              : SizedBox(),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return Provider.of<HospitalListViewModel>(context, listen: false)
              .refresh(force: true);
        },
        child: Padding(
          padding: EdgeInsets.only(
              left: isTablet ? 18 : 8.0, right: isTablet ? 18 : 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: isSearched && hospitalItems2.length == 0
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.start,
            children: <Widget>[
              widget.locationData != null ? searchField2 : searchField,
              widget.locationData != null
                  ? vm9.shouldShowPageLoader ||
                          vm5.shouldShowPageLoader ||
                          vm6.shouldShowPageLoaderForImage
                      ? Loader()
                      : isSearched && hospitalItems2.length == 0
                          ? Center(
                              child: Text(
                                StringResources.hospitalAndDiagnostics,
                                style: GoogleFonts.poppins(),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  key: Key('listViewBuilderKey2'),
                                  shrinkWrap: true,
                                  itemCount: isSearched == false &&
                                          hospitalItems2.length == 0
                                      ? list2.length
                                      : hospitalItems2.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var id = isSearched == false &&
                                            hospitalItems2.length == 0
                                        ? list2[index].id
                                        : hospitalItems2[index].id;
                                    int logoIndex = vm5.hospitalLogoList
                                        .indexWhere(
                                            (element) => element.id == id);
                                    int imageIndex = vm6.hospitalImageList
                                        .indexWhere(
                                            (element) => element.id == id);
                                    return HospitalListCard(
                                      loadImage(vm5.hospitalLogoList[logoIndex]
                                          .photoLogo),
                                      vm6.hospitalImageList[imageIndex]
                                                  .photoImg !=
                                              null
                                          ? loadImage(vm6
                                              .hospitalImageList[imageIndex]
                                              .photoImg)
                                          : loadLogo(vm5
                                              .hospitalLogoList[logoIndex]
                                              .photoLogo),
                                      isSearched == false &&
                                              hospitalItems2.length == 0
                                          ? list2[index].companyName
                                          : hospitalItems2[index].companyName,
                                      isSearched == false &&
                                              hospitalItems2.length == 0
                                          ? list2[index].companyAddress == null
                                              ? "Mirpur,Dahaka,Bangladesh"
                                              : list2[index].companyAddress
                                          : hospitalItems2[index]
                                                      .companyAddress ==
                                                  null
                                              ? "Mirpur,Dahaka,Bangladesh"
                                              : hospitalItems2[index]
                                                  .companyAddress,
                                      "60 Doctors",
                                      isSearched == false &&
                                              hospitalItems2.length == 0
                                          ? list2[index].companyPhone == null
                                              ? "+880 1962823007"
                                              : list2[index].companyPhone
                                          : hospitalItems2[index]
                                                      .companyPhone ==
                                                  null
                                              ? "+880 1962823007"
                                              : hospitalItems2[index]
                                                  .companyPhone,
                                      isSearched == false &&
                                              hospitalItems2.length == 0
                                          ? list2[index].companyEmail == null
                                              ? "info@mysoftitd.com"
                                              : list2[index].companyEmail
                                          : hospitalItems2[index]
                                                      .companyEmail ==
                                                  null
                                              ? "info@mysoftitd.com"
                                              : hospitalItems2[index]
                                                  .companyEmail,
                                      isSearched == false &&
                                              hospitalItems2.length == 0
                                          ? list2[index].companyLogo
                                          : hospitalItems2[index].companyLogo,
                                      isSearched == false &&
                                              hospitalItems2.length == 0
                                          ? list2[index].companyId
                                          : hospitalItems2[index].companyId,
                                      isSearched == false &&
                                              hospitalItems2.length == 0
                                          ? list2[index].ogNo.toString()
                                          : hospitalItems2[index]
                                              .ogNo
                                              .toString(),
                                      isSearched == false &&
                                              hospitalItems2.length == 0
                                          ? list2[index].id.toString()
                                          : hospitalItems2[index].id.toString(),
                                      index.toString(),
                                    );
                                  }))
                  : vm.shouldShowPageLoader ||
                          vm5.shouldShowPageLoader ||
                          vm6.shouldShowPageLoaderForImage
                      ? Loader()
                      : isSearched && hospitalItems.length == 0
                          ? Center(
                              child: Text(
                                StringResources.hospitalAndDiagnostics,
                                style: GoogleFonts.poppins(),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                  key: Key('listViewBuilderKey'),
                                  shrinkWrap: true,
                                  itemCount: isSearched == false &&
                                          hospitalItems.length == 0
                                      ? list.length
                                      : hospitalItems.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    var id = isSearched == false &&
                                            hospitalItems.length == 0
                                        ? list[index].id
                                        : hospitalItems[index].id;
                                    int logoIndex = vm5.hospitalLogoList
                                        .indexWhere(
                                            (element) => element.id == id);
                                    int imageIndex = vm6.hospitalImageList
                                        .indexWhere(
                                            (element) => element.id == id);
                                    return HospitalListCard(
                                      loadImage(vm5.hospitalLogoList[logoIndex]
                                          .photoLogo),
                                      vm6.hospitalImageList[imageIndex]
                                                  .photoImg !=
                                              null
                                          ? loadImage(vm6
                                              .hospitalImageList[imageIndex]
                                              .photoImg)
                                          : loadLogo(vm5.hospitalLogoList[index]
                                              .photoLogo),
                                      isSearched == false &&
                                              hospitalItems.length == 0
                                          ? list[index].companyName
                                          : hospitalItems[index].companyName,
                                      isSearched == false &&
                                              hospitalItems.length == 0
                                          ? list[index].companyAddress == null
                                              ? "Mirpur,Dahaka,Bangladesh"
                                              : list[index].companyAddress
                                          : hospitalItems[index]
                                                      .companyAddress ==
                                                  null
                                              ? "Mirpur,Dahaka,Bangladesh"
                                              : hospitalItems[index]
                                                  .companyAddress,
                                      "60 Doctors",
                                      isSearched == false &&
                                              hospitalItems.length == 0
                                          ? list[index].companyPhone == null
                                              ? "+880 1962823007"
                                              : list[index].companyPhone
                                          : hospitalItems[index].companyPhone ==
                                                  null
                                              ? "+880 1962823007"
                                              : hospitalItems[index]
                                                  .companyPhone,
                                      isSearched == false &&
                                              hospitalItems.length == 0
                                          ? list[index].companyEmail == null
                                              ? "info@mysoftitd.com"
                                              : list[index].companyEmail
                                          : hospitalItems[index].companyEmail ==
                                                  null
                                              ? "info@mysoftitd.com"
                                              : hospitalItems[index]
                                                  .companyEmail,
                                      isSearched == false &&
                                              hospitalItems.length == 0
                                          ? list[index].companyLogo
                                          : hospitalItems[index].companyLogo,
                                      isSearched == false &&
                                              hospitalItems.length == 0
                                          ? list[index].companyId
                                          : hospitalItems[index].companyId,
                                      isSearched == false &&
                                              hospitalItems.length == 0
                                          ? list[index].ogNo.toString()
                                          : hospitalItems[index]
                                              .ogNo
                                              .toString(),
                                      isSearched == false &&
                                              hospitalItems.length == 0
                                          ? list[index].id.toString()
                                          : hospitalItems[index].id.toString(),
                                      index.toString(),
                                    );
                                  }),
                            ),
              SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
