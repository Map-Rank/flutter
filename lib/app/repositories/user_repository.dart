import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import '../providers/laravel_provider.dart';

class UserRepository {
   late LaravelApiClient _laravelApiClient;



  Future login<int>(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.login(user);
  }

  // Future<User> get(int id) {
  //   _laravelApiClient = Get.find<LaravelApiClient>();
  //   return _laravelApiClient.getUser(id);
  // }

  //  update(User user) {
  //   //print("Nath");
  //    _laravelApiClient = Get.find<LaravelApiClient>();
  //   //print("Nathalie");
  //   return _laravelApiClient.updateUser(user);
  // }

  Future<User> register(User user) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.register(user);
  }

  Future signOut() async {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return await _laravelApiClient.logout();
  }
}
