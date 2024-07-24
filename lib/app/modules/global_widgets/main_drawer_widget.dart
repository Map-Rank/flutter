
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
                  showDialog(context: context, builder: (context){
                    return CommentLoadingWidget();
                  },);
                  try {
                    await Get.find<AuthController>().getUser();
                    await Get.toNamed(Routes.PROFILE);
                  }catch (e) {
                    Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
                  }
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
                text: 'Community',
                drawer: true,
                onTap: (e) async {
                  Get.back();
                  await Get.find<RootController>().changePage(1);
                }
            ),
            DrawerLinkWidget(
                special: false,
                icon: FontAwesomeIcons.calendar,
                text: 'Events',
                drawer: true,
                onTap: (e) async {
                  Get.back();
                  await Get.find<RootController>().changePage(2);
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
                  showDialog(context: context,
                    builder: (context) => AlertDialog(
                      insetPadding: EdgeInsets.all(20),
                      icon: Icon(FontAwesomeIcons.warning, color: Colors.orange,),
                      title:  Text('Log out'),
                      content: Obx(() =>  !Get.find<AuthController>().loading.value ?Text('Are you sure you want to exit the application?', textAlign: TextAlign.justify, style: TextStyle(),)
                          : SizedBox(height: 30,
                          child: SpinKitThreeBounce(color: interfaceColor, size: 20)),),
                      actions: [
                        TextButton(onPressed: (){
                          Get.find<AuthController>().logout();
                          Get.lazyPut(()=>AuthController());
                        }, child: Text('Exit', style: TextStyle(color: Colors.red),)),

                        TextButton(onPressed: (){
                          Navigator.of(context).pop();
                        }, child: Text('Cancel', style: TextStyle(color: interfaceColor),)),

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
