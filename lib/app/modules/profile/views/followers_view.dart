import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import 'package:mapnrank/app/routes/app_routes.dart';

class FollowersView extends GetView<ProfileController> {
  const FollowersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Followers',
              style: TextStyle(color: Colors.black87, fontSize: 30.0),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ListView.builder(
                  itemCount: 10,
                  itemBuilder: ((context, index) {
                    return GestureDetector(
                      onTap: (() {
                        // Get.toNamed(Routes.ACCOUNT);
                      }),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16.0),
                        decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.03),
                            borderRadius: BorderRadius.circular(14.0)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(8.0),
                          leading: Container(
                            height: 65,
                            width: 65,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(.05),
                                image: const DecorationImage(
                                    image: AssetImage(
                                        "assets/images/im.jpg"))),
                          ),
                          title: const Padding(
                            padding: EdgeInsets.only(bottom: 6.0),
                            child: Text(
                              'Mvogo Prince',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w700,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          subtitle: const Text(
                            'mvogoP@gmail.com',
                            style: TextStyle(
                                color: Colors.grey, fontSize: 14.0),
                          ),
                          trailing: const Icon(
                            Icons.navigate_next_rounded,
                            size: 24,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    );
                  })),
            )
          ],
        ),
      ),
    );
  }
}
