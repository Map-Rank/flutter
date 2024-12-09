// coverage:ignore-file
import 'dart:io';

import 'package:get/get.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import '../../common/helper.dart';

class GlobalService extends GetxService {


  get baseUrl => "https://www.admin.residat.com/";
  //get baseUrl => "https://backoffice-dev.residat.com/";
  static var logOutToken = '';
  static var hydroMapUrl = "https://www.residat.com/assets/maps/Hydrography/Hydro_Polygon.geojson";
  static var isAuthTokenValid = false;
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
