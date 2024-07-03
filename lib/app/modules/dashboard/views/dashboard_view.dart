import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mapnrank/app/services/global_services.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';


class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshDashboard(showMessage: true);
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
                      icon: FaIcon(FontAwesomeIcons.bars, color: interfaceColor),
                      onPressed: () => {Scaffold.of(context).openDrawer()},
                    ),
                    //expandedHeight: 200,
                    centerTitle: true,
                    actions:  [
                      GestureDetector(
                        onTap: (){

                        },
                        child: Center(
                          child: ClipOval(
                              child: FadeInImage(
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                                image:  NetworkImage(Get.find<AuthService>().user.value.avatarUrl.toString(), headers: {}),
                                placeholder: const AssetImage(
                                    "assets/images/loading.gif"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return FaIcon(FontAwesomeIcons.solidUserCircle, size: 30, color: interfaceColor,).marginOnly(right: 20,top: 10,bottom: 10);
                                },
                              )
                          ),
                        ),
                      ),
                    ],
                    backgroundColor: backgroundColor,
                    title: Text(
                      GlobalService().appName,
                      style: Get.textTheme.headline6!.merge(TextStyle(color: interfaceColor)),
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
