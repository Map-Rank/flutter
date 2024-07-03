import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import '../providers/laravel_provider.dart';

class UserRepository {
   late LaravelApiClient _laravelApiClient;
  Future login(UserModel user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.login(user);
  }

   Future logout<int>() {
     _laravelApiClient = Get.find<LaravelApiClient>();
     return _laravelApiClient.logout();
   }



  Future<UserModel> register(UserModel user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.register(user);
  }

  Future signOut() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return await _laravelApiClient.logout();
  }
}
