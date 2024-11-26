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


class InstitutionalUserView extends GetView<AuthController> {

  @override
  Widget build(BuildContext context) {
    controller.institutionalUserFormKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Form(
          key: controller.institutionalUserFormKey,
          child: ListView(
            primary: true,
            children: [
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  //fit: BoxFit.cover,
                  width: 150,
                  height: 130,

                ),
              ).marginOnly(left: 20, right: 20),

              Obx(() =>  !controller.institutionalUserNext.value?
              Align(
                  alignment:Alignment.center,
                  child: Text(AppLocalizations.of(context).institution_information.toUpperCase(), style: TextStyle(fontSize: 20, color: Colors.black, ), ))
                  :Align(
                  alignment:Alignment.center,
                  child: Text(AppLocalizations.of(context).specific_information.toUpperCase(), style: TextStyle(fontSize: 20, color: Colors.black, ), ))
              ).marginOnly(bottom: 20),


              Obx(() =>  !controller.institutionalUserNext.value?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width/4,
                    height: 10,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: Get.width/4,
                    height: 10,
                    decoration:  BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),


                ],)
              :Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width/4,
                    height: 10.0,
                    decoration:  BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: Get.width/4,
                    height: 10.0,
                    decoration: BoxDecoration(
                        color: secondaryColor,
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),


                ],),).marginOnly(bottom: 20),


              Obx(() =>  !controller.institutionalUserNext.value?
              institutionalInformation(context):specificInformation(context),),
            ],

      ),
    )
      )
    );
  }

  Widget institutionalInformation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFieldWidget(
            isLast: true,
            isFirst: true,
            readOnly: false,
            textController: controller.institutionNameController,
            labelText: AppLocalizations.of(context).institution,
            hintText: "Company ltd",
            keyboardType: TextInputType.text,
            onSaved: (input) => controller.currentUser.value.firstName = input,
            onChanged: (value) => {
              controller.currentUser.value.firstName = value,
              controller.institutionNameController.text = value,
            },
            validator: (input) => input!.length < 3 ? AppLocalizations.of(context).enter_three_characters: null,
            iconData: Icons.person, key: null,
            suffixIcon: const Icon(null),
            prefixIcon: Image.asset("assets/icons/user.png", width: 22, height: 22),
            suffix: const Icon(null),
          ),
          TextFieldWidget(
            isLast: true,
            isFirst: true,
            readOnly: false,
            textController: controller.institutionEmailController,
            labelText: AppLocalizations.of(context).email,
            hintText: "institution@gmail.com",
            keyboardType: TextInputType.emailAddress,
            onSaved: (input) => controller.currentUser.value.email = input,
            onChanged: (value) => {
              controller.currentUser.value.email = value,
              controller.institutionEmailController.text = value
            },
            validator: (input){
              return !input!.contains('@') ? AppLocalizations.of(context).enter_valid_email_address: null;
            },
            iconData: Icons.mail_outline, key: null,
            suffixIcon: const Icon(null), suffix: const Icon(null),
            prefixIcon: Image.asset("assets/icons/email.png", width: 22, height: 22),
          ),
          Column(
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
                autovalidateMode: AutovalidateMode.always,
                validator: (phone) {
                  // Check if the field is empty and return null to skip validatio
                  if (phone!.number.isEmpty ) {
                    return AppLocalizations.of(context).input_phone_number;
                  }
                  //return  AppLocalizations.of(context).input_phone_number;

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
          ),
          Obx(() {
            return TextFieldWidget(
              isFirst: true,
              isLast: true,
              labelText: AppLocalizations.of(context).password,
              hintText: "••••••••••••",
              readOnly: false,
              textController: TextEditingController(text: controller.currentUser.value.password),
              onSaved: (input) => controller.currentUser.value.password = input,
              onChanged: (value) => {
                // controller.password.value = value,
                controller.currentUser.value.password = value
              },
              validator: (input) {
                return input!.length < 6 ? AppLocalizations.of(context).enter_six_characters : null;
              },
              obscureText: controller.hidePassword.value,
              iconData: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              suffixIcon: IconButton(
                onPressed: () {
                  controller.hidePassword.value = !controller.hidePassword.value;
                },
                color: Theme.of(context).focusColor,
                icon: Icon(controller.hidePassword.value ? Icons.visibility_outlined : Icons.visibility_off_outlined),
              ),
              prefixIcon: Image.asset("assets/icons/password.png", width: 22, height: 22),
              suffix: const Icon(null),
            );
          }),
          Obx(() {
            return TextFieldWidget(
              isFirst: true,
              labelText: AppLocalizations.of(context).confirm_password,
              hintText: "••••••••••••",
              readOnly: false,
              textController: TextEditingController(text: controller.confirmPassword),
              //initialValue: controller.password.value,
              onSaved: (input) => controller.confirmPassword = input!,
              onChanged: (value) => {
                controller.confirmPassword = value
              },
              validator: (input) {
                return input!.length < 6 ? AppLocalizations.of(context).enter_six_characters : null;
              },
              obscureText: controller.hidePassword.value,
              iconData: Icons.lock_outline,
              keyboardType: TextInputType.visiblePassword,
              prefixIcon: Image.asset("assets/icons/password.png", width: 22, height: 22),
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
          const SizedBox(height: 20),
          Obx(() => BlockButtonWidget(
            onPressed: () {
              // if(controller.password.value==controller.confirmPassword.value)
              // {
              //   controller.register();
              // }

              if (controller.institutionalUserFormKey.currentState!.validate()) {
                controller.institutionalUserFormKey.currentState!.save();

                    print(controller.confirmPassword );
                    print(controller.currentUser.value.password);
                    if(controller.confirmPassword == controller.currentUser.value.password){
                      controller.currentUser.value.zoneId = '1';
                      controller.institutionalUserNext.value = !controller.institutionalUserNext.value;
                    }
                    else{
                      Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).password_not_same.tr));
                    }




              }


            },
            color: Get.theme.colorScheme.secondary,
            text: !controller.loading.value? Text(
              AppLocalizations.of(context).next,
              style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.primaryColor)),
            ): const SizedBox(height: 30,
                child: SpinKitThreeBounce(color: Colors.white, size: 20)),
          ).paddingSymmetric(vertical: 20, horizontal: 20),),


          GestureDetector(
            onTap: (){
              Get.offAllNamed(Routes.LOGIN);
            },
            child: Text(
              "${AppLocalizations.of(context).login} ${AppLocalizations.of(context).or} ${AppLocalizations.of(context).register} ",style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center,)..paddingSymmetric(vertical: 20),
          ),
        ],
      ),

    );
  }


  Widget specificInformation(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(AppLocalizations.of(context).description,
              style: Get.textTheme.labelMedium,
              textAlign: TextAlign.start,
            ).marginOnly(left: 10, top: 20),
            SizedBox(
              width: Get.width,
              height: 70,
              child: TextFormField(
                controller: controller.institutionDescriptionController,
                maxLines: 80,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).institution_description,
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),
                  focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),

                ),
                onChanged: (value) {
                  controller.institutionDescriptionController.text = value;
                },

              ),
            ).marginOnly(bottom: 20),
            Text(AppLocalizations.of(context).instu_logo,
              style: Get.textTheme.labelMedium,
              textAlign: TextAlign.start,
            ).marginOnly(left: 10),

            Row(
              children: [
                Obx(() {
                  if(!controller.loadProfileImage.value) {
                    return buildLoader();
                  } else {
                    return controller.profileImage !=null? ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.file(
                        controller.profileImage,
                        fit: BoxFit.cover,
                        width: 100,
                        height: 100,
                      ),
                    ):
                    buildLoader();
                  }
                }
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () async {

                    await selectCameraOrGalleryProfileImage(context);
                    controller.loadProfileImage.value = false;

                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: Get.theme.focusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                    child: Icon(Icons.add_photo_alternate_outlined, size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
                  ),
                )
              ],
            ).marginOnly(bottom: 20, left: 10),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text( AppLocalizations.of(context).institution_zone, style: Get.textTheme.labelMedium
                ).marginOnly(left: 10),
                Stack(
                    children: <Widget>[
                      Container(
                          decoration: BoxDecoration(
                              color:  Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                              boxShadow: [
                                BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                              ],
                              border: Border.all(color: Get.theme.focusColor.withOpacity(0.5))
                          ),
                          child: DropdownButtonFormField(
                            dropdownColor: Colors.white,
                            decoration: const InputDecoration.collapsed(
                              hintText: '',

                            ),
                            onSaved: (input) => (controller.selectedCoverageZone.value == "National")?controller.currentUser?.value?.zoneId = '1':
                            controller.selectedCoverageZone.value == 'Regional' || controller.selectedCoverageZone.value == 'Régional'? controller.currentUser.value.zoneId = '2'
                                :controller.selectedCoverageZone.value == 'Divisional' || controller.selectedCoverageZone.value == 'Départemental'?controller.currentUser?.value?.zoneId = "3"
                            :controller.currentUser?.value?.zoneId = "4",
                            isExpanded: true,
                            alignment: Alignment.bottomCenter,

                            style: const TextStyle(color: labelColor),
                            value: controller.selectedCoverageZone.value,
                            // Down Arrow Icon
                            icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black,),

                            // Array list of items
                            items: controller.institutionZoneCoverageList.map((String items) {
                              return DropdownMenuItem(
                                value: items,
                                child: Text(items, style: Get.textTheme.headlineMedium, textAlign: TextAlign.center,),
                              );
                            }).toList(),
                            // After selecting the desired option,it will
                            // change button value to selected value
                            onChanged: (String? newValue) {
                              controller.selectedCoverageZone.value = newValue!;
                              if(controller.selectedCoverageZone.value == "National"){
                                controller.currentUser?.value?.zoneId = "1";
                              }
                              else if (controller.selectedCoverageZone.value == 'Regional' || controller.selectedCoverageZone.value == 'Régional'){
                                controller.currentUser?.value?.zoneId = "2";
                              }
                              else if(controller.selectedCoverageZone.value == 'Divisional' || controller.selectedCoverageZone.value == 'Départemental'){
                                controller.currentUser?.value?.zoneId = "3";
                              }
                              else{
                                controller.currentUser?.value?.zoneId = "4";
                              }


                            },).marginOnly(left: 50, right: 20, ).paddingOnly( top: 10, bottom: 10)
                      ).paddingOnly(top: 10, bottom: 20
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20.0, left: 10.0),
                        child: Image.asset("assets/icons/location.png", width: 22, height: 22),
                      ),
                    ]),

              ],),


            const SizedBox(height: 20),

            Row(
              children: [
                Obx(() => Checkbox(
                    activeColor: interfaceColor,
                    value: controller.isConfidentialityChecked.value,
                    onChanged: (value)async{
                      controller.isConfidentialityChecked.value = !controller.isConfidentialityChecked.value;
                    }
                )),
                SizedBox(
                    width: Get.width/1.3,
                    child: Text(AppLocalizations.of(context).accept_terms_of_service,style: TextStyle(fontFamily: "poppins",fontSize: 15, color: Colors.grey.shade800))),
                //Spacer(),
              ],
            ).paddingSymmetric(horizontal: 10),

            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BlockButtonWidget(
                    onPressed: () {

                      controller.institutionalUserNext.value = !controller.institutionalUserNext.value;


                    },
                    color: Get.theme.colorScheme.secondary,
                    text:Text(
                      AppLocalizations.of(context).previous,
                      style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.primaryColor)),
                    )
                ),
                SizedBox(height: 10,),
                BlockButtonWidget(
                    onPressed: () async {
    if (controller.institutionalUserFormKey.currentState!.validate()) {
    controller.institutionalUserFormKey.currentState!.save();
    if(controller.isConfidentialityChecked.value){
      await controller.registerInstitution();
      Get.offAllNamed(Routes.WELCOME_INSTITUTIONAL_USER);
    }
    else{
      Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).please_accept_terms));
    }

    }



                    },
                    color: Get.theme.colorScheme.secondary,
                    text: Obx(() => !controller.loading.value? Text(
                      AppLocalizations.of(context).create_account,
                      style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.primaryColor)),
                    ): const SizedBox(height: 30,
                        child: SpinKitThreeBounce(color: Colors.white, size: 20)),)
                ),
                SizedBox(height: 10,),
                GestureDetector(
                  onTap: (){
                    Get.offAllNamed(Routes.LOGIN);
                  },
                  child: Text(
                    "${AppLocalizations.of(context).login} ${AppLocalizations.of(context).or} ${AppLocalizations.of(context).register} ",style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center,)..paddingSymmetric(vertical: 20),
                ),

              ],
            ).paddingSymmetric(vertical: 20, horizontal: 20),


          ],

        ));
  }

  Widget buildLoader() {
    return SizedBox(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/images/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }
  birthDatePicker(BuildContext context, double height) async {
    DateTime? pickedDate = await showRoundedDatePicker(

      context: context,
      theme: ThemeData.light().copyWith(
          primaryColor: buttonColor
      ),
      height: height,
      initialDate: DateTime.now().subtract(const Duration(days: 365,)),
      firstDate: DateTime(1950),
      lastDate: DateTime(DateTime.now().year),
      styleDatePicker: MaterialRoundedDatePickerStyle(
          textStyleYearButton: const TextStyle(
            fontSize: 52,
            color: Colors.white,
          )
      ),
      borderRadius: 16,
      //selectableDayPredicate: disableDate
    );
    if (pickedDate != null ) {
      //birthDate.value = DateFormat('dd/MM/yy').format(pickedDate);
      controller.birthDateDisplay.text = DateFormat('dd-MM-yyyy').format(pickedDate);
      controller.birthDate.value =DateFormat('yyyy-MM-dd').format(pickedDate);
      controller.currentUser.value.birthdate = controller.birthDate.value;
    }
  }
  selectCameraOrGalleryProfileImage(BuildContext context){
    showDialog(
        context: context,
        builder: (_){
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            content: Container(
                height: 170,
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    ListTile(
                      onTap: ()async{
                        await controller.profileImagePicker('camera');
                        //Navigator.pop(Get.context);


                      },
                      leading: const Icon(FontAwesomeIcons.camera),
                      title: Text(AppLocalizations.of(context).take_picture, style: Get.textTheme.headlineMedium?.merge(const TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await controller.profileImagePicker('gallery');
                        //Navigator.pop(Get.context);

                      },
                      leading: const Icon(FontAwesomeIcons.image),
                      title: Text(AppLocalizations.of(context).upload_image, style: Get.textTheme.headlineMedium?.merge(const TextStyle(fontSize: 15))),
                    )
                  ],
                )
            ),
          );
        });
  }
}
