
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/auth/controllers/auth_controller.dart';
import '../../../color_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../root/controllers/root_controller.dart' show RootController;
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {

  const MainDrawerWidget({super.key});




  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Obx(() {
              return GestureDetector(
                onTap: () async {
                  await Get.find<RootController>().changePage(3);
                },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  accountName: Text(
                    Get.find<AuthService>().user.value.firstName.toString()! +" " +Get.find<AuthService>().user.value.lastName.toString(),
                    style: Theme.of(context).textTheme.headline2!.merge(const TextStyle(color: interfaceColor, fontSize: 15)),
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
                              image: NetworkImage(Get.find<AuthService>().user.value.avatarUrl.toString()!),
                              //image: Domain.googleUser?NetworkImage(Domain.googleImage):NetworkImage('${Domain.serverPort}/image/res.partner/${_currentUser.value.id}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                              placeholder: const AssetImage(
                                  "assets/images/loading.gif"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    'assets/images/téléchargement (3).png',
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.fitWidth);
                              },
                            )
                        )
                      ),
                      // Positioned(
                      //   top: 0,
                      //   right: 0,
                      //   child: Get.find<AuthService>().user.value.verifiedPhone ?? false ? Icon(Icons.check_circle, color: Get.theme.colorScheme.secondary, size: 24) : SizedBox(),
                      // )
                    ],
                  ),
                ),
              );

          }),
          SizedBox(height: 20),
          /*DrawerLinkWidget(
            special: false,
            drawer: false,
            icon: Icons.home_outlined,
            text: "Home",
            onTap: (e) async {
              //Get.back();
              await Get.toNamed(Routes.ROOT);
            },
          ),*/


          if(Get.find<AuthService>().user.value.email != null)...[
            DrawerLinkWidget(
                special: false,
                icon: FontAwesomeIcons.userGroup,
                text: 'Community',
                drawer: true,
                onTap: (e) async {
                  Get.back();
                  await Get.find<RootController>().changePage(1);
                }
            ),

          Obx(() {
            if (Get.find<AuthService>().user.value.email != null) {
              return DrawerLinkWidget(
                key: Key('logoutIcon'),
                special: true,
                drawer: false,
                icon: Icons.logout,
                text: 'Logout',
                onTap: (e) async {
                  Get.find<AuthController>().logout();
                  Get.lazyPut(()=>AuthController());
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
