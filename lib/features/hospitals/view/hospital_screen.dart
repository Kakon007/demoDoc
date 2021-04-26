import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myhealthbd_app/features/dashboard/view_model/hospital_list_view_model.dart';
import 'package:myhealthbd_app/features/hospitals/models/hospital_list_model.dart';
import 'package:myhealthbd_app/main_app/resource/colors.dart';
import 'package:myhealthbd_app/main_app/resource/strings_resource.dart';
import 'package:myhealthbd_app/main_app/views/widgets/SignUpField.dart';
import 'package:myhealthbd_app/features/hospitals/view/widgets/hospitalListCard.dart';
import 'package:provider/provider.dart';
import 'package:after_layout/after_layout.dart';

class HospitalScreen extends StatefulWidget {
  @override
  _HospitalScreenState createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen> with AfterLayoutMixin {
  var accessToken;
  ScrollController _scrollController;
  TextEditingController hospitalController = TextEditingController();
  List<Item> hospitalList;
  var hospitalItems = List<Item>();
  @override
  void afterFirstLayout(BuildContext context) {
    _scrollController = ScrollController();
    Future.delayed(Duration.zero,()async{
      var vm = Provider.of<HospitalListViewModel>(context, listen: false);
      await vm.getData();
      //print(vm.hospitalList.length);
      hospitalList = vm.hospitalList;
      hospitalItems.addAll(hospitalList);
    });
  }

  void hospitalSearch(String query) {
    print(query);
    List<Item> initialHospitalSearch = List<Item>();
    initialHospitalSearch.addAll(hospitalList);
    //print("shakil" + initialHospitalSearch.length.toString());
    if(query.isNotEmpty) {
      List<Item> initialHospitalSearchItems = List<Item>();
      initialHospitalSearch.forEach((item) {
        if(item.companyName.contains(query)) {
          initialHospitalSearchItems.add(item);
        }
      });
      setState(() {
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

  @override
  Widget build(BuildContext context) {
    var searchField = SignUpFormField(
      onChanged: (value) {
        hospitalSearch(value);
        // print(value);
      },
      controller: hospitalController,
      borderRadius: 30,
      hintText: StringResources.searchBoxHint,
      suffixIcon: Padding(
        padding: const EdgeInsets.only(right: 20.0),
        child: Icon(
          Icons.search_rounded,
          color: Colors.grey,
        ),
      ),
    );
    var vm = Provider.of<HospitalListViewModel>(context);
    List<Item> list = vm.hospitalList;
    var length = list.length;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppTheme.appbarPrimary,
        title: Text(
          StringResources.hospitalListAppbar,
          style: GoogleFonts.poppins(fontSize: 15),
        ),
        actions: <Widget>[
          accessToken != null
              ? Container(
                  //margin: EdgeInsets.all(100.0),
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
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: Colors.white,
              size: 20,
            ),
            onPressed: () {},
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            searchField,
            vm.isLoading== true? Center(child: CircularProgressIndicator( valueColor:
            AlwaysStoppedAnimation<Color>(
                AppTheme.appbarPrimary),)):  Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: hospitalItems.length,
                      itemBuilder: (BuildContext context, int index) {
                        return HospitalListCard(
                          hospitalItems[index].companyName,
                          hospitalItems[index].companyAddress == null
                              ? "Mirpur,Dahaka,Bangladesh"
                              : hospitalItems[index].companyAddress,
                          "60 Doctors",
                          hospitalItems[index].companyPhone == null
                              ? "+880 1962823007"
                              : hospitalItems[index].companyPhone,
                          hospitalItems[index].companyEmail == null
                              ? "info@mysoftitd.com"
                              : list[index].companyEmail,
                          hospitalItems[index].companyLogo,
                          hospitalItems[index].companyId,
                          hospitalItems[index].ogNo.toString(),
                          hospitalItems[index].id.toString(),
                        );
                      }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
