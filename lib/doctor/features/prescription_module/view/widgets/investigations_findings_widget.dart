import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svprogresshud/flutter_svprogresshud.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/models/favourite_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/common_add_to_favorite_list_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/delete_favorite_list_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/investigation_finding_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/repositories/pre_diagnosis_repository.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view/widgets/prescription_common_widget.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view_models/chief_complaint_view_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view_models/get_template_data_view_model.dart';
import 'package:myhealthbd_app/doctor/features/prescription_module/view_models/investigation_findings_view_model.dart';
import 'package:myhealthbd_app/doctor/main_app/prescription_favourite_type.dart';
import 'package:myhealthbd_app/doctor/main_app/views/doctor_form_field.dart';
import 'package:myhealthbd_app/features/auth/view_model/app_navigator.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/views/widgets/custom_searchable_dropdown_from_field.dart';
import 'package:provider/provider.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class InvestigationFindingsWidget extends StatefulWidget {
  const InvestigationFindingsWidget({Key key}) : super(key: key);

  @override
  _InvestigationFindingsWidgetState createState() =>
      _InvestigationFindingsWidgetState();
}

class _InvestigationFindingsWidgetState
    extends State<InvestigationFindingsWidget> {
  bool showReport = false;
  TextEditingController controller = TextEditingController();
  TextEditingController _favoriteController = TextEditingController();
  TextEditingController _findingController = TextEditingController();
  bool isNameSelected = false;
  int ind;
  var vm = appNavigator.context.read<InvestigationFindingsViewModel>();

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

  List<FavouriteItemModel> favoriteItems = [];

  @override
  void initState() {
    Future.delayed(Duration.zero).then((value) async {
      var vm = context.read<InvestigationFindingsViewModel>();
      await vm.getData();
      favoriteItems.addAll(vm.favouriteList);
    });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var vm = context.watch<InvestigationFindingsViewModel>();
    var templateVm = Provider.of<GetTamplateDataViewModel>(context);
    return PrescriptionCommonWidget(
      controller: expandableControllers.investigationFindingController,
      key: Key("InvestigationFindingWidget"),
      onChangeShowReport: (bool val) {
        templateVm.investigationFindingsShowReport = val;
        setState(() {});
      },
      showReport: templateVm.investigationFindingsShowReport,
      title: "Investigation Findings",
      expandedWidget: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10)),
            border: Border.all(color: AppTheme.buttonActiveColor, width: 2)),
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, bottom: 10, left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TypeAheadFormField<String>(
                textFieldConfiguration: TextFieldConfiguration(
                    textInputAction: TextInputAction.search,
                    controller: controller,
                    decoration: InputDecoration(
                      hintText: "Investigation Name",
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppTheme.buttonActiveColor,
                      ),
                      suffixIcon: isNameSelected == false
                          ? IconButton(
                              onPressed: () {
                                setState(() {
                                  FocusScope.of(context).unfocus();
                                  isNameSelected = true;
                                });
                              },
                              icon: Icon(Icons.check,
                                  color: AppTheme.buttonActiveColor))
                          : SizedBox(),
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
                  if (templateVm.investigationFindingItems.contains(v)) {
                    BotToast.showText(text: "All ready added");
                  } else {
                    //showAlert(context, v);
                    // investigationFindingItems.add(
                    //   Findings(name: v)
                    //);
                    controller.text = v;
                  }
                  isNameSelected = true;
                  setState(() {});
                },
                suggestionsBoxDecoration: SuggestionsBoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                ),
                suggestionsCallback: (v) {
                  return controller.text.isEmpty
                      ? SizedBox()
                      : InvestigationFindingRepository().fetchSearchList(
                          q: v,
                          favoriteType: PrescriptionFavouriteType
                              .investigationFindingsSearch
                              .toString());
                },
              ),
              SizedBox(
                height: 20,
              ),
              isNameSelected
                  ? TextField(
                      controller: _findingController,
                      decoration: new InputDecoration(
                        hintStyle: GoogleFonts.poppins(fontSize: 14),
                        suffixIcon: IconButton(
                          onPressed: () {
                            List<Findings> findingList =
                                templateVm.investigationFindingItems;
                            List<String> finding = [];
                            templateVm.investigationFindingItems.map((e) {
                              finding.add(e.name);
                            }).toList();
                            if (ind != null) {
                              print('name $ind');
                              //templateVm.investigationFindingItems.indexOf(Findings(name: controller.text, finding: _findingController.text), ind);
                              templateVm.investigationFindingItems
                                  .removeAt(ind);
                              templateVm.investigationFindingItems.add(Findings(
                                  name: controller.text,
                                  finding: _findingController.text));
                              //   controller.text;
                              isNameSelected = false;
                              _findingController.clear();
                              controller.clear();
                              ind = null;
                              setState(() {});
                            }
                            // else {
                            else if (controller.text.isNotEmpty) {
                              // templateVm.investigationFindingItems.forEach((element) {
                              //   if(element.name==controller.text)
                              //   {
                              //     print('priiiii');
                              //   }
                              // });
                              print('length ${finding.length}');
                              if (finding.contains(controller.text)) {
                                BotToast.showText(text: "All ready added");
                              } else {
                                print('shakil2');
                                templateVm.investigationFindingItems.add(
                                    Findings(
                                        name: controller.text.trim(),
                                        finding: _findingController.text));
                                isNameSelected = false;
                                controller.clear();
                                _findingController.clear();
                              }
                            } else {
                              BotToast.showText(text: "Field is empty");
                            }

                            setState(() {});
                          },
                          icon: Icon(Icons.check),
                          color: AppTheme.buttonActiveColor,
                        ),
                        hintText: 'Findings',
                        contentPadding:
                            EdgeInsets.fromLTRB(15.0, 20.0, 40.0, 0.0),
                      ))
                  : SizedBox(),
              Wrap(
                children: List.generate(
                    templateVm.investigationFindingItems.length,
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
                                "${templateVm.investigationFindingItems[index].name} - ${templateVm.investigationFindingItems[index]?.finding ?? ""}",
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
                                    onTap: () async {
                                      List<String> favItem = [];
                                      favoriteItems.map((e) {
                                        favItem.add(e.favouriteVal);
                                      }).toList();
                                      if (favItem.contains(templateVm
                                          .investigationFindingItems[index]
                                          .name)) {
                                        BotToast.showText(
                                            text:
                                                'Already in the favorite list');
                                      } else {
                                        await CommonAddToFavoriteListRepository()
                                            .addToFavouriteList(
                                                favoriteType:
                                                    PrescriptionFavouriteType
                                                        .investigationFindings
                                                        .toString(),
                                                favoriteVal: templateVm
                                                    .investigationFindingItems[
                                                        index]
                                                    .name)
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
                                    },
                                    child: Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      controller.text = templateVm
                                          .investigationFindingItems[index]
                                          .name;
                                      _findingController.text = templateVm
                                          .investigationFindingItems[index]
                                          .finding;
                                      isNameSelected = true;
                                      ind = index;
                                      setState(() {});
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
                                      templateVm.investigationFindingItems
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
                        return Padding(
                          padding: EdgeInsets.only(left: 5.0, right: 20.0),
                          child: Container(
                            color: (index % 2 == 0)
                                ? Color(0xffEFF5FF)
                                : Colors.white,
                            child: CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              title: Text("${item.favouriteVal}"),
                              value: item.isCheck,
                              onChanged: (val) {
                                item.isCheck = val;
                                if (val == true) {
                                  if (templateVm
                                      .investigationFindingItems.isNotEmpty) {
                                    if (templateVm.investigationFindingItems
                                        .contains(item.favouriteVal)) {
                                      BotToast.showText(
                                          text: "All ready added");
                                    } else {
                                      setState(() {
                                        controller.text = item.favouriteVal;
                                        isNameSelected = true;
                                      });
                                      // showAlert(context, item.favouriteVal);
                                      // Navigator.pop(context);
                                      // investigationFindingItems
                                      //     .add(Findings(name: item.favouriteVal));
                                    }
                                  } else {
                                    setState(() {
                                      controller.text = item.favouriteVal;
                                      isNameSelected = true;
                                    });
                                    // showAlert(context, item.favouriteVal);
                                    // Navigator.pop(context);
                                    // investigationFindingItems
                                    //     .add(Findings(name: item.favouriteVal));
                                  }
                                }
                                setState(() {});
                              },
                              secondary: InkWell(
                                onTap: () async {
                                  SVProgressHUD.show(status: "Deleting");
                                  await DeleteFavoriteLitRepository()
                                      .deleteFavoriteList(id: item.id)
                                      .then(
                                          (value) async => await vm.getData());
                                  SVProgressHUD.dismiss();
                                  // _favoriteController.clear();
                                  favoriteItems.clear();
                                  if (_favoriteController.text.isNotEmpty) {
                                    searchFavoriteItem(
                                        _favoriteController.text.toLowerCase());
                                  } else {
                                    favoriteItems = vm.favouriteList;
                                  }
                                  // favoriteItems.addAll(vm.favouriteList);
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

class Findings {
  String name;
  String finding;
  Findings({this.name, this.finding});
}
