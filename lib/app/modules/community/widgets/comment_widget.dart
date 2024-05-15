import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../color_constants.dart';
import '../../../services/global_services.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({Key? key,
    required this.user,
    required this.comment,
    required this.imageUrl,}) : super(key: key);

  final String user;
  final String comment;
  final String imageUrl;


  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipOval(
              child: FadeInImage(
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                  image: NetworkImage(this.imageUrl, headers: GlobalService.getTokenHeaders()),
                  placeholder: AssetImage(
                      "assets/images/loading.gif"),
                  imageErrorBuilder:
                      (context, error, stackTrace) {
                    return Image.asset(
                        "assets/images/téléchargement (3).png",
                        width: 50,
                        height: 50,
                        fit: BoxFit.fitWidth);
                  }
              )
          ).marginOnly(right: 20),


          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                children: [
                  SizedBox(
                      height: 40,
                      //width: Get.width/2.5,
                      child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                                child: Text(user, style: Get.textTheme.headline4!.merge(TextStyle(fontSize: 13, color: buttonColor, fontWeight: FontWeight.bold)), overflow: TextOverflow.ellipsis,)
                            )
                          ]
                      )
                  ),
                  Expanded(
                      child: SizedBox(
                        width: Get.width,
                      child: Text(comment))),
                ],

              ),
            ),
          ),

        ]
    );
  }
}