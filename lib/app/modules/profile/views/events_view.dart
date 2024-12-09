import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import '../../../../color_constants.dart';
import '../../../routes/app_routes.dart';
import '../../community/widgets/comment_loading_widget.dart';
import '../../global_widgets/event_card_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyEventsView extends GetView<ProfileController> {
  const MyEventsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        key: Key('event_title'),
        backgroundColor: backgroundColor,
        elevation: 0,

        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: interfaceColor),
          onPressed: () => {
            controller.profileImage.value = File('assets/images/loading.gif'),
            controller.loadProfileImage.value = false,
            Navigator.pop(context),
            //Get.back()
          },
        ),
        title:Text(
          AppLocalizations.of(context).events,
          style: TextStyle(color: Colors.black87, fontSize: 30.0),
        ),
      ),
      body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          //padding: const EdgeInsets.all(24.0),
          child: Obx(() => controller.allEvents.isNotEmpty? ListView.builder(
              itemCount: controller.allEvents.length,
              itemBuilder: (context, index) =>
                  Obx(() => EventCardWidget(
                      isAllEventsPage: false,
                      //likeTapped: RxBool(controller.allPosts[index].likeTapped),
                      content: controller.allEvents[index].content,
                      image: 'https://www.residat.com/${controller.allEvents[index].imagesUrl}',
                      eventOrganizer: controller.allEvents[index].organizer,
                      title: controller.allEvents[index].title,
                      zone: controller.allEvents[index].zone != null?controller.allEvents[index].zone: '',
                      publishedDate: controller.allEvents[index].publishedDate,
                      eventId: controller.allEvents[index].eventId,
                      popUpWidget: GestureDetector(
                          onTap: (){
                            controller.allEvents[index].eventCreatorId == controller.currentUser.value.userId?
                            showModalBottomSheet(context: context, builder: (context) => Container(
                              child: ListView(
                                padding: EdgeInsets.all(20),
                                children: [
                                  TextButton(onPressed: () async{
                                    showDialog(context: context, builder: (context){
                                      return CommentLoadingWidget();
                                    },);
                                    await Get.find<EventsController>().deleteEvent(controller.allEvents[index].eventId);
                                    Navigator.of(context).pop();
                                  }, child: Text(AppLocalizations.of(context).delete)),

                                  TextButton(onPressed: () async{
                                    showDialog(context: context, builder: (context){
                                      return CommentLoadingWidget();
                                    },);
                                    Get.find<EventsController>().createUpdateEvents.value = true;

                                    //controller.event = await controller.getAnEvent(controller.allEvents[index].eventId);
                                    Get.find<EventsController>().event = Get.find<EventsController>().allEvents[index];

                                    Get.find<EventsController>().eventLocation.text = Get.find<EventsController>().event.zone;
                                    Get.find<EventsController>().eventOrganizerController.text = Get.find<EventsController>().event.organizer!;
                                    Get.find<EventsController>().startingDateDisplay.text = Get.find<EventsController>().event.startDate!;
                                    Get.find<EventsController>().endingDateDisplay.text = Get.find<EventsController>().event.endDate!;
                                    Get.find<EventsController>().startingDateDisplay.text = Get.find<EventsController>().event.startDate!;
                                    Get.find<EventsController>().endingDateDisplay.text = Get.find<EventsController>().event.endDate!;

                                    //for(int i = 0; i <controller.event.sectors!.length; i++) {
                                    Get.find<EventsController>().sectorsSelected.add(Get.find<EventsController>().sectors.where((element) => element['id'] == Get.find<EventsController>().event.eventSectors!['id']).toList()[0]);
                                    // }


                                    if(Get.find<EventsController>().event.zoneLevelId == '2'){
                                      Get.find<EventsController>().divisionsSet = await Get.find<EventsController>().zoneRepository.getAllDivisions(3, Get.find<EventsController>().event.zoneEventId);
                                      Get.find<EventsController>().listDivisions.value =  Get.find<EventsController>().divisionsSet['data'];
                                      Get.find<EventsController>().loadingDivisions.value = ! Get.find<EventsController>().divisionsSet['status'];
                                      Get.find<EventsController>().divisions.value =  Get.find<EventsController>().listDivisions;
                                      Get.find<EventsController>().regionSelectedValue.add(Get.find<EventsController>().regions.where((element) => element['id'] == Get.find<EventsController>().event.zoneEventId).toList()[0]);

                                    }
                                    else if(Get.find<EventsController>().event.zoneLevelId == '3'){

                                      Get.find<EventsController>().divisionsSet = await Get.find<EventsController>().zoneRepository.getAllDivisions(3, int.parse(Get.find<EventsController>().event.zoneEventId));
                                      Get.find<EventsController>().listDivisions.value =  Get.find<EventsController>().divisionsSet['data'];
                                      Get.find<EventsController>().loadingDivisions.value = ! Get.find<EventsController>().divisionsSet['status'];
                                      Get.find<EventsController>().divisions.value =  Get.find<EventsController>().listDivisions;
                                      Get.find<EventsController>().regionSelectedValue.add(Get.find<EventsController>().regions.where((element) => element['id'].toString() == Get.find<EventsController>().event.zoneParentId).toList()[0]);

                                      Get.find<EventsController>().subdivisionsSet = await Get.find<EventsController>().zoneRepository.getAllSubdivisions(4, Get.find<EventsController>().event.zoneEventId);
                                      Get.find<EventsController>().listSubdivisions.value =  Get.find<EventsController>().subdivisionsSet['data'];
                                      Get.find<EventsController>().loadingSubdivisions.value = ! Get.find<EventsController>().subdivisionsSet['status'];
                                      Get.find<EventsController>().subdivisions.value =  Get.find<EventsController>().listSubdivisions;
                                      Get.find<EventsController>().divisionSelectedValue.add(Get.find<EventsController>().divisions.where((element) => element['id'] == Get.find<EventsController>().event.zoneEventId).toList()[0]);
                                    }
                                    else if(Get.find<EventsController>().event.zoneLevelId == "4"){
                                      var region = await Get.find<EventsController>().getSpecificZone(int.parse(Get.find<EventsController>().event.zoneParentId));
                                      print(region);

                                      Get.find<EventsController>().divisionsSet = await Get.find<EventsController>().zoneRepository.getAllDivisions(3, int.parse(region['parent_id']));
                                      Get.find<EventsController>().listDivisions.value =  Get.find<EventsController>().divisionsSet['data'];
                                      Get.find<EventsController>().loadingDivisions.value = ! Get.find<EventsController>().divisionsSet['status'];
                                      Get.find<EventsController>().divisions.value =  Get.find<EventsController>().listDivisions;

                                      Get.find<EventsController>().subdivisionsSet = await Get.find<EventsController>().zoneRepository.getAllSubdivisions(4, int.parse(Get.find<EventsController>().event.zoneParentId));
                                      Get.find<EventsController>().listSubdivisions.value =  Get.find<EventsController>().subdivisionsSet['data'];
                                      Get.find<EventsController>().loadingSubdivisions.value = ! Get.find<EventsController>().subdivisionsSet['status'];
                                      Get.find<EventsController>().subdivisions.value =  Get.find<EventsController>().listSubdivisions;
                                      Get.find<EventsController>().divisionSelectedValue.add(Get.find<EventsController>().divisions.where((element) => element['id'] == int.parse(Get.find<EventsController>().event.zoneParentId)).toList()[0]);

                                      Get.find<EventsController>().regionSelectedValue.add(Get.find<EventsController>().regions.where((element) => element['id'].toString() == Get.find<EventsController>().divisionSelectedValue[0]['parent_id']).toList()[0]);

                                      Get.find<EventsController>().subdivisionSelectedValue.add(Get.find<EventsController>().subdivisions.where((element) => element['id'] == Get.find<EventsController>().event.zoneEventId).toList()[0]);
                                    }


                                    Navigator.of(context).pop();


                                    Get.find<EventsController>().noFilter.value = true;
                                    Get.toNamed(Routes.CREATE_EVENT);
                                  }, child: Text(AppLocalizations.of(context).edit))
                                ],),
                            )
                              ,):
                            showModalBottomSheet(context: context, builder:(context) {
                              return Container(
                                child: ListView(
                                  padding: EdgeInsets.all(20),
                                  children: [
                                    Text(AppLocalizations.of(context).no_actions_perform, style: TextStyle(fontSize: 16, color: Colors.grey.shade900),)
                                  ],

                                ),
                              );
                            },);
                          },
                          child: Icon(FontAwesomeIcons.ellipsisVertical)
                      )
                  ))
          ):Center(
            child: SizedBox(
              height: Get.height/4,
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FaIcon(FontAwesomeIcons.folderOpen, size: 30,),
                  Text(AppLocalizations.of(context).no_events_found)
                ],
              ),
            ),

          ),)
      ),
    );
  }
}