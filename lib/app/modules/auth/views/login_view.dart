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

class LoginView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;



  @override
  Widget build(BuildContext context) {
    controller.loginFormKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
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
              ).marginOnly(left: 20, right: 20, bottom: 20),
              const Align(
                  alignment:Alignment.center,
                  child: Text('WELCOME BACK!', style: TextStyle(fontSize: 30, color: Colors.black, ), )).marginOnly(bottom: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFieldWidget(
                      isFirst: true,
                      readOnly: false,
                      labelText: 'Email',
                      hintText: "johndoe@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => controller.currentUser.value.email = input,
                      onChanged: (value) => {
                        controller.currentUser.value.email = value
                      },
                      validator: (input) {
                        return !input!.contains('@') ? 'Enter a valid email address' : null;
                      },
                      prefixIcon: Image.asset("assets/icons/email.png", width: 22, height: 22),
                      iconData: Icons.mail_outline, 
                      key: null, suffixIcon: const Icon(null), suffix: Icon(null),
                    ),
                    Obx(() {
                      return TextFieldWidget(
                        isFirst: true,
                        labelText: 'Password',
                        hintText: "••••••••••••",
                        readOnly: false,
                        //initialValue: controller.password.value,
                        textController: TextEditingController(text: controller.currentUser.value.password),
                        onSaved: (input) => controller.currentUser.value.password = input,
                        onChanged: (value) => {
                           controller.currentUser.value.password = value
                        },
                        validator: (input) {
                          return input!.length < 6 ? " Enter at least 6 characters" : null;

                        },
                        obscureText: controller.hidePassword.value,
                        iconData: Icons.lock_outline,
                        prefixIcon: Image.asset("assets/icons/password.png", width: 22, height: 22,),
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          onPressed: () {
                            controller.hidePassword.value = !controller.hidePassword.value;
                          },
                          color: Theme.of(context).focusColor,
                          icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                        ),
                        suffix: Icon(null),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Get.toNamed(Routes.FORGOT_PASSWORD);
                        },
                        child: const Text("Forgot password?",
                          style: TextStyle(fontFamily: "poppins",fontSize: 14,
                            color: interfaceColor,
                          ),
                          overflow: TextOverflow.fade,
                        ),
                      ),
                    ),


                    SizedBox(height: 20),
                    Obx(() =>
                    !controller.loading.value?BlockButtonWidget(
                      key: Key('loginButton'),
                      onPressed: () async {
                        await controller.login();

                      },
                      color: Get.theme.colorScheme.secondary,
                      text: Text(
                        'Login',
                        style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.primaryColor)),
                      )
                    ).paddingSymmetric(vertical: 10, horizontal: 20)
                      :BlockButtonWidget(
                      onPressed: () async {

                      },
                      color: Get.theme.colorScheme.secondary,
                      text: const SizedBox(height: 30,
                          child: SpinKitThreeBounce(color: Colors.white, size: 20)),
                    ).paddingSymmetric(vertical: 10, horizontal: 20),),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("You don't have an account",style: TextStyle(fontFamily: "poppins", fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal)),
                        TextButton(
                          onPressed: () {
                            Get.offAllNamed(Routes.REGISTER);
                          },
                          child: Text(key: Key('signup'), 'Sign up',style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor)),
                        ),
                      ],
                    ).paddingSymmetric(vertical: 50),
                  ],
                ),


              ),
            ],
          ),
        ),
      ),
    );
  }
}
