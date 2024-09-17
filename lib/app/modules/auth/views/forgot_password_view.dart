import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/global_widgets/block_button_widget.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import 'package:mapnrank/app/services/settings_services.dart';
import 'package:mapnrank/common/helper.dart';
import 'package:mapnrank/common/ui.dart';
import '../../../../color_constants.dart';
import '../../../models/setting_model.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPasswordView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;



  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = GlobalKey<FormState>();
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 0,
        systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Color(0xff021d40)),
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: controller.loginFormKey,
        child: ListView(
          padding: EdgeInsets.all(20),
          primary: true,
          children: [
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/logo.png',
                //fit: BoxFit.cover,
                width: 150,
                height: 150,

              ),
            ).marginOnly(left: 20, right: 20, bottom: 20, top: Get.height/10),
            Align(
                alignment:Alignment.center,
                child: Text('${AppLocalizations.of(context).reset_password}!', style: TextStyle(fontSize: 30, color: Colors.black, ), )).marginOnly(bottom: 20),

            Align(
              alignment: Alignment.center,
              child: Text(AppLocalizations.of(context).reset_password_explanation,
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black45),),
            ).marginOnly(bottom: 40),

            TextFieldWidget(
              isFirst: true,
              readOnly: false,
              labelText: AppLocalizations.of(context).email,
              textController: controller.emailController,
              hintText: "johndoe@gmail.com",
              keyboardType: TextInputType.emailAddress,
              onSaved: (input) => controller.currentUser.value.email = input,
              onChanged: (value) => {
                controller.emailController.text = value
              },
              validator: (input) {
                return !input!.contains('@') ? AppLocalizations.of(context).enter_valid_email_address : null;
              },
              prefixIcon: Image.asset("assets/icons/email.png", width: 22, height: 22),
              iconData: Icons.mail_outline,
              key: null, suffixIcon: const Icon(null), suffix: Icon(null),
            ),

            Obx(() => controller.loading.value?BlockButtonWidget(
              onPressed: () async {

              },
              color: Get.theme.colorScheme.secondary,
              text: const SizedBox(height: 30,
                  child: SpinKitThreeBounce(color: Colors.white, size: 20)),
            ): BlockButtonWidget(
                onPressed: () {
                  controller.resetPassword(controller.emailController.text);

                },
                color: Get.theme.colorScheme.secondary,
                text:Text(
                  AppLocalizations.of(context).submit,
                  style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.primaryColor)),
                )
            )).marginOnly(top: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context).remember_password,style: TextStyle(fontFamily: "poppins", fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal)),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: Text(AppLocalizations.of(context).sign_in,style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor)),
                ),
              ],
            ).paddingSymmetric(vertical: 20).marginOnly(top: Get.height/20),



          ],
        ),
      ),
    );
  }
}
