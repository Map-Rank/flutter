import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import 'package:mapnrank/common/helper.dart';

class ContactUsView extends GetView<ProfileController> {
  const ContactUsView({super.key});

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
              'Contact us',
              style: TextStyle(color: Colors.black87, fontSize: 30.0),
            ),
            const SizedBox(
              height: 40,
            ),
            const SizedBox(
              height: 60,
              child: Text(
                'For any questions or concerns, do not hesitate to let us know via one of these networks.',
                style: TextStyle(color: Colors.black87, fontSize: 16.0),
              ),
            ),
            const SizedBox(
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  width: 80,
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.02),
                      borderRadius: BorderRadius.circular(14.0)),
                  child: const FaIcon(
                    FontAwesomeIcons.whatsapp,
                    size: 40,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(
                  width: 16,
                ),
                Container(
                  height: 50,
                  width: 80,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.02),
                      borderRadius: BorderRadius.circular(14.0)),
                  child: const FaIcon(
                    FontAwesomeIcons.telegram,
                    size: 40,
                    color: Colors.blue,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}