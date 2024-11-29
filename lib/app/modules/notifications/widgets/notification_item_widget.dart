import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../../color_constants.dart';
import '../../../../common/ui.dart';
import '../../../models/notification_model.dart' as model;
import '../../../models/notification_model.dart';
import '../../../services/auth_service.dart';

class NotificationItemWidget extends StatelessWidget {
  NotificationItemWidget({Key? key, required this.notification,  required this.icon, required this.onDismissed, required this.onTap}) : super(key: key);
  final NotificationModel notification;
  final ValueChanged<model.NotificationModel> onDismissed;
  final ValueChanged<model.NotificationModel> onTap;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return notification.userModel?.userId == Get.find<AuthService>().user.value.userId? Dismissible(
      key: Key(this.notification.hashCode.toString()),
      background: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: Ui.getBoxDecoration(color: Colors.red),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Icon(
              Icons.delete_outline,
              color: Colors.white,
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        onDismissed(this.notification);
        // Then show a snackbar
      },
      child: GestureDetector(
        onTap: () {
          onTap(notification);
        },
        child: Container(
          padding: EdgeInsets.all(12),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: Ui.getBoxDecoration(color: Get.theme.focusColor.withOpacity(0.15)),
          //Ui.getBoxDecoration(color: this.notification.isSeen ? Get.theme.primaryColor : Get.theme.focusColor.withOpacity(0.15)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  icon,
                  Positioned(
                    right: -15,
                    bottom: -30,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    top: -55,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(150),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Text(
                        this.notification.title!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: TextStyle(
                            fontWeight:  FontWeight.bold, fontSize: 14, color: buttonColor)
                      //notification.isSeen ? FontWeight.normal : FontWeight.bold, fontSize: 14, color: buttonColor),
                    ),
                    Text(
                      // DateFormat('d, MMMM y | HH:mm', Get.locale.toString()).format(this.notification.timestamp),
                      notification.date!,
                        style: Get.textTheme.bodySmall?.merge(TextStyle(
                            fontWeight: FontWeight.w600,fontSize: 12, color: Colors.black38))
                      //style: Get.textTheme.,
                    ),
                    SizedBox(height: 10,),
                    Text(
                        this.notification.content!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 3,
                        style: Get.textTheme.bodySmall?.merge(TextStyle(
                            fontWeight: FontWeight.w600,fontSize: 12, color: Colors.black87))
                      //notification.isSeen ? FontWeight.normal : FontWeight.w600,fontSize: 12, color: Colors.black87)),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ): GestureDetector(
      onTap: () {
        onTap(notification);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: Ui.getBoxDecoration(color: Get.theme.focusColor.withOpacity(0.15)),
        //Ui.getBoxDecoration(color: this.notification.isSeen ? Get.theme.primaryColor : Get.theme.focusColor.withOpacity(0.15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight,
                          colors: [Get.theme.focusColor.withOpacity(1),
                            Get.theme.focusColor.withOpacity(0.2)
                            //notification.isSeen ? Get.theme.focusColor.withOpacity(0.6) : Get.theme.focusColor.withOpacity(1),
                            //notification.isSeen ? Get.theme.focusColor.withOpacity(0.1) : Get.theme.focusColor.withOpacity(0.2),
                            // Get.theme.focusColor.withOpacity(0.2),
                          ])),
                  child: icon ??
                      Icon(
                        Icons.notifications_outlined,
                        color: Get.theme.scaffoldBackgroundColor,
                        size: 38,
                      ),
                ),
                Positioned(
                  right: -15,
                  bottom: -30,
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                ),
                Positioned(
                  left: -20,
                  top: -55,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(150),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Text(
                      this.notification.title!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: TextStyle(
                          fontWeight:  FontWeight.bold, fontSize: 14, color: buttonColor)
                    //notification.isSeen ? FontWeight.normal : FontWeight.bold, fontSize: 14, color: buttonColor),
                  ),
                  Text(
                      this.notification.content!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      style: Get.textTheme.bodySmall?.merge(TextStyle(
                          fontWeight: FontWeight.w600,fontSize: 12, color: Colors.black87))
                    //notification.isSeen ? FontWeight.normal : FontWeight.w600,fontSize: 12, color: Colors.black87)),
                  ),
                  Text(
                    // DateFormat('d, MMMM y | HH:mm', Get.locale.toString()).format(this.notification.timestamp),
                    notification.date!,
                    //style: Get.textTheme.,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
