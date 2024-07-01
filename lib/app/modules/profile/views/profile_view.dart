import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import 'package:mapnrank/color_constants.dart';
import '../../../../common/helper.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 50,
              ),
              const Text(
                'Profile',
                style: TextStyle(color: Colors.black87, fontSize: 30.0),
              ),
              const SizedBox(
                height: 40,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 65,
                        backgroundImage: AssetImage("assets/images/im.jpg"),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 3,
                        child: GestureDetector(
                          onTap: () async {
                            // Uint8List imga =
                            //     await getImage(ImageSource.gallery);
                            // setState(() {
                            //   img = imga;
                            //   base64Image = base64Encode(imga);
                            // });
                          },
                          child: Container(
                            height: 32,
                            width: 32,
                            decoration: const BoxDecoration(
                                color: interfaceColor,
                                shape: BoxShape.circle),
                            child: const Icon(
                              Icons.edit,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            'Flanklin Junior',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 20.0,
                            ),
                          ),
                        ),
        
                        //email;phone;last name;Firts name;birth Date;password;
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.ARTICLES);
                              },
                              child: const SizedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      '5',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Articles',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const Padding(
                              padding:
                                  EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text(
                                '|',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 14.0),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.FOLLOWERS);
                              },
                              child: const SizedBox(
                                child: Column(
                                  children: [
                                    Text(
                                      '50',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.0),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Followers',
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 14.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: (() {
                  Get.toNamed(Routes.ACCOUNT);
                }),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.03),
                      borderRadius: BorderRadius.circular(14.0)),
                  child: ListTile(
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(.05)),
                      child: const Icon(
                        Icons.settings_rounded,
                        size: 26,
                        color: Colors.black,
                      ),
                    ),
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        'General',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    subtitle: const Text(
                      'Account',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_rounded,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: (() {
                  Get.toNamed(Routes.CONTACT_US);
                }),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.03),
                      borderRadius: BorderRadius.circular(14.0)),
                  child: ListTile(
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(.05)),
                      child: const Icon(
                        Icons.call,
                        size: 26,
                        color: Colors.black,
                      ),
                    ),
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        'Contact us',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    subtitle: const Text(
                      'whatsapp, telegram',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_rounded,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              GestureDetector(
                onTap: (() {}),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.03),
                      borderRadius: BorderRadius.circular(14.0)),
                  child: ListTile(
                    leading: Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(.05)),
                      child: const Icon(
                        Icons.exit_to_app_rounded,
                        size: 27,
                        color: Colors.black,
                      ),
                    ),
                    title: const Padding(
                      padding: EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        'Sign out',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                    subtitle: const Text(
                      'To go out',
                      style: TextStyle(color: Colors.grey, fontSize: 14.0),
                    ),
                    trailing: const Icon(
                      Icons.navigate_next_rounded,
                      size: 24,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Version 0.1-2024',
                    style: TextStyle(color: Colors.grey, fontSize: 12.0),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
