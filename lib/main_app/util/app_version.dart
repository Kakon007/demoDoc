import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';
class AppInfoRepository {
  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
//  print(StringsEn.versionText+": " +version);
    return version;
  }

  Future<PackageInfo> getAppPackageInfo() async {
    return await PackageInfo.fromPlatform();
  }


}

class AppVersionWidgetSmall extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: AppInfoRepository().getAppVersion(),
        builder: (c,snapshot){
          if(snapshot.hasData){
            return Text("Version: ${snapshot.data}",style: TextStyle(color: Colors.grey),);
          }
          return SizedBox();
        },
      ),
    );
  }
}

class AppVersionWidgetLowerCase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: AppInfoRepository().getAppVersion(),
        builder: (c,snapshot){
          if(snapshot.hasData){
            return Text("v ${snapshot.data}",style: TextStyle(color: Colors.grey),);
          }
          return SizedBox();
        },
      ),
    );
  }
}
