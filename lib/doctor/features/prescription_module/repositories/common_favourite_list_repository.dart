import 'package:myhealthbd_app/doctor/features/prescription_module/models/favourite_model.dart';
import 'package:myhealthbd_app/doctor/main_app/prescription_favourite_type.dart';
import 'package:myhealthbd_app/main_app/api_client.dart';

class CommonFavouriteListRepository {
  Future<FavouriteListModel> fetchFavouriteList({var favouriteType}) async {
    try {
      var response = await ApiClient().postRequest(
          "prescription-service-api/api/favourites/list",
          {"favouriteType": favouriteType});
      print("favouriteType $favouriteType ${response.body}");
      if (response.statusCode == 200) {
        var body = response.body;
        FavouriteListModel data = favouriteListModelFromJson(body);
        return data;
      } else {
        return FavouriteListModel();
      }
    } catch (e) {
      return FavouriteListModel();
    }
  }
}
