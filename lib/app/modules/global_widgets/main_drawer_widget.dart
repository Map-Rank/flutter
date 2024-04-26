
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import '../../../color_constants.dart';
import '../../routes/app_routes.dart';
import '../../services/auth_service.dart';
import '../root/controllers/root_controller.dart' show RootController;
import 'drawer_link_widget.dart';

class MainDrawerWidget extends StatelessWidget {

  const MainDrawerWidget({super.key});




  @override
  Widget build(BuildContext context) {
    var _currentUser = Get.find<AuthService>().user;
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        children: [
          Obx(() {
            if (Get.find<AuthService>().user.value.email == null) {
              return GestureDetector(
                onTap: () {
                  Get.offNamed(Routes.LOGIN);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Welcome', style: Get.textTheme.headline5!.merge(TextStyle(color: appColor))),
                      const SizedBox(height: 5),
                      Text('Login Account or Create new one for free', style: Get.textTheme.bodyText1!.merge(TextStyle(color: Colors.black))),
                      const SizedBox(height: 15),
                      Wrap(
                        spacing: 10,
                        children: <Widget>[
                          MaterialButton(
                            onPressed: () {
                              Get.offNamed(Routes.LOGIN);
                            },
                            color: Get.theme.colorScheme.secondary,
                            height: 40,
                            elevation: 0,
                            shape: StadiumBorder(),
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.exit_to_app_outlined, color: Get.theme.primaryColor, size: 24),
                                Text(
                                  'Login',
                                  style: Get.textTheme.subtitle1!.merge(TextStyle(color: Get.theme.primaryColor)),
                                ),
                              ],
                            ),
                          ),
                          MaterialButton(
                            color: Get.theme.focusColor.withOpacity(0.2),
                            height: 40,
                            elevation: 0,
                            onPressed: () {
                              Get.offNamed(Routes.REGISTER);
                            },
                            shape: const StadiumBorder(),
                            child: Wrap(
                              runAlignment: WrapAlignment.center,
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 9,
                              children: [
                                Icon(Icons.person_add_outlined, color: Get.theme.hintColor, size: 24),
                                Text(
                                  'Register',
                                  style: Get.textTheme.subtitle1!.merge(TextStyle(color: Colors.black)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () async {
                  await Get.find<RootController>().changePage(3);
                },
                child: UserAccountsDrawerHeader(
                  decoration: BoxDecoration(
                    color: Theme.of(context).hintColor.withOpacity(0.1),
                  ),
                  accountName: Text(
                    Get.find<AuthService>().user.value.firstName! +" " +Get.find<AuthService>().user.value.lastName!,
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
                              image: NetworkImage('url'),
                              //image: Domain.googleUser?NetworkImage(Domain.googleImage):NetworkImage('${Domain.serverPort}/image/res.partner/${_currentUser.value.id}/image_1920?unique=true&file_response=true', headers: Domain.getTokenHeaders()),
                              placeholder: const AssetImage(
                                  "assets/img/loading.gif"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    'assets/img/téléchargement (3).png',
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
            }
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
                special: true,
                drawer: false,
                icon: Icons.logout,
                text: 'Logout',
                onTap: (e) async {

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
