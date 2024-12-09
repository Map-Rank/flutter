
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/auth/controllers/auth_controller.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_loading_widget.dart';
import '../../../color_constants.dart';
import '../../../common/ui.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../../services/global_services.dart';
import '../profile/controllers/profile_controller.dart';
import '../profile/views/profile_view.dart';
import '../root/controllers/root_controller.dart' show RootController;
import 'drawer_link_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MainDrawerWidget extends StatelessWidget {

  const MainDrawerWidget({super.key});




  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>AuthController());
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Obx(() {
              return GestureDetector(
                onTap: () async {
                  Get.lazyPut<ProfileController>(
                        () => ProfileController(),
                  );
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => ProfileView(), ));
                },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  accountName: Text(
                    Get.find<AuthService>().user.value.firstName.toString()! +" " +Get.find<AuthService>().user.value.lastName.toString(),
                    style: Theme.of(context).textTheme.headlineMedium!.merge(const TextStyle(color: interfaceColor, fontSize: 15)),
                  ),
                  accountEmail: Text(""
                  ),
                  currentAccountPicture: Stack(
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipOval(
                            child: FadeInImage(
                              width: 65,
                              height: 65,
                              fit: BoxFit.cover,
                              image: NetworkImage(Get.find<AuthService>().user.value.avatarUrl.toString()!, headers: GlobalService.getTokenHeaders()),
                              //image: Domain.googleUser?NetworkImage(Domain.googleImage):NetworkImage('${Domain.serverPort}/image/res.partner/${_currentUser.value.id}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                              placeholder: const AssetImage(
                                  "assets/images/loading.gif"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    'assets/images/user_admin.png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fitWidth);
                              },
                            )
                        )
                      ),
                      
                    ],
                  ),
                ),
              );

          }),
          SizedBox(height: 20),
          if(Get.find<AuthService>().user.value.email != null)...[
            DrawerLinkWidget(
                special: false,
                icon: FontAwesomeIcons.userGroup,
                text: AppLocalizations.of(context).community,
                drawer: true,
                onTap: (e) async {
                  Get.back();
                  await Get.find<RootController>().changePage(1);
                }
            ),
            DrawerLinkWidget(
                special: false,
                icon: FontAwesomeIcons.calendar,
                text: AppLocalizations.of(context).events,
                drawer: true,
                onTap: (e) async {
                  Get.back();
                  await Get.find<RootController>().changePage(3);
                }
            ),

          Obx(() {
            if (Get.find<AuthService>().user.value.email != null) {
              return DrawerLinkWidget(
                key: Key('logoutIcon'),
                special: true,
                drawer: false,
                icon: Icons.logout,
                text: AppLocalizations.of(context).logout,
                onTap: (e) async {
                  showDialog(context: context,
                    builder: (context) => AlertDialog(
                      insetPadding: EdgeInsets.all(20),
                      icon: Icon(FontAwesomeIcons.warning, color: Colors.orange,),
                      title:  Text(AppLocalizations.of(context).logout),
                      content: Obx(() =>  !Get.find<AuthController>().loading.value ?Text(AppLocalizations.of(context).sign_out_warning, textAlign: TextAlign.justify, style: TextStyle(),)
                          : SizedBox(height: 30,
                          child: SpinKitThreeBounce(color: interfaceColor, size: 20)),),
                      actions: [
                        TextButton(onPressed: (){
                          Get.find<AuthController>().logout();
                          Get.lazyPut(()=>AuthController());
                        }, child: Text(AppLocalizations.of(context).exit, style: TextStyle(color: Colors.red),)),

                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text(AppLocalizations.of(context).cancel, style: TextStyle(color: interfaceColor),)),

                      ],

                    ),);

                },
              );
            } else {
              return SizedBox();
            }
          }),

        ],
    ]
    ));
  }
}
