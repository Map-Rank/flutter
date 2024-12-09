import 'package:get/get.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';

import '../../community/controllers/community_controller.dart';
import '../../root/controllers/root_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(
          () => ProfileController(),
    );
    Get.lazyPut<RootController>(
          () => RootController(),
    );
    Get.lazyPut<CommunityController>(
          () => CommunityController(),
    );


  }
}