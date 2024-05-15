import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';


class AuthService extends GetxService {
  final user = User().obs;
  GetStorage? _box;

  UserRepository? _usersRepo;

  AuthService() {
    _usersRepo = UserRepository();
    _box = GetStorage();
  }

  Future<AuthService> init() async {
    user.listen((User user) {
      _box?.write('current_user', user.toJson());
    });
    await getCurrentUser();
    return this;
  }

  Future getCurrentUser() async {
    if (User.auth == null && _box!.hasData('current_user')) {
      user.value = User.fromJson(await _box?.read('current_user'));
      User.auth = true;
    } else {
      User.auth = false;
    }
  }

  Future removeCurrentUser() async {
    user.value =  User();
    await _usersRepo?.signOut();
    await _box?.remove('current_user');
  }

  bool get isAuth => User.auth ?? false;

  //String get apiToken => (user.value.auth ?? false) ? user.value.apiToken : '';
}
