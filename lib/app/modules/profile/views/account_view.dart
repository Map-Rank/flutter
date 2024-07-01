import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import '../../../../common/helper.dart';

class AccountView extends GetView<ProfileController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refreshProfile(showMessage: true);
          controller.onInit();
        },
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                const SizedBox(
                  height: 50,
                ),
                const Text(
                  'General',
                  style: TextStyle(color: Colors.black87, fontSize: 30.0),
                ),
                const SizedBox(
                  height: 40,
                ),  
            ],
          ),
        ),
      ),
    );
  }
}
