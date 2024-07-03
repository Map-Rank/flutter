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
                    actions: [
                      GestureDetector(
                        onTap: (){

                        },
                        child: Center(
                          child: ClipOval(
                              child: FadeInImage(
                                width: 30,
                                height: 30,
                                fit: BoxFit.cover,
                                image:  NetworkImage(Get.find<AuthService>().user.value.avatarUrl.toString(), headers: {}),
                                placeholder: const AssetImage(
                                    "assets/images/loading.gif"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return FaIcon(FontAwesomeIcons.solidUserCircle, size: 30, color: interfaceColor,).marginOnly(right: 20,top: 10,bottom: 10);
                                },
                              )
                          ),
                        ),
                      ),
                    ],
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
                            popUpWidget:controller.allEvents[index].eventCreatorId == controller.currentUser.value.userId?
                            PopupMenuButton(
                              onSelected: (value) async{
                                if(value == 'Delete'){
                                  await controller.deleteEvent(controller.allEvents[index].eventId);
                                }
                                if(value == 'Edit'){
                                  controller.createUpdateEvents.value = true;
                                  controller.event = controller.allEvents[index];

                                  for(int i = 0; i <controller.event.sectors!.length; i++) {

                                    controller.sectorsSelected.add(controller.sectors.where((element) => element['id'] == controller.event.sectors![i]['id']).toList()[0]);
                                  }
                                  print('sectors selected : ${controller.sectorsSelected}');


                                  controller.noFilter.value = true;
                                  Get.toNamed(Routes.CREATE_EVENT);
                                }
                              },
                              itemBuilder: (context) {
                                return {'Edit', 'Delete'}.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice, style: const TextStyle(color: Colors.black),),
                                  );
                                }).toList();

                              },)
                                :PopupMenuButton(
                              onSelected: (value) async{

                              },
                              itemBuilder: (context) {
                                return {'',''}.map((String choice) {
                                  return PopupMenuItem<String>(
                                    value: choice,
                                    child: Text(choice, style: const TextStyle(color: Colors.black),),
                                  );
                                }).toList();

                              },),

                          ),
                        ))
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

                        ):
                        Center(
                          child: CircularProgressIndicator(color: interfaceColor, ),
                        ):LoadingCardWidget()
                      ]))
                ],
              )),
            )
        ),
      ),
    );
  }
}
