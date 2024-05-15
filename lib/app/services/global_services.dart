import 'package:get/get.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import '../../common/helper.dart';

class GlobalService extends GetxService {


  String get baseUrl => "https://backoffice-dev.residat.com/";
  String get apiPath => "api/";
  String get appName => "Residat";
  static Map<String, String> getTokenHeaders() {
    Map<String, String> headers = new Map();
    headers['Authorization'] = Get.find<AuthService>().user.value.authToken!;
    headers['accept'] = 'application/json';
    return headers;
  }
}
