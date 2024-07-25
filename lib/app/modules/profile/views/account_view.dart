import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mapnrank/app/modules/global_widgets/block_button_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import 'package:mapnrank/color_constants.dart';

import '../../../services/global_services.dart';

class AccountView extends GetView<ProfileController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,

        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: interfaceColor),
          onPressed: () => {
            controller.profileImage.value = File('assets/images/loading.gif'),
            controller.loadProfileImage.value = false,
            Navigator.pop(context),
            //Get.back()
          },
        ),
        title: const Text(
          'General',
          style: TextStyle(color: Colors.black87, fontSize: 30.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [

                    Obx(() => !controller.loadProfileImage.value?
                    CircleAvatar(
                      radius: 65,
                      backgroundColor: background,
                      child: Obx(() => CircleAvatar(
                          child: controller.currentUser.value.avatarUrl == null? Text('${controller.currentUser.value.firstName![0].toUpperCase()} ${controller.currentUser.value.lastName![0].toUpperCase()}', style: TextStyle( ),):null ,
                          backgroundColor: background,
                          radius: 65,
                          backgroundImage: controller.currentUser.value.avatarUrl != null?
                          NetworkImage(controller.currentUser.value!.avatarUrl!, headers: GlobalService.getTokenHeaders())
                              :null


                      )),
                    ):
                        CircleAvatar(
                          radius: 65,
                          backgroundColor:  background,
                          child: Image.file(
                            controller.profileImage.value,
                            fit: BoxFit.cover,
                            width: 130,
                            height: 130,
                          ),
                        )
                      ,),


                    Positioned(
                      bottom: 2,
                      right: 3,
                      child: GestureDetector(
                        onTap: () async {

                          controller.selectCameraOrGalleryProfileImage();

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
              ],
            ).marginSymmetric(vertical: 30),

            Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFieldWidget(
                    textController: controller.firstNameController,
                    readOnly: false,
                    labelText: 'First Name',
                    hintText: "Kamdem",
                    //initialValue: '',
                    keyboardType: TextInputType.text,
                    // onSaved: (input) =>
                    //     controller.currentUser.value.firstName = input,
                    onChanged: (value) => {
                      controller.firstNameController.text = value,
                      controller.currentUser.value.firstName = controller.firstNameController.text,
                    },
                    validator: (input) => input!.length < 3
                        ? 'Enter at least 3 characters'
                        : null,
                    iconData: Icons.person,
                    key: null,
                    errorText: '',
                    prefixIcon: const Icon(Icons.person_2_outlined),
                    suffixIcon: const Icon(null),
                    suffix: const Icon(null),
                  ),
                  TextFieldWidget(
                    textController: controller.lastNameController,
                    isFirst: true,
                    readOnly: false,
                    labelText: 'Last Name',
                    hintText: "Flanklin Junior",
                    //initialValue: '',
                    keyboardType: TextInputType.text,
                    // onSaved: (input) =>
                    //     controller.currentUser.value.lastName = input,
                    onChanged: (value) => {
                      controller.lastNameController.text = value,
                      controller.currentUser.value.lastName = controller.lastNameController.text,
                    },
                    validator: (input) => input!.length < 3
                        ? 'Enter at least 3 characters'
                        : null,
                    iconData: Icons.person,
                    key: null,
                    errorText: '',
                    prefixIcon: const Icon(Icons.person_2_outlined),
                    suffixIcon: const Icon(null),
                    suffix: const Icon(null),
                  ),
                  TextFieldWidget(
                    textController: controller.emailController,
                    readOnly: true,
                    labelText: 'Email',
                    hintText: "kamdemj21@gmail.com",
                    //initialValue: '',
                    keyboardType: TextInputType.emailAddress,
                    // onSaved: (input) =>
                    //     controller.currentUser.value.email = input,
                    // onChanged: (value) =>
                    //     {controller.currentUser.value.email = value},
                    validator: (input) {
                      return !input!.contains('@')
                          ? 'Enter a valid email address'
                          : null;
                    },
                    iconData: Icons.alternate_email,
                    key: null,
                    errorText: '',
                    prefixIcon: const Icon(Icons.email_outlined),
                    suffixIcon: const Icon(null),
                    suffix: const Icon(null),
                  ),
                  TextFieldWidget(
                    textController: controller.birthdateController,
                    readOnly: false,
                    labelText: 'Birth date',
                    //hintText: "Male",
                    //initialValue: '',
                    keyboardType: TextInputType.number,
                    // onSaved: (input) =>
                    //     controller.currentUser.value.phoneNumber = input,
                    // onChanged: (value) =>
                    //     {controller.currentUser.value.phoneNumber = value},
                    iconData: Icons.calendar_month,
                    key: null,
                    errorText: '',
                    prefixIcon: Icon(Icons.calendar_month),
                    suffix:const Icon(null), suffixIcon: Icon(null),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Phone Number',
                        style: Get.textTheme.labelMedium,
                        textAlign:TextAlign.start,
                      ).paddingOnly(left: 10, right: 20),
                      SizedBox(height: 10,),
                      IntlPhoneField(
                        initialValue: controller.phoneNumberController.text,
                        validator: (phone) {
                          // Check if the field is empty and return null to skip validation
                          if (phone!.completeNumber.isEmpty) {
                            return 'Input a phone number';
                          }
                          return 'Input a phone number';

                        },

                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(borderSide:BorderSide(width: 1, style: BorderStyle.solid, color: Get.theme.focusColor.withOpacity(0.5) ), borderRadius: BorderRadius.circular(10),),
                          border:OutlineInputBorder(borderSide:BorderSide(width: 1, style: BorderStyle.solid, color: Get.theme.focusColor.withOpacity(0.5) ), borderRadius: BorderRadius.circular(10),),
                          contentPadding: EdgeInsets.all(10),
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          hintText: '677777777',
                          labelText: 'Phone Number',
                          suffixIcon: Icon(Icons.phone_android_outlined, color: Colors.white,),
                        ),
                        //initialCountryCode: 'CM',
                        style:  Get.textTheme.headlineMedium,
                        onSaved: (phone) {
                          controller.currentUser.value.phoneNumber = phone?.completeNumber;
                        },
                        onChanged:(value) => {
                          controller.currentUser.value.phoneNumber = value.completeNumber,
                          print('${value.completeNumber}'),
                        },
                      ),
                    ],
                  ),

                  TextFieldWidget(
                    textController: controller.genderController,
                    readOnly: true,
                    labelText: 'Gender',
                    hintText: "Male",
                    //initialValue: '',
                    keyboardType: TextInputType.number,
                    // onSaved: (input) =>
                    //     controller.currentUser.value.phoneNumber = input,
                    // onChanged: (value) =>
                    //     {controller.currentUser.value.phoneNumber = value},
                    iconData: Icons.person,
                    key: null,
                    errorText: '',
                    prefixIcon:const Icon(Icons.groups_outlined),
                    suffix:const Icon(null), suffixIcon: Icon(null),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Obx(() => !controller.updateUserInfo.value?BlockButtonWidget(
                onPressed: () async {
                  controller.updateUser();
                },
                color: Get.theme.colorScheme.secondary,
                text: Text(
                  'Update Information',
                  style: TextStyle(
                    color: Get.theme.primaryColor,
                    fontSize: 20.0,
                  ),
                )):BlockButtonWidget(
              onPressed: () async {

              },
              color: Get.theme.colorScheme.secondary,
              text: const SizedBox(height: 30,
                  child: SpinKitThreeBounce(color: Colors.white, size: 20)),
            ),)
          ],
        ),
      ),
    );
  }
}