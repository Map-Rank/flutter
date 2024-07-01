import 'package:get/get.dart' show GetPage, Transition;
import 'package:mapnrank/app/modules/auth/views/login_view.dart';
import 'package:mapnrank/app/modules/auth/views/register_view.dart';
import 'package:mapnrank/app/modules/community/views/create_post.dart';
import 'package:mapnrank/app/modules/profile/bindings/profile_binding.dart';
import 'package:mapnrank/app/modules/profile/views/account_view.dart';
import 'package:mapnrank/app/modules/profile/views/contact_us_view.dart';
import 'package:mapnrank/app/modules/root/bindings/root_binding.dart';
import 'package:mapnrank/app/modules/root/views/root_view.dart';
import 'package:mapnrank/app/modules/settings/views/settings_view.dart';
import 'package:mapnrank/app/modules/settings/views/theme_mode_view.dart';


import '../modules/auth/bindings/auth_binding.dart';
import '../modules/community/views/comment_view.dart';
import '../modules/community/views/details_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import 'app_routes.dart';

class Theme1AppPages {

  static final routes = [
    //GetPage(name: Routes.ROOT, page: () => RootView(), binding: RootBinding()),
    GetPage(name: Routes.SETTINGS, page: () => SettingsView(), binding: SettingsBinding()),
    GetPage(name: Routes.SETTINGS_THEME_MODE, page: () => ThemeModeView(), binding: SettingsBinding()),
    GetPage(name: Routes.LOGIN, page: () => LoginView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.REGISTER, page: () => RegisterView(), binding: AuthBinding(), transition: Transition.zoom),
    GetPage(name: Routes.ROOT, page: () => const RootView(), binding: RootBinding(), transition: Transition.zoom ),
    GetPage(name: Routes.CREATE_POST, page: () => const CreatePostView(), transition: Transition.downToUp ),
    GetPage(name: Routes.COMMENT_VIEW, page: () => CommentView(), transition: Transition.rightToLeft ),
    GetPage(name: Routes.DETAILS_VIEW, page: () => DetailsView(), transition: Transition.rightToLeft ),
    GetPage(name: Routes.ACCOUNT, page: () =>const AccountView(),binding: ProfileBinding(), transition: Transition.rightToLeft ),
    GetPage(name: Routes.CONTACT_US, page: () =>const ContactUsView(),binding: ProfileBinding(), transition: Transition.rightToLeft ),

  ];
}
