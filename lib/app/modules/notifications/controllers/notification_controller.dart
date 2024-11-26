// coverage:ignore-file
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:mapnrank/app/models/notification_model.dart';

import '../../../../common/ui.dart';
import '../../../models/user_model.dart';
import '../../../repositories/notification_repository.dart';
import '../../../services/auth_service.dart';




class NotificationController extends GetxController {

  final Rx<UserModel> currentUser = Get.find<AuthService>().user;
  var notifications = [].obs;
  var createdNotifications = [].obs;
  var receivedNotifications = [].obs;
  var notificationList = [];
  RxBool loadingNotifications = true.obs;
  late NotificationRepository notificationRepository;
  RxBool isMyCreatedNotification = true.obs;



  NotificationController() {
    notificationRepository = NotificationRepository();
  }

  @override
  void onInit() async {
    notificationRepository = NotificationRepository();
    notifications.value = await getNotifications();


    super.onInit();
  }

  Future refreshNotification() async {
    notificationList = await getNotifications();
    notifications.value = notificationList;


  }

  classifyNotifications(var notificationList){
    createdNotifications.clear();
    receivedNotifications.clear();
    for(var notification in notificationList){
      if(notification.userModel.userId == Get.find<AuthService>().user.value.userId ){
        createdNotifications.add(notification);
      }
      else{
        receivedNotifications.add(notification);
      }
    }
  }

  Future getNotifications() async {
    loadingNotifications.value = true;
    notificationList.clear();
    notifications.clear();
    try{
      var list = await notificationRepository.getUserNotifications();
      print(list);
      for( var i = 0; i< list.length; i++){
        UserModel user = UserModel(
            userId: list[i]['user']['id'],
            lastName:list[i]['user']['last_name'],
            firstName: list[i]['user']['first_name'],
            avatarUrl: list[i]['user']['avatar']
        );
        var notification = NotificationModel(
          notificationId: list[i]['id'],
            content: Get.find<AuthService>().user.value.language == 'en'?list[i]['content_en']:list[i]['content_fr'],
          title: Get.find<AuthService>().user.value.language == 'en'?list[i]['titre_en']:list[i]['titre_fr'],
          userModel: user,
          date: list[i]['created_at']

        );
        //notificationList.clear();
        notificationList.add(notification);
      }
      if(currentUser.value.type?.toUpperCase() == "COUNCIL"){
        await classifyNotifications(notificationList);
      }
      loadingNotifications.value = false;
      return notificationList;

    }
    catch (e) {
      if(! Platform.environment.containsKey('FLUTTER_TEST')){
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
    }
    finally {
      loadingNotifications.value = false;


    }



  }
}


