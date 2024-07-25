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
            const Align(
                alignment:Alignment.center,
                child: Text('Reset Password!', style: TextStyle(fontSize: 30, color: Colors.black, ), )).marginOnly(bottom: 20),

            Align(
              alignment: Alignment.center,
              child: Text('Enter your email address we will send you a mail that will help you to reset your password',
                textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.black45),),
            ).marginOnly(bottom: 40),

            TextFieldWidget(
              isFirst: true,
              readOnly: false,
              labelText: 'Email',
              textController: controller.emailController,
              hintText: "johndoe@gmail.com",
              keyboardType: TextInputType.emailAddress,
              onSaved: (input) => controller.currentUser.value.email = input,
              onChanged: (value) => {
                controller.emailController.text = value
              },
              validator: (input) {
                return !input!.contains('@') ? 'Enter a valid email address' : null;
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
                  'Submit',
                  style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.primaryColor)),
                )
            )).marginOnly(top: 40),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("You remember your password?",style: TextStyle(fontFamily: "poppins", fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal)),
                TextButton(
                  onPressed: () {
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: const Text('Sign in',style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor)),
                ),
              ],
            ).paddingSymmetric(vertical: 20).marginOnly(top: Get.height/20),



          ],
        ),
      ),
    );
  }
}
