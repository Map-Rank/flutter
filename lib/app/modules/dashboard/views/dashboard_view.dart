import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/notifications_button_widget.dart';
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
        backgroundColor: secondaryColor,
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshDashboard(showMessage: true);
              controller.onInit();
            },
            child: Container(
              decoration:const BoxDecoration(color: backgroundColor,
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
                    actions: const [NotificationsButtonWidget()],
                    backgroundColor: primaryColor,
                    title: Text(
                      GlobalService().appName,
                      style: Get.textTheme.headline6!.merge(TextStyle(color: Colors.white)),
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
                      child: SizedBox()
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
