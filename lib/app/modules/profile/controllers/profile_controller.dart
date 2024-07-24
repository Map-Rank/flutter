import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../auth/controllers/auth_controller.dart';




class ProfileController extends GetxController {
  final Rx<UserModel> currentUser = Get.find<AuthService>().user;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  late UserRepository userRepository ;
  var updateUserInfo = false.obs;
  var picker = ImagePicker();
  late Rx<File> profileImage = File('assets/images/loading.gif').obs ;
  final loadProfileImage = false.obs;



  ProfileController() {

  }

  @override
  void onInit() async {
    userRepository = UserRepository();
    firstNameController.text = currentUser.value.firstName!;
    lastNameController.text = currentUser.value.lastName!;
    emailController.text = currentUser.value.email!;
    phoneNumberController.text = currentUser.value.phoneNumber!;
    genderController.text = currentUser.value.gender!;
    birthdateController.text = currentUser.value.gender!;
    print(phoneNumberController.text);

    super.onInit();
  }

  Future refreshProfile({bool showMessage = false}) async {
    currentUser.value =  await Get.find<AuthController>().getUser();
  }

  selectCameraOrGalleryProfileImage(){
    showDialog(
        context: Get.context!,
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
                        await profileImagePicker('camera');
                        loadProfileImage.value = true;
                        //Navigator.pop(Get.context);


                      },
                      leading: const Icon(FontAwesomeIcons.camera),
                      title: Text('Take a picture', style: Get.textTheme.headlineMedium?.merge(const TextStyle(fontSize: 15))),
                    ),
                    ListTile(
                      onTap: ()async{
                        await profileImagePicker('gallery');
                        loadProfileImage.value = true;
                        //Navigator.pop(Get.context);

                      },
                      leading: const Icon(FontAwesomeIcons.image),
                      title: Text('Upload Image', style: Get.textTheme.headlineMedium?.merge(const TextStyle(fontSize: 15))),
                    )
                  ],
                )
            ),
          );
        });
  }
  profileImagePicker(String source) async {
    if(source=='camera'){
      final XFile? pickedImage =
      await picker.pickImage(source: ImageSource.camera);
      if (pickedImage != null) {
        var imageFile = File(pickedImage.path);
        if(imageFile.lengthSync()>pow(1024, 2)){
          final tempDir = await getTemporaryDirectory();
          final path = tempDir.path;
          int rand = Math.Random().nextInt(10000);
          Im.Image? image1 = Im.decodeImage(imageFile.readAsBytesSync());
          var compressedImage =  File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1!, quality: 25));
          print('Lenght'+compressedImage.lengthSync().toString());
          profileImage.value= compressedImage;
          currentUser.value.imageFile = profileImage.value;

        }
        else{
          profileImage.value = File(pickedImage.path);
          currentUser.value.imageFile = profileImage.value;

        }
        Navigator.of(Get.context!).pop();
        //Get.showSnackbar(Ui.SuccessSnackBar(message: "Picture saved successfully".tr));
        //loadIdentityFile.value = !loadIdentityFile.value;//Navigator.of(Get.context).pop();
      }

    }
    else{
      final XFile? pickedImage =
      await picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        var imageFile = File(pickedImage.path);
        if(imageFile.lengthSync()>pow(1024, 2)){
          final tempDir = await getTemporaryDirectory();
          final path = tempDir.path;
          int rand = new Math.Random().nextInt(10000);
          Im.Image? image1 = Im.decodeImage(imageFile.readAsBytesSync());
          var compressedImage =  File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1!, quality: 25));
          profileImage.value= compressedImage;
          currentUser.value.imageFile = profileImage.value;

        }
        else{
          print(pickedImage);
          profileImage.value = File(pickedImage.path);
          currentUser.value.imageFile = profileImage.value;

        }
        Navigator.of(Get.context!).pop();
      }

    }
  }

  updateUser() async {

    try {
      updateUserInfo.value = true;
      var user = await userRepository.updateUser(currentUser.value);
      print(user);
      currentUser.value= user;
      // currentUser.value.myPosts = user.myPosts;
      // currentUser.value.myEvents = user.myEvents;

      Get.find<AuthService>().user.value = currentUser.value;

      //await Get.find<RootController>().changePage(0);
      updateUserInfo.value = false;
      Get.showSnackbar(Ui.SuccessSnackBar(message: 'User Profile info updated successfully' ));
    }
    catch (e) {
      updateUserInfo.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      updateUserInfo.value = false;
    }

  }
}


