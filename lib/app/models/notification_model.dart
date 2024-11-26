
import 'package:mapnrank/app/models/user_model.dart';

import 'parents/model.dart';

class NotificationModel extends Model {
  int? notificationId;
  String? content;
  String? title;
  String? date;
  UserModel? userModel;


  NotificationModel({this.userModel, this.title, this.notificationId, this.content, this.date});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    super.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();

    return data;
  }




}
