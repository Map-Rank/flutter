import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/global_widgets/block_button_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/location_widget.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import 'package:mapnrank/app/services/settings_services.dart';
import 'package:mapnrank/common/helper.dart';
import 'package:mapnrank/common/ui.dart';
import '../../../../color_constants.dart';
import '../../../models/setting_model.dart';
import '../../global_widgets/text_field_widget.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  final Setting _settings = Get.find<SettingsService>().setting.value;



  @override
  Widget build(BuildContext context) {
    controller.registerFormKey = GlobalKey<FormState>();
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: controller.registerFormKey,
          child: ListView(
            primary: true,
            children: [
              //

              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  //fit: BoxFit.cover,
                  width: 150,
                  height: 150,

                ),
              ).marginOnly(left: 20, right: 20, bottom: 20),

              Obx(() =>  !controller.registerNext.value?
              const Align(
                  alignment:Alignment.center,
                  child: Text('PERSONAL INFORMATION', style: TextStyle(fontSize: 20, color: Colors.black, ), )).marginOnly(bottom: 20)
                  : !controller.registerNextStep1.value?
               Column(children: const [Text('SPECIFIC INFORMATION', style: TextStyle(fontSize: 20, color: Colors.black, ), ),
                Text('Fill out company related information')

              ],).marginOnly(bottom: 20, top: 20)
                  :Column(children: const [Text('SPECIFIC INFORMATION', style: TextStyle(fontSize: 20, color: Colors.black, ), ),
                Text('Fill out location information')

              ],).marginOnly(bottom: 20, top: 20)
                ,),

              Obx(() =>  !controller.registerNext.value?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: interfaceColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),

                ],): !controller.registerNextStep1.value?
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: interfaceColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),


                ],)
                :
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 20,),
                  Container(
                    width: 10.0,
                    height: 10.0,
                    decoration: const BoxDecoration(
                      color: interfaceColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 20,),



                ],),),

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
            readOnly: false,
            labelText: 'First Name',
            hintText: "john",
            initialValue: '',
            keyboardType: TextInputType.text,
            onSaved: (input) => controller.currentUser.value.firstName = input,
            onChanged: (value) => {
              controller.currentUser.value.firstName = value,
            },
            validator: (input) => input!.length < 3 ? 'Enter at least 3 characters': null,
            iconData: Icons.person, key: null, errorText: '', suffixIcon: const Icon(null), suffix: Icon(null),
          ),
          TextFieldWidget(
            readOnly: false,
            labelText: 'Last Name',
            hintText: "Doe",
            initialValue: '',
            keyboardType: TextInputType.text,
            onSaved: (input) => controller.currentUser.value.lastName = input,
            onChanged: (value) => {
            controller.currentUser.value.lastName = value,
            },
            validator: (input) => input!.length < 3 ? 'Enter at least 3 characters': null,
            iconData: Icons.person, key: null, errorText: '',
            suffixIcon: const Icon(null),
            suffix: const Icon(null),
          ),
          TextFieldWidget(
            readOnly: false,
            labelText: 'Email',
            hintText: "johndoe@gmail.com",
            initialValue: '',
            keyboardType: TextInputType.emailAddress,
            onSaved: (input) => controller.currentUser.value.email = input,
            onChanged: (value) => {

               controller.currentUser.value.email = value
            },
            validator: (input){
              return !input!.contains('@') ? 'Enter a valid email address': null;
            },
            iconData: Icons.alternate_email, key: null, errorText: '',
            suffixIcon: const Icon(null), suffix: const Icon(null),
          ),
          TextFieldWidget(
            readOnly: false,
            labelText: 'Phone',
            hintText: "677777777",
            initialValue: '',
            keyboardType: TextInputType.number,
            onSaved: (input) => controller.currentUser.value.phoneNumber = input,
            onChanged: (value) => {
              controller.currentUser.value.phoneNumber = value
            },
            validator: (input) => input!.length < 9 || input.length >9 ? 'Enter exactly 9 characters' : null,
            iconData: Icons.phone,
            key: null,
            errorText: '',
            suffixIcon: const Icon(null),
            suffix: const Icon(null),
          ),

          const SizedBox(height: 10),

          Container(
              decoration: BoxDecoration(
                color:  Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                ],
                //border: Border.all(color: Get.theme.focusColor.withOpacity(0.5))
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButtonFormField(
                  dropdownColor: Colors.white,
                  decoration: const InputDecoration.collapsed(
                    hintText: '',

                  ),
                  onSaved: (input) => (controller.selectedGender.value == "Male"||controller.selectedGender.value == "Homme")?controller.currentUser.value.gender = "male":
                  controller.selectedGender.value == 'Other'? controller.currentUser.value.gender = 'other':controller.currentUser.value.gender = "female",
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
                      child: Text(items, style: const TextStyle(color: Colors.black),),
                    );
                  }).toList(),
                  // After selecting the desired option,it will
                  // change button value to selected value
                  onChanged: (String? newValue) {
                    controller.selectedGender.value = newValue!;
                    if(controller.selectedGender.value == "Male"||controller.selectedGender.value == "Homme"){
                      controller.currentUser.value.gender = "male";
                    }
                    else if (controller.selectedGender.value == 'Other'){
                      controller.currentUser.value.gender = "other";
                    }
                    else{
                      controller.currentUser.value.gender = "female";
                    }


                  },).marginOnly(left: 20, right: 20, top: 10, bottom: 10).paddingOnly( top: 20, bottom: 14),
              )
          ).paddingOnly(left: 5, right: 5, top: 20, bottom: 14,
          ),

          InkWell(
              onTap: ()=>{ controller.birthDatePicker() },
              child: Container(
                padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                margin:const  EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    borderRadius:const BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                    ],
                    border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Birth Date'.tr, style: const TextStyle(color: labelColor)
                    ),
                    Obx(() =>
                        ListTile(
                            leading: const Icon(Icons.calendar_today),
                            title: Text(controller.birthDateDisplay.value,
                              style: Get.textTheme.headline1?.merge(const TextStyle(color: Colors.black, fontSize: 16)),
                            )
                        ))
                  ],
                ),
              )
          ),

          Obx(() {
            return TextFieldWidget(
              labelText: 'Password',
              hintText: "••••••••••••",
              readOnly: false,
              //initialValue: controller.password.value,
              onSaved: (input) => controller.currentUser.value.password = input,
              onChanged: (value) => {
                // controller.password.value = value,
                 controller.currentUser.value.password = value
              },
              validator: (input) {
                return input!.length < 6 ? " Enter at least 6 characters" : null;
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
              errorText: '',
              suffix: const Icon(null),
            );
          }),
          Obx(() {
            return TextFieldWidget(
              labelText: 'Confirm Password',
              hintText: "••••••••••••",
              readOnly: false,
              //initialValue: controller.password.value,
              onSaved: (input) => controller.confirmPassword = input!,
              onChanged: (value) => {
                controller.confirmPassword = value
              },
              validator: (input) {
                return input!.length < 6 ? " Enter at least 6 characters" : null;
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
              errorText: '',
              suffix: Icon(null),
            );
          }),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            SizedBox(width: 60,),
            Obx(() => BlockButtonWidget(
              onPressed: () {
                // if(controller.password.value==controller.confirmPassword.value)
                // {
                //   controller.register();
                // }

                if (controller.registerFormKey.currentState!.validate()) {
                  controller.registerFormKey.currentState!.save();
                 if(controller.selectedGender.value != 'Select  your gender'){
                   if(controller.birthDate.value == "--/--/--"){
                     Get.showSnackbar(Ui.warningSnackBar(message: "please input a birthdate".tr));
                   }
                   else{
                     print(controller.confirmPassword );
                     print(controller.currentUser.value.password);
                     if(controller.confirmPassword == controller.currentUser.value.password){
                       controller.registerNext.value = !controller.registerNext.value;
                     }
                     else{
                       Get.showSnackbar(Ui.warningSnackBar(message: "password and confirm password are not the same".tr));
                     }
                   }
                 }
                 else{
                   Get.showSnackbar(Ui.warningSnackBar(message: "please select a gender".tr));
                 }


                }


              },
              color: Get.theme.colorScheme.secondary,
              text: !controller.loading.value? Text(
                'Next',
                style: Get.textTheme.headline6?.merge(TextStyle(color: Get.theme.primaryColor)),
              ): const SizedBox(height: 30,
                  child: SpinKitThreeBounce(color: Colors.white, size: 20)),
            ).paddingSymmetric(vertical: 40, horizontal: 20),),
          ],),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ const Text("Already have an account?",style: TextStyle(fontFamily: "poppins", fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal)),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.LOGIN);
                },
                child: const Text('Sign in',style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor)),
              ),
            ],
          ).paddingSymmetric(vertical: 20),
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
          Text('Profile Image',
            style: Get.textTheme.bodyText2?.merge(const TextStyle(color: labelColor)),
            textAlign: TextAlign.start,
          ),
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

                  await controller.selectCameraOrGalleryProfileImage();
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
          ).marginOnly(bottom: 20),

          TextFieldWidget(
            readOnly: false,
            labelText: 'Company Name',
            hintText: "Map & Rank",
            initialValue: '',
            keyboardType: TextInputType.text,
            onSaved: (input) => controller.currentUser.value.companyName = input,
            onChanged: (value) => {
              controller.currentUser.value.companyName = value,
              // controller.currentUser.value.email = controller.email.value
            },
            validator: (input) {
              input!.length < 3 ? 'Enter at least 3 letters' : null;
            },
            iconData: Icons.person, key: null, errorText: '', suffixIcon: Icon(null), suffix: Icon(null),
          ),

          Text('Select a sector',
            style: Get.textTheme.bodyText2?.merge(TextStyle(color: labelColor)),
            textAlign: TextAlign.start,
          ),
          Obx(() =>
              Column(
                children: [
                  TextFieldWidget(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    validator: (input) => input!.isEmpty ? 'Required field' : null,
                    iconData: FontAwesomeIcons.search,
                    style: const TextStyle(color: labelColor),
                    hintText: 'Select or search by sector name',
                    onChanged: (value)=>{
                      controller.filterSearchSectors(value)
                    },
                    errorText: '', suffixIcon: const Icon(null), suffix: const Icon(null),
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
                                  }



                                },
                                child: Obx(() => LocationWidget(
                                  regionName: controller.sectors[index]['name'],
                                  selected: controller.sectorsSelected.contains(controller.sectors[index])? true : false,
                                ).marginOnly(bottom: 5))
                            );
                          })
                  )
                ],
              ),
          ).marginOnly(bottom: 20),

          const SizedBox(height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => BlockButtonWidget(
                onPressed: () {
                    controller.registerNext.value = !controller.registerNext.value;
                },
                color: Get.theme.colorScheme.secondary,
                text: !controller.loading.value? Text(
                  'Prev',
                  style: Get.textTheme.headline6?.merge(TextStyle(color: Get.theme.primaryColor)),
                ): const SizedBox(height: 30,
                    child: SpinKitThreeBounce(color: Colors.white, size: 20)),
              )),
              Obx(() => BlockButtonWidget(
                onPressed: () {
                  if (controller.sectorsSelected.isNotEmpty){
                    controller.registerNextStep1.value = !controller.registerNextStep1.value;
                  }
                  else{
                    Get.showSnackbar(Ui.warningSnackBar(message: 'Please select a sector' ));
                  }

                },
                color: Get.theme.colorScheme.secondary,
                text: !controller.loading.value? Text(
                  'Next',
                  style: Get.textTheme.headline6?.merge(TextStyle(color: Get.theme.primaryColor)),
                ): const SizedBox(height: 30,
                    child: SpinKitThreeBounce(color: Colors.white, size: 20)),
              ),),
            ],).paddingSymmetric(vertical: 40, horizontal: 20),


          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?",style: TextStyle(fontFamily: "poppins", fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal)),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.LOGIN);
                },
                child: const Text('Sign in',style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor)),
              ),
            ],
          ).paddingSymmetric(vertical: 20),
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
          Text('Select a region',
            style: Get.textTheme.bodyText2?.merge(TextStyle(color: labelColor)),
            textAlign: TextAlign.start,
          ),
          Obx(() =>
              Column(
                children: [
                  TextFieldWidget(
                    readOnly: false,
                    keyboardType: TextInputType.text,
                    validator: (input) => input!.isEmpty ? 'Required field' : null,
                    //onChanged: (input) => controller.selectUser.value = input,
                    //labelText: "Research receiver".tr,
                    iconData: FontAwesomeIcons.search,
                    style: const TextStyle(color: labelColor),
                    hintText: 'Search by region name',
                    onChanged: (value)=>{
                      controller.filterSearchRegions(value)
                    },
                    errorText: '', suffixIcon: const Icon(null), suffix: const Icon(null),
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
                          itemCount: controller.regions.length > 5 ? 5 : controller.regions.length,
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
                                  }
                                  controller.regionSelected.value = !controller.regionSelected.value;
                                  controller.regionSelectedIndex.value = index;
                                  controller.divisionsSet = await controller.getAllDivisions(index);
                                  controller.listDivisions.value =  controller.divisionsSet['data'];
                                  controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                  controller.divisions.value =  controller.listDivisions;

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
          ).marginOnly(bottom: 20),
          if(controller.regionSelectedValue.isNotEmpty)...[
            Text('Select a division',
              style: Get.textTheme.bodyText2?.merge(TextStyle(color: labelColor)),
              textAlign: TextAlign.start,
            ),
            Obx(() =>
                Column(
                  children: [
                    TextFieldWidget(
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      validator: (input) => input!.isEmpty ? 'Required field' : null,
                      //onChanged: (input) => controller.selectUser.value = input,
                      //labelText: "Research receiver".tr,
                      iconData: FontAwesomeIcons.search,
                      style: const TextStyle(color: labelColor),
                      hintText: 'Search by division name',
                      onChanged: (value)=>{
                        controller.filterSearchDivisions(value)
                      },
                      errorText: '', suffixIcon: const Icon(null), suffix: const Icon(null),
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
                            itemCount: controller.divisions.length > 5 ? 5 : controller.divisions.length,
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
                                    }
                                    controller.divisionSelected.value = !controller.divisionSelected.value;
                                    controller.divisionSelectedIndex.value = index;
                                    controller.subdivisionsSet = await controller.getAllSubdivisions(index);
                                    controller.listSubdivisions.value = controller.subdivisionsSet['data'];
                                    controller.loadingSubdivisions.value = !controller.subdivisionsSet['status'];
                                    controller.subdivisions.value = controller.listSubdivisions;
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
          if(controller.divisionSelectedValue.isNotEmpty)...[
            Text('Select a subdivision',
              style: Get.textTheme.bodyText2?.merge(const TextStyle(color: labelColor)),
              textAlign: TextAlign.start,
            ),
            Obx(() =>
                Column(
                  children: [
                    TextFieldWidget(
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      validator: (input) => input!.isEmpty ? 'Required field' : null,
                      //onChanged: (input) => controller.selectUser.value = input,
                      //labelText: "Research receiver".tr,
                      iconData: FontAwesomeIcons.search,
                      style: const TextStyle(color: labelColor),
                      hintText: 'Search by sub-division name',
                      onChanged: (value)=>{
                        controller.filterSearchSubdivisions(value)
                      },
                      errorText: '', suffixIcon: const Icon(null), suffix: const Icon(null),
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
                            itemCount: controller.subdivisions.length > 5 ? 5 : controller.subdivisions.length,
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
                                    }
                                    controller.subdivisionSelected.value = !controller.subdivisionSelected.value;
                                    controller.subdivisionSelectedIndex.value = index;


                                    print(controller.subdivisions);

                                    controller.currentUser.value.zoneId = controller.subdivisionSelectedValue[0]['id'].toString();


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
            ).marginOnly(bottom: 20),
          ],

          const SizedBox(height: 20),

          Row(
            children: [
              Obx(() => Checkbox(
                  value: controller.isConfidentialityChecked.value,
                  onChanged: (value)async{
                    controller.isConfidentialityChecked.value = !controller.isConfidentialityChecked.value;
                  }
              )),
              SizedBox(
                  width: Get.width/1.5,
                  child: const Text(" By clicking Agree & Join, you agree to the LinkedIn User , "
                      "Privacy Policy, and Cookie Policy.",style: TextStyle(fontFamily: "poppins",fontSize: 15, color: Colors.grey))),
              //Spacer(),
            ],
          ).paddingSymmetric(horizontal: 30),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => BlockButtonWidget(
                onPressed: () {

                  controller.registerNextStep1.value = !controller.registerNextStep1.value;


                },
                color: Get.theme.colorScheme.secondary,
                text: !controller.loading.value? Text(
                  'Prev',
                  style: Get.textTheme.headline6?.merge(TextStyle(color: Get.theme.primaryColor)),
                ): const SizedBox(height: 30,
                    child: SpinKitThreeBounce(color: Colors.white, size: 20)),
              )),
    Obx(() => BlockButtonWidget(
    onPressed: () {
    //controller.login(),
    //controller.registerNext.value = !controller.registerNext.value;
      if(controller.regionSelectedValue.isNotEmpty){
        if(controller.divisionSelectedValue.isNotEmpty){
          if(controller.subdivisionSelectedValue.isNotEmpty){
             controller.register();
          }
          else{
            Get.showSnackbar(Ui.warningSnackBar(message: 'Please select a subdivision' ));
          }
        }
        else{
          Get.showSnackbar(Ui.warningSnackBar(message: 'Please select a division' ));
        }
      }
      else{
        Get.showSnackbar(Ui.warningSnackBar(message: 'Please select a region' ));
      }


    },
    color: Get.theme.colorScheme.secondary,
    text: !controller.loading.value? Text(
    'Next',
    style: Get.textTheme.headline6?.merge(TextStyle(color: Get.theme.primaryColor)),
    ): const SizedBox(height: 30,
    child: SpinKitThreeBounce(color: Colors.white, size: 20)),
    ))

            ],
          ).paddingSymmetric(vertical: 40, horizontal: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Already have an account?",style: TextStyle(fontFamily: "poppins", fontSize: 15, color: Colors.black, fontWeight: FontWeight.normal)),
              TextButton(
                onPressed: () {
                  Get.offAllNamed(Routes.LOGIN);
                },
                child: const Text('Sign in',style: TextStyle(fontFamily: "poppins",fontSize: 15, color: interfaceColor)),
              ),
            ],
          ).paddingSymmetric(vertical: 20),
        ],
      ),

    );
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
}
