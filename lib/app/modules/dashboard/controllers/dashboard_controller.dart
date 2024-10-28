// coverage:ignore-file
import 'dart:convert';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../models/user_model.dart';
import '../../../services/auth_service.dart';




class DashboardController extends GetxController {
late WebViewController webViewController;
final Rx<UserModel> currentUser = Get.find<AuthService>().user;

  DashboardController() {

  }

  @override
  void onInit() async {
    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000),)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://www.residat.com/dashboard'));
    super.onInit();

  }

  Future refreshDashboard({bool showMessage = false}) async {

  }
}


