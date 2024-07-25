import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mapnrank/color_constants.dart';

class CommentLoadingWidget extends StatelessWidget {
  const CommentLoadingWidget({
    Key? key,

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      key: Key('commentContainer'),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.4)
        ),
        width: double.infinity,
        height: Get.height,
      child: Column(
        children: [
          LinearProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(interfaceColor),
          )
        ],
      ),

    );
  }
}