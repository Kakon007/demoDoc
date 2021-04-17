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
  List<Item> dataList = List<Item>();
  var accessToken;
  ScrollController _scrollController;

  @override
  void afterFirstLayout(BuildContext context) {
    _scrollController = ScrollController();
    var vm = Provider.of<HospitalListViewModel>(context, listen: false);
    vm.getData();
  }

  @override
  Widget build(BuildContext context) {
    var searchField = SignUpFormField(
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
            vm.isLoading== true? CircularProgressIndicator():  Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: length,
                    itemBuilder: (BuildContext context, int index) {
                      return HospitalListCard(
                        list[index].companyName,
                        list[index].companyAddress == null
                            ? "Mirpur,Dahaka,Bangladesh"
                            : list[index].companyAddress,
                        "60 Doctors",
                        list[index].companyPhone == null
                            ? "+880 1962823007"
                            : list[index].companyPhone,
                        list[index].companyEmail == null
                            ? "info@mysoftitd.com"
                            : list[index].companyEmail,
                        list[index].companyLogo,
                        list[index].companyId,
                        list[index].ogNo.toString(),
                        list[index].id.toString(),
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
