import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'theme_mode_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class LanguageController extends GetxController {
 var box  = new GetStorage();
 late RxString selectedLanguage = Get.locale.toString().obs;
  var languageList = [
    AppLocalizations.of(Get.context!).fr,
    AppLocalizations.of(Get.context!).en,
  ].obs;

  @override
  void onInit() {

    super.onInit();
    if(Get.locale.toString() == 'fr'){
      selectedLanguage.value = AppLocalizations.of(Get.context!).fr;
    }
    else{
      selectedLanguage.value = AppLocalizations.of(Get.context!).en;
    }
  }

}
