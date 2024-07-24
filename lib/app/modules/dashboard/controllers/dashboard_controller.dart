// coverage:ignore-file
import 'dart:convert';
import 'dart:ui';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';




class DashboardController extends GetxController {
late WebViewController webViewController;

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
      ..loadRequest(Uri.parse('https://www.google.com'));
    super.onInit();

  }

  Future refreshDashboard({bool showMessage = false}) async {

  }
}


