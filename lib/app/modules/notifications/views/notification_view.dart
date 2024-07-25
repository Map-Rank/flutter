// coverage:ignore-file
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/services/global_services.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../controllers/notification_controller.dart';


class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: secondaryColor,
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshNotification(showMessage: true);
              controller.onInit();
            },
            child: Container(
              decoration: BoxDecoration(color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),

              ),
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: FaIcon(FontAwesomeIcons.bars, color: Colors.white),
                      onPressed: () => {Scaffold.of(context).openDrawer()},
                    ),
                    //expandedHeight: 200,
                    centerTitle: true,
                    actions: const [],
                    backgroundColor: primaryColor,
                    title: Text(
                      GlobalService().appName,
                      style: Get.textTheme.headlineSmall!.merge(TextStyle(color: Colors.white)),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: <Widget>[
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset(
                                "assets/images/logo.png",
                                width: Get.width/2,
                                height: Get.height/4,
                                fit: BoxFit.fitWidth),
                            Text('Please be patient, under development...')

                          ],),
                      )
                    //FeaturedCategoriesWidget()
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
