import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:intl_phone_field/phone_number.dart';
import 'package:mapnrank/app/modules/global_widgets/block_button_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/location_widget.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import 'package:mapnrank/app/services/settings_services.dart';
import 'package:mapnrank/common/helper.dart';
import 'package:mapnrank/common/ui.dart';
import '../../../../color_constants.dart';
import '../../../models/setting_model.dart';
import '../../global_widgets/sector_item_widget.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class WelcomeInstitutionalUserView extends GetView<AuthController> {

  @override
  Widget build(BuildContext context) {
    controller.progress.value = 0.0;
    controller.startProgress();
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: ListView(
        primary: true,
        children: [
          Obx(() =>LinearProgressIndicator(
            value: controller.progress.value, // Current progress
            color: interfaceColor,
            backgroundColor: interfaceColor.withOpacity(0.1),
          ).marginOnly(bottom: 20) ,),

          Align(
            alignment: Alignment.center,
            child: Image.asset(
              'assets/images/logo.png',
              //fit: BoxFit.cover,
              width: 150,
              height: 130,

            ),
          ).marginOnly(left: 20, right: 20, top: 60, bottom: 60),

          Align(
            alignment: Alignment.center,
            child: Text('Welcome To Residat!', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),),
          ).marginOnly(left: 20, right: 20,  bottom: 40),

          Align(
            alignment: Alignment.center,
            child: Text('As an institutional account, some verifications need to be done on your account'
            '. Our administrative will contact you, then work you through this easy process. Thanks for choosing Residat',
            style: Get.textTheme.displaySmall?.merge(TextStyle(color: Colors.grey, )),
            textAlign: TextAlign.justify,).marginOnly(left: 20, right: 20, ),
          )

        ],
      ),
    );
  }

}
