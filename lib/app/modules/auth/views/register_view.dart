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


class RegisterView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;



  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = GlobalKey<FormState>();
    print(controller.phoneNumber);
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Form(
          key: controller.registerFormKey,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: GestureDetector(
                        onTap: (){
                          controller.loginOrRegister.value = !controller.loginOrRegister.value;
                          Get.offAllNamed(Routes.LOGIN);
                        },
                        child: Obx(() => Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: controller.loginOrRegister.value?interfaceColor:Colors.white,
                              border: Border.all(width: 1, color: interfaceColor)
                          ),
                          child: Text(AppLocalizations.of(context).login, textAlign: TextAlign.center,
                            style: TextStyle(color: controller.loginOrRegister.value?Colors.white:Colors.black),),),)
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        controller.loginOrRegister.value = !controller.loginOrRegister.value;
                        Get.offAllNamed(Routes.REGISTER);
                      },
                      child: Obx(() => Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: controller.loginOrRegister.value?Colors.white:interfaceColor,
                            border: Border.all(width: 1, color: interfaceColor)
                        ),
                        child: Text(AppLocalizations.of(context).register,textAlign: TextAlign.center,
                          style: TextStyle(color: !controller.loginOrRegister.value?Colors.white:Colors.black),),),),
                    ),
                  )


                ],
              ).marginOnly(left: 10, right: 10, bottom: 20),

              Obx(() =>  !controller.registerNext.value?
              Align(
                  alignment:Alignment.center,
                  child: Text(AppLocalizations.of(context).personal_information.toUpperCase(), style: TextStyle(fontSize: 20, color: Colors.black, ), )).marginOnly(bottom: 20)
                  : !controller.registerNextStep1.value?
              Column(children: [Text(AppLocalizations.of(context).specific_information.toUpperCase(), style: TextStyle(fontSize: 20, color: Colors.black, ), ),
                Text(AppLocalizations.of(context).fill_company_information)

              ],).marginOnly(bottom: 20, top: 20)
                  :Column(children: [Text(AppLocalizations.of(context).specific_information.toUpperCase(), style: TextStyle(fontSize: 20, color: Colors.black, ), ),
                Text(AppLocalizations.of(context).fill_location_information)

              ],).marginOnly(bottom: 20, top: 20)
                ,),

              Obx(() =>  !controller.registerNext.value?
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
                  const SizedBox(width: 20,),
                  Container(
                    width: Get.width/4,
                    height: 10.0,
                    decoration:BoxDecoration(
                      color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),

                ],): !controller.registerNextStep1.value?
              Row(
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
                  const SizedBox(width: 20,),
                  Container(
                    width: Get.width/4,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),


                ],)
                  :
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: Get.width/4,
                    height: 10.0,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(8)
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: Get.width/4,
                    height: 10.0,
                    decoration:BoxDecoration(
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
                  const SizedBox(width: 20,),



                ],),).marginOnly(bottom: 20),

              Obx(() =>  !controller.registerNext.value?
              buildPersonalInfo(context):!controller.registerNextStep1.value?
              buildSpecificInfoStep1(context):buildSpecificInfoStep2(context),),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPersonalInfo(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          TextFieldWidget(
            isFirst: true,
            isLast: true,
            readOnly: false,
            textController: controller.firstNameController,
            labelText: AppLocalizations.of(context).first_name,
            hintText: "john",
            keyboardType: TextInputType.text,
            onSaved: (input) => controller.currentUser.value.firstName = input,
            onChanged: (value) => {
              controller.currentUser.value.firstName = value,
              controller.firstNameController.text = value
            },
            validator: (input) => input!.length < 3 ? AppLocalizations.of(context).enter_three_characters: null,
            iconData: Icons.person, key: null,
            suffixIcon: const Icon(null), suffix: Icon(null),
            prefixIcon: Image.asset("assets/icons/user.png", width: 22, height: 22),
          ),
          TextFieldWidget(
            isLast: true,
            isFirst: true,
            readOnly: false,
            textController: controller.lastNameController,
            labelText: AppLocalizations.of(context).last_name,
            hintText: "Doe",
            keyboardType: TextInputType.text,
            onSaved: (input) => controller.currentUser.value.lastName = input,
            onChanged: (value) => {
              controller.currentUser.value.lastName = value,
              controller.lastNameController.text = value,
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
            textController: controller.emailController,
            labelText: AppLocalizations.of(context).email,
            hintText: "johndoe@gmail.com",
            keyboardType: TextInputType.emailAddress,
            onSaved: (input) => controller.currentUser.value.email = input,
            onChanged: (value) => {
              controller.currentUser.value.email = value,
              controller.emailController.text = value
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

          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text( AppLocalizations.of(context).gender, style: Get.textTheme.labelMedium
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

                          validator: (value) {
                            return value ==  AppLocalizations.of(context).select_gender? AppLocalizations.of(context).please_select_gender:null;
                          },
                          dropdownColor: Colors.white,
                          decoration: const InputDecoration.collapsed(
                            hintText: '',

                          ),
                          onSaved: (input) => (controller.selectedGender.value == "Male"||controller.selectedGender.value == "Homme")?controller.currentUser?.value?.gender = "male":
                          controller.selectedGender.value == 'Other'? controller.currentUser.value.gender = 'other':controller.currentUser?.value?.gender = "female",
                          isExpanded: true,
                          alignment: Alignment.bottomCenter,

                          style: const TextStyle(color: labelColor),
                          value: controller.selectedGender.value,
                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.black,),

                          // Array list of items
                          items: controller.genderList.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items, style: Get.textTheme.headlineMedium, textAlign: TextAlign.center,),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            controller.selectedGender.value = newValue!;
                            if(controller.selectedGender.value == "Male"||controller.selectedGender.value == "Homme"){
                              controller.currentUser?.value?.gender = "male";
                            }
                            else if (controller.selectedGender.value == 'Other'){
                              controller.currentUser?.value?.gender = "other";
                            }
                            else{
                              controller.currentUser?.value?.gender = "female";
                            }


                          },).marginOnly(left: 50, right: 20, ).paddingOnly( top: 10, bottom: 10)
                    ).paddingOnly(top: 10, bottom: 20
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20.0, left: 10.0),
                      child: Image.asset("assets/icons/gender.png", width: 22, height: 22),
                    ),
                  ]),

            ],),



          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              InkWell(
                  onTap: ()=>{birthDatePicker(context, Get.height/2) },
                  child: Container(
                    child: TextFieldWidget(
                      onTap: (){
                        birthDatePicker(context, Get.height/2);
                      },
                      isFirst: true,
                      isLast: true,
                      readOnly: true,
                      labelText: AppLocalizations.of(context).date_of_birth,
                      textController: controller.birthDateDisplay,
                      //hintText: "01/01/2024",
                      //initialValue: controller.birthDateDisplay.value,
                      keyboardType: TextInputType.text,
                      validator: (input) => input =="--/--/--" ? AppLocalizations.of(context).please_select_date_of_birth: null,
                      iconData: Icons.person, key: null,
                      suffixIcon: const Icon(null), suffix: Icon(null),
                      prefixIcon: Image.asset("assets/icons/calendar_age.png", width: 22, height: 22),
                    ),
                  )
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

              if (controller.registerFormKey.currentState!.validate()) {
                controller.registerFormKey.currentState!.save();
                if(controller.selectedGender.value != AppLocalizations.of(context).gender){
                  if(controller.birthDate.value == "--/--/--"){
                    Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).please_select_date_of_birth.tr));
                  }
                  else{
                    print(controller.confirmPassword );
                    print(controller.currentUser.value.password);
                    if(controller.confirmPassword == controller.currentUser.value.password){
                      controller.registerNext.value = !controller.registerNext.value;
                    }
                    else{
                      Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).password_not_same.tr));
                    }
                  }
                }
                else{
                  Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).please_select_gender.tr));
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
            Get.offAllNamed(Routes.INSTITUTIONAL_USER);
          },
            child: Text(AppLocalizations.of(context).register_institution,style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center,).paddingSymmetric(vertical: 20)),
        ],
      ),

    );
  }

  Widget buildSpecificInfoStep1(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(AppLocalizations.of(context).profile_picture,
            style: Get.textTheme.labelMedium,
            textAlign: TextAlign.start,
          ).marginOnly(left: 20),
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
          ).marginOnly(bottom: 20, left: 20),

          TextFieldWidget(
            readOnly: false,
            labelText: AppLocalizations.of(context).occupation,
            hintText: "Agricultor",
            keyboardType: TextInputType.text,
            onSaved: (input) => controller.currentUser.value.profession = input,
            onChanged: (value) => {
              controller.currentUser.value.profession = value,
              // controller.currentUser.value.email = controller.email.value
            },
            validator: (input) {
              input!.length < 3 ? AppLocalizations.of(context).enter_three_characters : null;
            },
            isFirst: true,
            iconData: Icons.person, key: null, suffixIcon: Icon(null), suffix: Icon(null),
          ),
          SizedBox(height: 10,),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment:  CrossAxisAlignment.start,
            children: [

              Text(AppLocalizations.of(context).select_sector_title, style:  Get.textTheme.labelMedium,).marginOnly(left: 10, bottom: 20),
              GestureDetector(
                onTap: (){
                  showDialog(context: context,
                    builder: (context) {
                      return Dialog(
                        insetPadding: EdgeInsets.all(20),

                        child: Container(

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextFieldWidget(
                                labelText: AppLocalizations.of(context).select_sector_title,
                                onCancelTapped: (){
                                  Navigator.of(context).pop();
                                },
                                selection: true,
                                isFirst: true,
                                readOnly: false,
                                keyboardType: TextInputType.text,
                                validator: (input) => input!.isEmpty ? AppLocalizations.of(context).required_field : null,
                                iconData: FontAwesomeIcons.search,
                                style: const TextStyle(color: labelColor),
                                hintText: AppLocalizations.of(context).select_search_sector,
                                onChanged: (value)=>{
                                  controller.filterSearchSectors(value)
                                },
                                suffixIcon: const Icon(null), suffix: const Icon(null),
                              ),
                              controller.loadingSectors.value ?
                              Column(
                                children: [
                                  for(var i=0; i < 4; i++)...[
                                    Container(
                                        width: Get.width,
                                        height: 60,
                                        margin: const EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          child: Image.asset(
                                            'assets/images/loading.gif',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 40,
                                          ),
                                        ))
                                  ]
                                ],
                              ) :
                              Container(
                                  margin: const EdgeInsetsDirectional.only(end: 10, start: 10, ),
                                  // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                                    ],
                                  ),

                                  child: ListView.builder(
                                    //physics: AlwaysScrollableScrollPhysics(),
                                      itemCount:controller.sectors.length,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, index) {

                                        return GestureDetector(
                                            onTap: () async {


                                              controller.selectedIndex. value = index;
                                              if(controller.sectorsSelected.contains(controller.sectors[index]) ){
                                                controller.sectorsSelected.remove(controller.sectors[index]);
                                              }
                                              else{
                                                controller.sectorsSelected.add(controller.sectors[index]);
                                                //print(controller.sectors[index]);
                                                controller.currentUser.value.sectors =[controller.sectors[index]['id']];
                                              }



                                            },
                                            child: Obx(() => SectorItemWidget(
                                              sectorName: controller.sectors[index]['name'],
                                              selected: controller.sectorsSelected.contains(controller.sectors[index])? true : false,
                                            ).marginOnly(bottom: 5))
                                        );
                                      })
                              )
                            ],
                          ).marginOnly(bottom: 20),
                        ),
                      );

                    },);
                },
                child: Container(
                    decoration: BoxDecoration(shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Get.theme.focusColor.withOpacity(0.5))),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: Get.height*0.35,
                          child: Wrap(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            // crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Obx(() => controller.sectorsSelected.isEmpty?
                              Text(AppLocalizations.of(context).choose_sector, style: Get.theme.textTheme.headlineMedium!.merge(TextStyle(color: Colors.grey, fontSize: 18),)):
                              RichText(text: TextSpan(
                                  children:[
                                    for(var sector in controller.sectorsSelected)...[
                                      TextSpan(text: '${sector['name']}, ',style: Get.textTheme.headlineMedium, )
                                    ]
                                  ]
                              )),),

                            ],
                          ),
                        ),
                        FaIcon(FontAwesomeIcons.angleDown, size: 10,)
                      ],
                    )

                ),
              )
            ],
          ),




          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Obx(() => BlockButtonWidget(
                onPressed: () {
                  controller.registerNext.value = !controller.registerNext.value;
                },
                color: Get.theme.colorScheme.secondary,
                text: !controller.loading.value? Text(
                  AppLocalizations.of(context).previous,
                  style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.primaryColor)),
                ): const SizedBox(height: 30,
                    child: SpinKitThreeBounce(color: Colors.white, size: 20)),
              )),
              SizedBox(height: 10,),
              BlockButtonWidget(
                  onPressed: () {
                    if(controller.sectorsSelected.isEmpty){
                      Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).please_select_one_sector));
                    }
                    else{
                      controller.registerNextStep1.value = !controller.registerNextStep1.value;
                    }

                  },
                  color: Get.theme.colorScheme.secondary,
                  text: Text(
                    AppLocalizations.of(context).next,
                    style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.primaryColor)),
                  )
              ),
            ],).paddingSymmetric(vertical: 20, horizontal: 20),

          SizedBox(height: 10,),


    GestureDetector(
      onTap: () {
        Get.offAllNamed(Routes.INSTITUTIONAL_USER);
      },
        child: Text(AppLocalizations.of(context).register_institution,style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center,)..paddingSymmetric(vertical: 20)),
        ],
      ),

    );
  }

  Widget buildSpecificInfoStep2(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(children: [
                  TextSpan(text: AppLocalizations.of(context).choose_your_region, style:  Get.textTheme.labelMedium,),
                  TextSpan(text: '(${AppLocalizations.of(context).mandatory})', style: TextStyle(color: Colors.red))
                ])).marginOnly(left: 10, bottom: 20),
                GestureDetector(
                  onTap: (){
                    showDialog(context: context, builder: (context){
                      return Dialog(
                        insetPadding: EdgeInsets.all(20),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: Column(
                            children: [
                              TextFieldWidget(
                                labelText: AppLocalizations.of(context).choose_your_region,
                                isFirst: true,
                                readOnly: false,
                                keyboardType: TextInputType.text,
                                validator: (input) => input!.isEmpty ? 'Required field' : null,
                                //onChanged: (input) => controller.selectUser.value = input,
                                //labelText: "Research receiver".tr,
                                iconData: FontAwesomeIcons.search,
                                style: const TextStyle(color: Colors.black),
                                hintText: AppLocalizations.of(context).search_region_name,
                                onChanged: (value)=>{
                                  controller.filterSearchRegions(value)
                                },
                                suffixIcon: const Icon(null), suffix: const Icon(null),
                              ),
                              controller.loadingRegions.value ?
                              Column(
                                children: [
                                  for(var i=0; i < 4; i++)...[
                                    Container(
                                        width: Get.width,
                                        height: 60,
                                        margin: const EdgeInsets.all(5),
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          child: Image.asset(
                                            'assets/images/loading.gif',
                                            fit: BoxFit.cover,
                                            width: double.infinity,
                                            height: 40,
                                          ),
                                        ))
                                  ]
                                ],
                              ) :
                              Container(
                                height: Get.height*0.7,
                                  margin: const EdgeInsetsDirectional.only(end: 10, start: 10, ),
                                  // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                                    ],
                                  ),

                                  child: ListView.builder(
                                    //physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: controller.regions.length,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, index) {

                                        return GestureDetector(
                                            onTap: () async {
                                              //controller.regionSelectedValue.clear();
                                              if(controller.regionSelectedValue.contains(controller.regions[index]) ){
                                                controller.regionSelectedValue.clear();
                                                controller.regionSelectedValue.remove(controller.regions[index]);

                                              }
                                              else{
                                                controller.regionSelectedValue.clear();
                                                controller.regionSelectedValue.add(controller.regions[index]);
                                                controller.currentUser.value.zoneId = controller.regions[index]['id'].toString();

                                              }
                                              controller.regionSelected.value = !controller.regionSelected.value;
                                              controller.regionSelectedIndex.value = index;
                                              controller.divisionsSet = await controller.getAllDivisions(index);
                                              controller.listDivisions.value =  controller.divisionsSet['data'];
                                              controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                              controller.divisions.value =  controller.listDivisions;
                                              Navigator.of(context).pop();

                                              print(controller.regionSelected);

                                            },
                                            child: Obx(() => LocationWidget(
                                              regionName: controller.regions[index]['name'],
                                              selected: controller.regionSelectedIndex.value == index && controller.regionSelectedValue.contains(controller.regions[index]) ? true  : false ,
                                            ))
                                        );
                                      })
                              )
                            ],
                          ),

                        ),

                      );

                    },);

                  },
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Get.theme.focusColor.withOpacity(0.5))),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => controller.regionSelectedValue.isNotEmpty?
                        Text(controller.regionSelectedValue[0]['name'], style: Get.textTheme.headlineMedium,)
                            :Text(AppLocalizations.of(context).choose_your_region, style: Get.theme.textTheme.headlineMedium!.merge(TextStyle(color: Colors.grey, fontSize: 18),)),
                        ),
                        FaIcon(FontAwesomeIcons.angleDown, size: 10,)
                      ],
                    ),
                  ),
                )
              ],
            ).marginOnly(bottom: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(children: [
                  TextSpan(text: AppLocalizations.of(context).choose_your_division, style:  Get.textTheme.labelMedium,),
                  TextSpan(text: '(${AppLocalizations.of(context).optional}...)', style: TextStyle(color: Colors.grey.shade600))
                ])).marginOnly(left: 10, bottom: 20),
                GestureDetector(
                  onTap: (){
                    if(controller.regionSelectedValue.isEmpty){
                      Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).select_region_first));
                    }
                    else{
                      showDialog(context: context, builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.all(20),
                          child: Container(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  Obx(() =>
                                      Column(
                                        children: [
                                          TextFieldWidget(
                                            isFirst: true,
                                            isLast:true,
                                            labelText: AppLocalizations.of(context).choose_your_division,
                                            readOnly: false,
                                            keyboardType: TextInputType.text,
                                            validator: (input) => input!.isEmpty ? AppLocalizations.of(context).required_field : null,
                                            //onChanged: (input) => controller.selectUser.value = input,
                                            //labelText: "Research receiver".tr,
                                            iconData: FontAwesomeIcons.search,
                                            style: const TextStyle(color: Colors.black),
                                            hintText: AppLocalizations.of(context).search_division_name,
                                            onChanged: (value)=>{
                                              controller.filterSearchDivisions(value)
                                            },
                                            suffixIcon: const Icon(null), suffix: const Icon(null),
                                          ),
                                          controller.loadingDivisions.value ?
                                          Column(
                                            children: [
                                              for(var i=0; i < 4; i++)...[
                                                Container(
                                                    width: Get.width,
                                                    height: 60,
                                                    margin: const EdgeInsets.all(5),
                                                    child: ClipRRect(
                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                      child: Image.asset(
                                                        'assets/images/loading.gif',
                                                        fit: BoxFit.cover,
                                                        width: double.infinity,
                                                        height: 40,
                                                      ),
                                                    ))
                                              ]
                                            ],
                                          ) :
                                          Container(
                                              height: Get.height*0.65,
                                              margin: const EdgeInsetsDirectional.only(end: 10, start: 10, top: 10, bottom: 10),
                                              // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                              decoration: BoxDecoration(
                                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                color: Colors.white,
                                                boxShadow: [
                                                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                                                ],
                                              ),

                                              child: ListView.builder(
                                                //physics: AlwaysScrollableScrollPhysics(),
                                                  itemCount: controller.divisions.length,
                                                  shrinkWrap: true,
                                                  primary: false,
                                                  itemBuilder: (context, index) {

                                                    return GestureDetector(
                                                        onTap: () async{
                                                          if(controller.divisionSelectedValue.contains(controller.divisions[index]) ){
                                                            controller.divisionSelectedValue.clear();
                                                            controller.divisionSelectedValue.remove(controller.divisions[index]);
                                                          }
                                                          else{
                                                            controller.divisionSelectedValue.clear();
                                                            controller.divisionSelectedValue.add(controller.divisions[index]);
                                                            controller.currentUser.value.zoneId = controller.divisions[index]['id'].toString();
                                                          }
                                                          controller.divisionSelected.value = !controller.divisionSelected.value;
                                                          controller.divisionSelectedIndex.value = index;
                                                          controller.subdivisionsSet = await controller.getAllSubdivisions(index);
                                                          controller.listSubdivisions.value = controller.subdivisionsSet['data'];
                                                          controller.loadingSubdivisions.value = !controller.subdivisionsSet['status'];
                                                          controller.subdivisions.value = controller.listSubdivisions;
                                                          Navigator.of(context).pop();
                                                          print(controller.subdivisionSelectedValue[0]['id'].toString());

                                                        },
                                                        child: Obx(() => LocationWidget(
                                                          regionName: controller.divisions[index]['name'],
                                                          selected: controller.divisionSelectedIndex.value == index && controller.divisionSelectedValue.contains(controller.divisions[index]) ? true  : false ,
                                                        ))
                                                    );
                                                  })
                                          )
                                        ],
                                      ),
                                  ).marginOnly(bottom: 20),
                                ],
                              )
                          ),

                        );
                      },);
                    }

                  },
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Get.theme.focusColor.withOpacity(0.5))),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => controller.divisionSelectedValue.isNotEmpty?
                        Text(controller.divisionSelectedValue[0]['name'], style: Get.textTheme.headlineMedium,):
                        Text(AppLocalizations.of(context).choose_your_division, style: Get.theme.textTheme.headlineMedium!.merge(TextStyle(color: Colors.grey, fontSize: 18),))),

                        FaIcon(FontAwesomeIcons.angleDown, size: 10,)
                      ],
                    ),
                  ),
                )
              ],
            ).marginOnly(bottom: 20),

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment:  CrossAxisAlignment.start,
              children: [
                RichText(text: TextSpan(children: [
                  TextSpan(text: AppLocalizations.of(context).choose_your_subdivision, style:  Get.textTheme.labelMedium,),
                  TextSpan(text: '(${AppLocalizations.of(context).optional}...)', style: TextStyle(color: Colors.grey.shade600))
                ])).marginOnly(left: 10, bottom: 20),
                GestureDetector(
                  onTap: (){
                    if(controller.divisionSelectedValue.isEmpty){
                      Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).select_region_division_first));
                    }
                    else{
                      showDialog(context: context, builder: (context) {
                        return Dialog(
                          insetPadding: EdgeInsets.all(20),
                          child: Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                TextFieldWidget(
                                  isFirst: true,
                                  labelText: AppLocalizations.of(context).subdivision,
                                  readOnly: false,
                                  keyboardType: TextInputType.text,
                                  validator: (input) => input!.isEmpty ? AppLocalizations.of(context).required_field : null,
                                  //onChanged: (input) => controller.selectUser.value = input,
                                  //labelText: "Research receiver".tr,
                                  iconData: FontAwesomeIcons.search,
                                  style: const TextStyle(color: labelColor),
                                  hintText: AppLocalizations.of(context).search_subdivision_name,
                                  onChanged: (value)=>{
                                    controller.filterSearchSubdivisions(value)
                                  },
                                  suffixIcon: const Icon(null), suffix: const Icon(null),
                                ),
                                controller.loadingSubdivisions.value ?
                                Column(
                                  children: [
                                    for(var i=0; i < 4; i++)...[
                                      Container(
                                          width: Get.width,
                                          height: 60,
                                          margin: const EdgeInsets.all(5),
                                          child: ClipRRect(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                            child: Image.asset(
                                              'assets/images/loading.gif',
                                              fit: BoxFit.cover,
                                              width: double.infinity,
                                              height: 40,
                                            ),
                                          ))
                                    ]
                                  ],
                                ) :
                                Container(
                                    height: Get.height*0.7,
                                    margin: const EdgeInsetsDirectional.only(end: 10, start: 10, top: 5, bottom: 5),
                                     //padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                                      ],
                                    ),

                                    child: ListView.builder(
                                      //physics: AlwaysScrollableScrollPhysics(),
                                        itemCount:  controller.subdivisions.length,
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, index) {

                                          return GestureDetector(
                                              onTap: () async {

                                                if(controller.subdivisionSelectedValue.contains(controller.subdivisions[index]) ){
                                                  controller.subdivisionSelectedValue.clear();
                                                  controller.subdivisionSelectedValue.remove(controller.subdivisions[index]);
                                                }
                                                else{
                                                  controller.subdivisionSelectedValue.clear();
                                                  controller.subdivisionSelectedValue.add(controller.subdivisions[index]);
                                                  controller.currentUser.value.zoneId = controller.subdivisions[index]['id'].toString();
                                                }
                                                controller.subdivisionSelected.value = !controller.subdivisionSelected.value;
                                                controller.subdivisionSelectedIndex.value = index;


                                                print(controller.subdivisions);

                                                controller.currentUser.value.zoneId = controller.subdivisionSelectedValue[0]['id'].toString();

                                                Navigator.of(context).pop();


                                                //print(controller.subdivisionSelected);

                                              },
                                              child: Obx(() => LocationWidget(
                                                regionName: controller.subdivisions[index]['name'],
                                                selected: controller.subdivisionSelectedIndex.value == index && controller.subdivisionSelectedValue.contains(controller.subdivisions[index]) ? true  : false ,
                                              ))
                                          );
                                        })
                                )
                              ],
                            ),

                          ),
                        );
                      },);
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Get.theme.focusColor.withOpacity(0.5))),
                    padding: EdgeInsets.all(20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Obx(() => controller.subdivisionSelectedValue.isEmpty?
                        Text(AppLocalizations.of(context).choose_your_subdivision, style: Get.theme.textTheme.headlineMedium!.merge(TextStyle(color: Colors.grey, fontSize: 18))):
                        Text(controller.subdivisionSelectedValue[0]['name'], style: Get.theme.textTheme.headlineMedium,),)
                        ,
                        FaIcon(FontAwesomeIcons.angleDown, size: 10,)
                      ],
                    ),
                  ),
                )
              ],
            ).marginOnly(bottom: 20),


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

                      controller.registerNextStep1.value = !controller.registerNextStep1.value;


                    },
                    color: Get.theme.colorScheme.secondary,
                    text:Text(
                      AppLocalizations.of(context).previous,
                      style: Get.textTheme.headlineSmall?.merge(TextStyle(color: Get.theme.primaryColor)),
                    )
                ),
                SizedBox(height: 10,),
                BlockButtonWidget(
                    onPressed: () {
                      //controller.login(),
                      //controller.registerNext.value = !controller.registerNext.value;
                      if(controller.regionSelectedValue.isEmpty){
                        Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).please_select_location));
                      }
                      else{
                        if(controller.isConfidentialityChecked.value){
                          controller.register();
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
                )

              ],
            ).paddingSymmetric(vertical: 20, horizontal: 20),
            SizedBox(height: 10,),

        GestureDetector(
          onTap: (){
            Get.offAllNamed(Routes.INSTITUTIONAL_USER);
          },
            child: Text(AppLocalizations.of(context).register_institution,style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor, fontWeight: FontWeight.w500), textAlign: TextAlign.center,).paddingSymmetric(vertical: 20)),
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
