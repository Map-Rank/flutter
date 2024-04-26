import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';


class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        //backgroundColor: Get.theme.colorScheme.secondary,
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshProfile(showMessage: true);
              controller.onInit();
            },
            child: Container(
              decoration: const BoxDecoration(color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),

              ),
            )
        ),
      ),
    );
  }
}
