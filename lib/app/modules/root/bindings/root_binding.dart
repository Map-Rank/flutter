import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/providers/laravel_provider.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import '../../notifications/controllers/notification_controller.dart';
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
          () => LaravelApiClient(dio: Dio()),
    );
    Get.lazyPut<DashboardController>(
          () => DashboardController(),
    );
    Get.lazyPut<CommunityController>(
          () => CommunityController(), fenix: true
    );
    Get.lazyPut<NotificationController>(
          () => NotificationController(),
    );
    Get.lazyPut<EventsController>(
          () => EventsController(),
    );
  }
}

