import 'package:get/get.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';

import '../../community/controllers/community_controller.dart';
import '../../root/controllers/root_controller.dart';
import '../controllers/other_user_profile_controller.dart';

class OtherUserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OtherUserProfileController>(
          () => OtherUserProfileController(),
    );
    Get.lazyPut<RootController>(
          () => RootController(),
    );
    Get.lazyPut<CommunityController>(
          () => CommunityController(),
    );


  }
}