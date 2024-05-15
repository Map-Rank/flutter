import 'package:get/get.dart';
import 'package:mapnrank/app/modules/chat_room/controllers/chat_room_controller.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import 'package:mapnrank/app/providers/laravel_provider.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import '../controllers/root_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RootController>(
          () => RootController(),
    );

    Get.lazyPut<AuthService>(
          () => AuthService(),
    );
    Get.lazyPut<LaravelApiClient>(
          () => LaravelApiClient(),
    );
    Get.lazyPut<DashboardController>(
          () => DashboardController(),
    );
    Get.lazyPut<CommunityController>(
          () => CommunityController(),
    );
    Get.lazyPut<ChatRoomController>(
          () => ChatRoomController(),
    );
    Get.lazyPut<ProfileController>(
          () => ProfileController(),
    );
  }
}

