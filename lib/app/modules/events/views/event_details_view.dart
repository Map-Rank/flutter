import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../community/widgets/comment_loading_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class EventDetailsView extends GetView<EventsController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        //backgroundColor: Get.theme.colorScheme.secondary,
        body: Container(
          decoration: BoxDecoration(color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20.0),
                topLeft: Radius.circular(20.0)),

          ),
          child: CustomScrollView(
            primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                leading: GestureDetector(
                  onTap: (){
                    Navigator.of(context).pop();
                  },
                    child: const Icon(Icons.arrow_back_ios, color: secondaryColor, size: 30, fill: 0.8, weight: 0.8,opticalSize: 0.8,applyTextScaling: true,).marginOnly(left: 20)),
                backgroundColor: Colors.transparent.withOpacity(0.4),
                elevation: 0.0,
                bottom: PreferredSize(child:SizedBox(height:100) , preferredSize: Size.fromHeight(100)),


                actions: [
                  GestureDetector(
                      onTap: (){
                        controller.eventDetails.eventCreatorId == controller.currentUser.value.userId?
                        showModalBottomSheet(context: context, builder: (context) => Container(
                          child: ListView(
                            padding: EdgeInsets.all(20),
                            children: [
                              TextButton(onPressed: () async{
                                showDialog(context: context, builder: (context){
                                  return CommentLoadingWidget();
                                },);
                                await controller.deleteEvent(controller.eventDetails.eventId!);
                                Navigator.of(context).pop();
                              }, child: Text(AppLocalizations.of(context).delete)),

                              TextButton(onPressed: () async{
                                showDialog(context: context, builder: (context){
                                  return CommentLoadingWidget();
                                },);
                                controller.createUpdateEvents.value = true;

                                //controller.event = await controller.getAnEvent(controller.allEvents[index].eventId);
                                controller.event = controller.eventDetails;

                                controller.eventLocation.text = controller.event.zone;
                                controller.eventOrganizerController.text = controller.event.organizer!;
                                controller.startingDateDisplay.text = controller.event.startDate!;
                                controller.endingDateDisplay.text = controller.event.endDate!;
                                controller.startingDateDisplay.text = controller.event.startDate!;
                                controller.endingDateDisplay.text = controller.event.endDate!;

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

                ],
                //toolbarHeight: Get.height/4,


                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background:
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Container(
                        width: Get.width,
                        //padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                          backgroundBlendMode: BlendMode.darken, color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(30.0),
                            bottomRight: Radius.circular(30.0)),
                      ),
                      child: FadeInImage(
                              fit: BoxFit.cover,
                              image:  NetworkImage(controller.eventDetails.imagesUrl!, headers: {}),
                              placeholder: const AssetImage(
                                  "assets/images/loading.gif"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    "assets/images/user_admin.png",
                                    fit: BoxFit.fitWidth);
                              },
                            ),

                          ),
                      Positioned(
                          child: Text(controller.eventDetails.startDate!, style: TextStyle(color: Colors.white, fontSize: 20),
                          )
                      )

                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                  child:Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(controller.eventDetails.title!, style: Get.textTheme.headlineLarge?.merge(TextStyle(fontSize: 20)),),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const FaIcon(FontAwesomeIcons.locationDot, size: 15,).marginOnly(right: 10),
                            SizedBox(
                              //width: Get.width/1.8,
                              //height: 40,
                              child: Text(controller.eventDetails.zone, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodySmall).marginOnly(right: 10),),
                            const FaIcon(FontAwesomeIcons.solidCircle, size: 10,).marginOnly(right: 10),
                            SizedBox(
                                //width: Get.width/5,
                                //height: 40,
                                child: Text(controller.eventDetails.publishedDate!, overflow: TextOverflow.ellipsis, style: Get.textTheme.bodySmall)),


                            //Text("⭐️ ${this.rating}", style: TextStyle(fontSize: 13, color: appColor))
                          ],
                        ).marginOnly(bottom: 20),
                        RichText(text: TextSpan(children: [
                          TextSpan(text: '${AppLocalizations.of(context).organized_by}  ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800)),
                          TextSpan(text: controller.eventDetails.organizer, style: TextStyle(color: Colors.black))
                        ])).marginOnly(bottom: 20),
                       Wrap(
                         children: [
                           RichText(text: TextSpan(children: [
                             WidgetSpan(child: Text('${AppLocalizations.of(context).from}: ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14))),
                             WidgetSpan(child: Text(controller.eventDetails.startDate!, style: TextStyle(color: Colors.black, )))
                           ])),
                           RichText(text: TextSpan(children: [
                             WidgetSpan(child: Text(' ${AppLocalizations.of(context).to} : ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.w800, fontSize: 14))),
                             WidgetSpan(child: Text(controller.eventDetails.endDate!, style: TextStyle(color: Colors.black)))
                           ]))
                         ],
                       ).marginOnly(bottom: 20),
                        Text(controller.eventDetails.content!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''), style: Get.textTheme.displayMedium, textAlign:TextAlign.justify, maxLines: 4, overflow: TextOverflow.ellipsis,),


                      ],
                    )
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }
}
