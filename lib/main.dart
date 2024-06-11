import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mapnrank/app/modules/auth/bindings/auth_binding.dart';
import 'package:mapnrank/app/modules/auth/views/login_view.dart';
import 'package:mapnrank/app/modules/root/bindings/root_binding.dart';
import 'package:mapnrank/app/modules/root/controllers/root_controller.dart';
import 'package:mapnrank/app/providers/laravel_provider.dart';
import 'package:mapnrank/app/routes/theme_app_pages.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mapnrank/app/services/settings_services.dart';
import 'package:mapnrank/firebase_options.dart';

import 'app/services/global_services.dart';
//import 'firebase_options.dart';

  initServices() async {
  Get.log('starting services ...');
  await GetStorage.init();
  await Firebase.initializeApp();
  await Get.putAsync(() => AuthService().init());
  await Get.putAsync(() => LaravelApiClient().init());
  //await Get.putAsync(() => FirebaseProvider().init());
  await Get.putAsync(() => SettingsService().init());
  //Get.lazyPut(()=>RootBinding());
  //await Get.putAsync(() => TranslationService().init());
  Get.log('All services started...');


}

void main() async{
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );

  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
   await initServices();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      // theme: ThemeData(
      //   primarySwatch: Colors.blue,
      //   fontFamily: 'Poppins'
      // ),
      //initialRoute: Theme1AppPages.INITIAL,
      initialBinding: AuthBinding(),
      getPages: Theme1AppPages.routes,
      defaultTransition: Transition.cupertino,
      themeMode: Get.find<SettingsService>().getThemeMode(),
      theme: Get.find<SettingsService>().getLightTheme(),
      darkTheme: Get.find<SettingsService>().getDarkTheme(),
      home: LoginView(),
    );
  }
}


