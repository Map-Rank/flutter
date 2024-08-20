// coverage:ignore-file
import 'dart:io';

import 'package:get/get.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import '../../common/helper.dart';

class GlobalService extends GetxService {


  String get baseUrl => "https://www.admin.residat.com/";
  static var logOutToken = '';
  String get apiPath => "api/";
  String get appName => "Residat";
  static Map<String, String> getTokenHeaders() {
    Map<String, String> headers = new Map();
    headers['Authorization'] = Platform.environment.containsKey('FLUTTER_TEST')?'': Get.find<AuthService>().user.value.authToken!;
    headers['accept'] = 'application/json';
    return headers;
  }
  static String contactUsNumber = "+237620162316";
}
