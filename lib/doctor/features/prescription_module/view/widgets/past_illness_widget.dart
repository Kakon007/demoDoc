import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/models/favourite_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/common_add_to_favorite_list_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/delete_favorite_list_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/pre_diagnosis_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view/widgets/prescription_common_widget.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view_models/chief_complaint_view_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view_models/get_template_data_view_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view_models/past_illness_view_model.dart';
import 'package:myhealthbd_app/doctor/main_app/prescription_favourite_type.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:provider/provider.dart';

class PastIllnessWidget extends StatefulWidget {
  const PastIllnessWidget({Key key}) : super(key: key);
  @override
  _PastIllnessWidgetState createState() => _PastIllnessWidgetState();
}

class _PastIllnessWidgetState extends State<PastIllnessWidget> {
  bool showReport = false;
  TextEditingController controller = TextEditingController();

  int ind;
  var vm = appNavigator.context.read<PastIllnessViewModel>();
  TextEditingController _favoriteController = TextEditingController();
  List<FavouriteItemModel> favoriteItems = [];
  void searchFavoriteItem(String query) {
    List<FavouriteItemModel> initialFavoriteSearch = [];
    initialFavoriteSearch = vm.favouriteList;
    print("init ${initialFavoriteSearch.length}");
    if (query.isNotEmpty) {
      List<FavouriteItemModel> initialFavoriteSearchItems = [];
      initialFavoriteSearch.forEach((item) {
        if (item.favouriteVal.toLowerCase().contains(query.toLowerCase())) {
          initialFavoriteSearchItems.add(item);
          print(initialFavoriteSearchItems.length);
        }
      });
      setState(() {
        print('shak');
        favoriteItems.clear();
        favoriteItems.addAll(initialFavoriteSearchItems);
      });
      return;
    } else {
      setState(() {
        print('sha');
        favoriteItems.clear();
        favoriteItems.addAll(vm.favouriteList);
      });
    }
  }

  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      var vm = context.read<PastIllnessViewModel>();
      await vm.getData();
      var templateVM =
          Provider.of<GetTamplateDataViewModel>(context, listen: false);
      favoriteItems.addAll(vm.favouriteList);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<PastIllnessViewModel>();
    var templateVM = Provider.of<GetTamplateDataViewModel>(context);
    return PrescriptionCommonWidget(
      controller: expandableControllers.pastIllnessController,
      onChangeShowReport: (bool val) {
        templateVM.pastIllnessShowReport = val;
        setState(() {});
      },
      showReport: templateVM.pastIllnessShowReport,
      title: "Past Illness",
      expandedWidget: Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.buttonActiveColor, width: 2)),
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 10, right: 10),
          child: Column(
            children: [
              TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                    textInputAction: TextInputAction.search,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Past Illness",
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppTheme.buttonActiveColor,
                      ),
                      suffixIcon: IconButton(
                          onPressed: () {
                            if (ind != null) {
                              templateVM.pastIllnessSelectedItems[ind] =
                                  controller.text;
                              controller.clear();
                              ind = null;
                            } else {
                              if (controller.text.trim().isNotEmpty) {
                                if (templateVM.pastIllnessSelectedItems
                                    .contains(controller.text.trim())) {
                                  BotToast.showText(text: "All ready added");
                                } else {
                                  templateVM.pastIllnessSelectedItems
                                      .add(controller.text.trim());
                                  controller.clear();
                                }
                              } else {
                                BotToast.showText(text: "Field is empty");
                              }
                            }

                            setState(() {});
                          },
                          icon: Icon(Icons.check,
                              color: AppTheme.buttonActiveColor)),
                    )),
                itemBuilder: (_, v) {
                  return controller.text.isEmpty
                      ? SizedBox()
                      : Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text("$v"),
                        );
                },
                onSuggestionSelected: (v) {
                  if (templateVM.pastIllnessSelectedItems.contains(v)) {
                    BotToast.showText(text: "All ready added");
                  } else {
                    templateVM.pastIllnessSelectedItems.add(v);
                  }
                  setState(() {});
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                suggestionsCallback: (v) {
                  return controller.text.isEmpty
                      ? SizedBox()
                      : PreDiagnosisSearchRepository().fetchSearchList(
                          q: v,
                          favoriteType:
                              PrescriptionFavouriteType.pastIllness.toString());
                },
                // noItemsFoundBuilder: noItemsFoundBuilder ??
                //     (context) {
                //       return SizedBox();
                //     },
              ),
              // TextField(
              //   decoration: InputDecoration(
              //     hintText: "Chief Complaint",
              //     prefixIcon: Icon(
              //       Icons.search,
              //       color: AppTheme.buttonActiveColor,
              //     ),
              //     suffixIcon:
              //         Icon(Icons.check, color: AppTheme.buttonActiveColor),
              //   ),
              // ),
              SizedBox(
                height: 20,
              ),
              Wrap(
                children: List.generate(
                    templateVM.pastIllnessSelectedItems.length,
                    (index) => Container(
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: Color(0xffEFF5FF),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 15, top: 10.0, bottom: 5.0),
                              child: Text(
                                "${templateVM.pastIllnessSelectedItems[index]}",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Divider(
                              thickness: 1,
                            ),
                            Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      List<String> favItem = [];
                                      favoriteItems.map((e) {
                                        favItem.add(e.favouriteVal);
                                      }).toList();
                                      if (favItem.contains(templateVM
                                          .pastIllnessSelectedItems[index])) {
                                        BotToast.showText(
                                            text:
                                                'Already in the favorite list');
                                      } else {
                                        CommonAddToFavoriteListRepository()
                                            .addToFavouriteList(
                                                favoriteType:
                                                    PrescriptionFavouriteType
                                                        .pastIllness
                                                        .toString(),
                                                favoriteVal: templateVM
                                                        .pastIllnessSelectedItems[
                                                    index])
                                            .then((value) async =>
                                                await vm.getData());

                                        favoriteItems.clear();
                                        if (_favoriteController
                                            .text.isNotEmpty) {
                                          searchFavoriteItem(_favoriteController
                                              .text
                                              .toLowerCase());
                                        } else {
                                          favoriteItems = vm.favouriteList;
                                        }
                                      }

                                      // setState(() {});
                                    },
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.text = templateVM
                                          .pastIllnessSelectedItems[index];
                                      ind = index;
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Color(0xffE6374DF)),
                                      child: Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      templateVM.pastIllnessSelectedItems
                                          .removeAt(index);
                                      setState(() {});
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.red),
                                      child: Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Favourite list",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Container(
                          width: 250,
                          child: TextField(
                            onChanged: (value) {
                              searchFavoriteItem(value.toLowerCase());
                              // departmentSearch(value.toUpperCase());
                            },
                            controller: _favoriteController,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.only(left: 10, top: 20),
                              hintText: "Search Favourite list",
                              suffixIcon: Icon(
                                Icons.search,
                                color: AppTheme.buttonActiveColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: favoriteItems.length,
                      itemBuilder: (context, index) {
                        var item = favoriteItems[index];
                        return Container(
                          color: (index % 2 == 0)
                              ? Color(0xffEFF5FF)
                              : Colors.white,
                          child: Padding(
                            padding: EdgeInsets.only(left: 5.0, right: 20.0),
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text("${item.favouriteVal}"),
                              value: item.isCheck,
                              onChanged: (val) {
                                item.isCheck = val;
                                if (val == true) {
                                  if (templateVM.pastIllnessSelectedItems
                                      .contains(item.favouriteVal)) {
                                    BotToast.showText(text: "All ready added");
                                  } else {
                                    templateVM.pastIllnessSelectedItems
                                        .add(item.favouriteVal);
                                  }
                                }
                                setState(() {});
                              },
                              secondary: InkWell(
                                onTap: () async {
                                  SVProgressHUD.show(status: "Deleting");
                                  await DeleteFavoriteLitRepository()
                                      .deleteFavoriteList(
                                          id: vm.favouriteList[index].id)
                                      .then((value) => vm.getData());
                                  SVProgressHUD.dismiss();

                                  favoriteItems.clear();
                                  if (_favoriteController.text.isNotEmpty) {
                                    searchFavoriteItem(
                                        _favoriteController.text.toLowerCase());
                                  } else {
                                    favoriteItems = vm.favouriteList;
                                  }
                                },
                                child: Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
