import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/common/helper.dart';
import '../../global_widgets/custom_bottom_nav_bar.dart';
import '../../global_widgets/main_drawer_widget.dart';
import '../controllers/root_controller.dart';

class RootView extends GetView<RootController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() =>  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        drawer: const MainDrawerWidget(),
        body: controller.currentPage,
        bottomNavigationBar: CustomBottomNavigationBar(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          itemColor: context.theme.colorScheme.secondary,
          currentIndex: controller.currentIndex.value,
          onChange: (index) {
            controller.changePage(index);
          },
          children: [
            CustomBottomNavigationItem(
              icon: FontAwesomeIcons.home,
              label: 'Dashboard',
            ),
            CustomBottomNavigationItem(
              icon: FontAwesomeIcons.userGroup,
              label: 'Community',
            ),
            CustomBottomNavigationItem(
              icon: FontAwesomeIcons.comment,
              label: 'Chat',
            ),
            CustomBottomNavigationItem(
              icon: FontAwesomeIcons.user,
              label: 'Profile',
            ),
          ],
        ),
      ),
    ));
    }
  }

