// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mapnrank/app/services/global_services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../routes/app_routes.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../community/widgets/comment_loading_widget.dart';
import '../../root/controllers/root_controller.dart';


class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      // appBar: AppBar(
      //   leading:  GestureDetector(
      //     onTap: (){
      //       Scaffold.of(context).openDrawer();
      //     },
      //     child: Image.asset(
      //         "assets/images/logo.png",
      //         width: Get.width/6,
      //         height: Get.width/6,
      //         fit: BoxFit.fitWidth),
      //   ),
      //   //expandedHeight: 200,
      //   centerTitle: true,
      //   actions:  [
      //     ClipOval(
      //         child: GestureDetector(
      //           onTap: () async {
      //             showDialog(context: context, builder: (context){
      //               return CommentLoadingWidget();
      //             },);
      //             try {
      //               await Get.find<AuthController>().getUser();
      //               await Get.toNamed(Routes.PROFILE);
      //             }catch (e) {
      //               Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      //             }
      //           },
      //           child: FadeInImage(
      //             width: 30,
      //             height: 30,
      //             fit: BoxFit.cover,
      //             image:  NetworkImage(controller.currentUser.value!.avatarUrl!, headers: GlobalService.getTokenHeaders()),
      //             placeholder: const AssetImage(
      //                 "assets/images/loading.gif"),
      //             imageErrorBuilder:
      //                 (context, error, stackTrace) {
      //               return Image.asset(
      //                   "assets/images/user_admin.png",
      //                   width: 40,
      //                   height: 40,
      //                   fit: BoxFit.fitWidth);
      //             },
      //           ),
      //         )
      //     ),
      //   ],
      //   backgroundColor: Colors.white,
      //   title: Container(
      //     height: 40,
      //     width: Get.width/1.6,
      //     decoration: BoxDecoration(
      //         color: backgroundColor,
      //         borderRadius: BorderRadius.circular(10)
      //
      //     ),
      //     child: TextFormField(
      //       decoration: InputDecoration(
      //           border: OutlineInputBorder(
      //             borderSide:BorderSide.none,),
      //           hintText: 'Search subdivision',
      //           hintStyle: TextStyle(fontSize: 14),
      //           prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.grey, size: 15,)
      //       ),
      //     ),
      //   ),),
      body:  SafeArea(
        child: Container(
          color: Colors.white ,
          child: ListView(children: [
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                  onTap: () async {
                    showDialog(context: context, builder: (context) => Container(
                      child: SpinKitThreeBounce(
                        color: interfaceColor,
                        size: 20,
                      ),
                    ),);
                    await Get.find<RootController>().changePage(0);
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: Icon(FontAwesomeIcons.multiply).marginOnly(top: 60, left: 20)),
            ),
            SizedBox(
                height: 800,
                width: Get.width,
                child: WebViewWidget(
                    controller: controller.webViewController)),
          ],),
        ),
      )
      // WebViewWidget(
      //     controller: controller.webViewController)

    );
  }
}

