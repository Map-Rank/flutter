import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/modules/events/widgets/buildSelectSector.dart';
import 'package:mapnrank/app/modules/events/widgets/buildSelectZone.dart';
import 'package:mapnrank/app/modules/global_widgets/event_card_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/loading_cards.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../community/widgets/comment_loading_widget.dart';


class EventsView extends GetView<EventsController> {
  const EventsView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>CommunityController());
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: secondaryColor,
        floatingActionButton:  FloatingActionButton.extended(
            backgroundColor: interfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: (){
              controller.noFilter.value = true;
              controller.chooseARegion.value = false;
              controller.chooseADivision.value = false;
              controller.chooseASubDivision.value = false;

              if(controller.event?.sectors != null){
                controller.event?.sectors!.clear();
              }
              Get.toNamed(Routes.CREATE_EVENT);
            },
            heroTag: null,
            icon: const FaIcon(FontAwesomeIcons.add),
            label: const Text('Create an event')),
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshEvents(showMessage: true);
              controller.onInit();
            },
            child: Container(
              decoration: BoxDecoration(color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),

              ),
              child: Obx(() => CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    //expandedHeight: 80,
                    leadingWidth: 0,
                    floating: true,
                    toolbarHeight: 80,
                    leading: Icon(null),
                    centerTitle: true,
                    backgroundColor: backgroundColor,
                    title: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(color: interfaceColor))
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            icon: Icon(Icons.filter_list_rounded, color: interfaceColor) ,
                            label: Text('Filter by sector', style: TextStyle(color: interfaceColor)),
                            onPressed: () {

                              controller.noFilter.value = false;
                              showModalBottomSheet(context: context,

                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                builder: (context) {
                                  return Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: const BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))

                                      ),
                                      child: ListView(children: [BuildSelectSector()])
                                  );
                                },
                              );

                            },),
                          SizedBox(
                            height: 30,
                            child:  VerticalDivider(color: interfaceColor, thickness: 4, ),
                          ),

                          TextButton.icon(
                            icon: Icon(Icons.filter_list_rounded, color: interfaceColor) ,
                            label: Text('Filter by zone', style: TextStyle(color: interfaceColor),),
                            onPressed: () {

                              controller.noFilter.value = false;
                              showModalBottomSheet(context: context,

                                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                builder: (context) {
                                  return Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: const BoxDecoration(
                                          color: backgroundColor,
                                          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))

                                      ),
                                      child: ListView(children:[BuildSelectZone()] )
                                  );
                                },
                              );

                            },),

                        ],),
                    ),

                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                    ),

                  ),



                  SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        return controller.loadingEvents.value?
                        const LoadingCardWidget()
                            :controller.allEvents.isNotEmpty?
                        Obx(() => GestureDetector(
                          onTap: (){
                            controller.eventDetails = controller.allEvents[index];
                            Get.toNamed(Routes.EVENT_DETAILS_VIEW);
                          },
                          child: EventCardWidget(
                            //likeTapped: RxBool(controller.allPosts[index].likeTapped),
                            content: controller.allEvents[index].content,
                            image: controller.allEvents[index].imagesUrl,
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
                                                await controller.deleteEvent(controller.allEvents[index].eventId);
                                                Navigator.of(context).pop();
                                              }, child: Text('Delete')),
                                              
                                              TextButton(onPressed: () async{
                                      showDialog(context: context, builder: (context){
                                        return CommentLoadingWidget();
                                      },);
                                      controller.createUpdateEvents.value = true;

                                      //controller.event = await controller.getAnEvent(controller.allEvents[index].eventId);
                                      controller.event = controller.allEvents[index];

                                      controller.eventLocation.text = controller.event.zone;
                                      controller.eventOrganizerController.text = controller.event.organizer!;
                                      controller.startingDateDisplay.value = controller.event.startDate!;
                                      controller.endingDateDisplay.value = controller.event.endDate!;
                                      controller.startingDateDisplay.value = controller.event.startDate!;
                                      controller.endingDateDisplay.value = controller.event.endDate!;

                                      //for(int i = 0; i <controller.event.sectors!.length; i++) {
                                      controller.sectorsSelected.add(controller.sectors.where((element) => element['id'] == controller.event.eventSectors!['id']).toList()[0]);
                                      // }


                                      if(controller.event.zoneLevelId == '2'){
                                        controller.divisionsSet = await controller.zoneRepository.getAllDivisions(3, controller.event.zoneEventId);
                                        controller.listDivisions.value =  controller.divisionsSet['data'];
                                        controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                        controller.divisions.value =  controller.listDivisions;
                                        controller.regionSelectedValue.add(controller.regions.where((element) => element['id'] == controller.event.zoneEventId).toList()[0]);

                                      }
                                      else if(controller.event.zoneLevelId == '3'){

                                        controller.divisionsSet = await controller.zoneRepository.getAllDivisions(3, int.parse(controller.event.zoneEventId));
                                        controller.listDivisions.value =  controller.divisionsSet['data'];
                                        controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                        controller.divisions.value =  controller.listDivisions;
                                        controller.regionSelectedValue.add(controller.regions.where((element) => element['id'].toString() == controller.event.zoneParentId).toList()[0]);
                                        //controller.regionSelectedValue.add(controller.regions.where((element) => element['id'] == controller.post.zonePostId).toList()[0]);
                                        print('Divisions : ${controller.divisions}');
                                        print('Divisions : ${controller.event.zoneEventId}');

                                        controller.subdivisionsSet = await controller.zoneRepository.getAllSubdivisions(4, controller.event.zoneEventId);
                                        controller.listSubdivisions.value =  controller.subdivisionsSet['data'];
                                        controller.loadingSubdivisions.value = ! controller.subdivisionsSet['status'];
                                        controller.subdivisions.value =  controller.listSubdivisions;
                                        controller.divisionSelectedValue.add(controller.divisions.where((element) => element['id'] == controller.event.zoneEventId).toList()[0]);
                                      }
                                      else if(controller.event.zoneLevelId == "4"){
                                        var region = await controller.getSpecificZone(int.parse(controller.event.zoneParentId));
                                        print(region);

                                        controller.divisionsSet = await controller.zoneRepository.getAllDivisions(3, int.parse(region['parent_id']));
                                        controller.listDivisions.value =  controller.divisionsSet['data'];
                                        controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                        controller.divisions.value =  controller.listDivisions;

                                        controller.subdivisionsSet = await controller.zoneRepository.getAllSubdivisions(4, int.parse(controller.event.zoneParentId));
                                        controller.listSubdivisions.value =  controller.subdivisionsSet['data'];
                                        controller.loadingSubdivisions.value = ! controller.subdivisionsSet['status'];
                                        controller.subdivisions.value =  controller.listSubdivisions;
                                        controller.divisionSelectedValue.add(controller.divisions.where((element) => element['id'] == int.parse(controller.event.zoneParentId)).toList()[0]);

                                        print(controller.subdivisions);


                                        controller.regionSelectedValue.add(controller.regions.where((element) => element['id'].toString() == controller.divisionSelectedValue[0]['parent_id']).toList()[0]);



                                        controller.subdivisionSelectedValue.add(controller.subdivisions.where((element) => element['id'] == controller.event.zoneEventId).toList()[0]);
                                      }


                                      Navigator.of(context).pop();


                                      controller.noFilter.value = true;
                                      Get.toNamed(Routes.CREATE_EVENT);
                                    }, child: Text('Edit'))
                                            ],),
                                        )
                                            ,):
                                            showModalBottomSheet(context: context, builder:(context) {
                                              return Container(
                                              child: ListView(
                                              children: [],

                                              ),
                                              );
                                            },);
                                  },
                                    child: Icon(FontAwesomeIcons.ellipsisVertical)
                            )
                          )
                        )
                        )

                            :Center(
                          child: SizedBox(
                            height: Get.height/2,
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: const [
                                FaIcon(FontAwesomeIcons.folderOpen, size: 30,),
                                Text('No events found')
                              ],
                            ),
                          ),

                        );
                      },
                          childCount: controller.allEvents.length
                      )),

                  SliverList(
                      delegate: SliverChildListDelegate([
                        !controller.loadingEvents.value?
                        controller.allEvents.isEmpty?
                        Center(
                          child: SizedBox(
                            //height: Get.height/2,
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children:  [
                                SizedBox(height: Get.height/4),
                                FaIcon(FontAwesomeIcons.folderOpen, size: 30,),
                                Text('No events found')
                              ],
                            ),
                          ),

                        ):controller.page >0?
                        Center(
                          child: CircularProgressIndicator(color: interfaceColor, ),
                        ):SizedBox():LoadingCardWidget()
                      ]))
                ],
              )),
            )
        ),
      ),
    );
  }
}
