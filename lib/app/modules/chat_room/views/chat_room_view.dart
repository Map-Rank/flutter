import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/chat_room/controllers/chat_room_controller.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';


class ChatRoomView extends GetView<ChatRoomController> {
  const ChatRoomView({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        //backgroundColor: Get.theme.colorScheme.secondary,
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshChatRoom(showMessage: true);
              controller.onInit();
            },
            child: Container(
              decoration: const BoxDecoration(color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),

              ),
            )
        ),
      ),
    );
  }
}
