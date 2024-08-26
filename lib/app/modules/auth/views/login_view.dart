import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
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
               Align(
                  alignment:Alignment.center,
                  child: Text(AppLocalizations.of(context).welcome_back, style: TextStyle(fontSize: 30, color: Colors.black, ), )).marginOnly(bottom: 20),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Obx(() => !controller.loginWithPhoneNumber.value?
                    TextFieldWidget(
                      isFirst: true,
                      readOnly: false,
                      labelText: AppLocalizations.of(context).email,
                      hintText: "johndoe@gmail.com",
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (input) => controller.currentUser.value.email = input,
                      onChanged: (value) => {
                        controller.currentUser.value.email = value
                      },
                      validator: (input) {
                        return !input!.contains('@') ?  AppLocalizations.of(context).enter_valid_email_address : null;
                      },
                      prefixIcon: Image.asset("assets/icons/email.png", width: 22, height: 22),
                      iconData: Icons.mail_outline,
                      key: null, suffixIcon: const Icon(null), suffix: Icon(null),
                    )
                        :Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          AppLocalizations.of(context).phone_number,
                          style: Get.textTheme.labelMedium,
                          textAlign:TextAlign.start,
                        ).paddingOnly(left: 10, right: 20),
                        SizedBox(height: 10,),
                        IntlPhoneField(
                          validator: (phone) {
                            // Check if the field is empty and return null to skip validation
                            if (phone!.completeNumber.isEmpty) {
                              return AppLocalizations.of(context).input_phone_number;
                            }
                            return  AppLocalizations.of(context).input_phone_number;

                          },

                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(borderSide:BorderSide(width: 1, style: BorderStyle.solid, color: Get.theme.focusColor.withOpacity(0.5) ), borderRadius: BorderRadius.circular(10),),
                            border:OutlineInputBorder(borderSide:BorderSide(width: 1, style: BorderStyle.solid, color: Get.theme.focusColor.withOpacity(0.5) ), borderRadius: BorderRadius.circular(10),),
                            contentPadding: EdgeInsets.all(10),
                            labelStyle: TextStyle(
                              color: Colors.white,
                            ),
                            hintText: '677777777',
                            labelText:  AppLocalizations.of(context).phone_number,
                            suffixIcon: Icon(Icons.phone_android_outlined, color: Colors.white,),
                          ),
                          initialCountryCode: 'CM',
                          style:  Get.textTheme.headlineMedium,
                          onSaved: (phone) {
                            controller.currentUser.value.phoneNumber = phone?.completeNumber;
                          },
                          onChanged:(value) => {
                            controller.currentUser.value.phoneNumber = value.completeNumber,
                          },
                        ),
                      ],
                    ),),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {

                            controller.loginWithPhoneNumber.value = !controller.loginWithPhoneNumber.value;
                        },
                        child:  Obx(() => !controller.loginWithPhoneNumber.value?
                        Text(AppLocalizations.of(context).login_with_number,
                          style: TextStyle(fontFamily: "poppins",fontSize: 14,
                            color: interfaceColor,
                          ),
                          overflow: TextOverflow.fade,
                        )
                            :Text(AppLocalizations.of(context).login_with_email,
                          style: TextStyle(fontFamily: "poppins",fontSize: 14,
                            color: interfaceColor,
                          ),
                          overflow: TextOverflow.fade,
                        ),)
                      ),
                    ),

                    Obx(() {
                      return TextFieldWidget(
                        isFirst: true,
                        labelText: AppLocalizations.of(context).password,
                        hintText: "••••••••••••",
                        readOnly: false,
                        //initialValue: controller.password.value,
                        textController: TextEditingController(text: controller.currentUser.value.password),
                        onSaved: (input) => controller.currentUser.value.password = input,
                        onChanged: (value) => {
                           controller.currentUser.value.password = value
                        },
                        validator: (input) {
                          return input!.length < 6 ? AppLocalizations.of(context).enter_six_characters : null;

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
                          if( controller.currentUser.value.email != null){
                            controller.emailController.text = controller.currentUser.value.email!;
                          }
                          Get.toNamed(Routes.FORGOT_PASSWORD);
                        },
                        child:  Text("${AppLocalizations.of(context).forgot_password}?",
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
                        AppLocalizations.of(context).login,
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
                        Text(AppLocalizations.of(context).no_account,style: TextStyle(fontFamily: "poppins", fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal)),
                        TextButton(
                          onPressed: () {
                            Get.offAllNamed(Routes.REGISTER);
                          },
                          child: Text(key: Key('signup'), AppLocalizations.of(context).sign_up,style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor)),
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
