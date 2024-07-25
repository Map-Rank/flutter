import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';


class EventDetailsView extends GetView<EventsController> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        //backgroundColor: Get.theme.colorScheme.secondary,
        body: Container(
          decoration: BoxDecoration(color: backgroundColor,
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
                    child: FaIcon(FontAwesomeIcons.arrowLeft).marginOnly(left: 20)),
                backgroundColor: Colors.transparent.withOpacity(0.4),
                elevation: 0.0,
                bottom: PreferredSize(child:SizedBox(height:100) , preferredSize: Size.fromHeight(100)),


                actions: [
                  controller.eventDetails.eventCreatorId == controller.currentUser.value.userId?
                  PopupMenuButton(
                    onSelected: (value) async{
                      if(value == 'Delete'){
                        await controller.deleteEvent(controller.eventDetails.eventId!);
                        Navigator.of(context).pop();
                      }
                      if(value == 'Edit'){
                        // controller.createUpdatePosts.value = true;
                        // controller.post = await controller.getAPost(controller.allPosts[index].eventId);
                        // print('sectors ${controller.post.sectors!}');
                        //
                        // for(int i = 0; i <controller.post.sectors!.length; i++) {
                        //
                        //   controller.sectorsSelected.add(controller.sectors.where((element) => element['id'] == controller.post.sectors![i]['id']).toList()[0]);
                        // }
                        // print('sectors selected : ${controller.sectorsSelected}');
                        //
                        //
                        // controller.noFilter.value = true;
                        // Get.toNamed(Routes.CREATE_POST);
                      }
                    },
                    itemBuilder: (context) {
                      return {'Edit', 'Delete'}.map((String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice, style: const TextStyle(color: Colors.black),),
                        );
                      }).toList();

                    },):
                  PopupMenuButton(
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
                        Text(controller.eventDetails.title!, style: TextStyle(fontSize: 20, ),).marginOnly(bottom: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const FaIcon(FontAwesomeIcons.locationDot, size: 15,).marginOnly(right: 10),
                            SizedBox(
                              width: Get.width/5.6,
                              //height: 40,
                              child: Text(controller.eventDetails.zone, overflow: TextOverflow.ellipsis,).marginOnly(right: 10),),
                            const FaIcon(FontAwesomeIcons.solidCircle, size: 10,).marginOnly(right: 10),
                            SizedBox(
                                //width: Get.width/5,
                                //height: 40,
                                child: Text(controller.eventDetails.publishedDate!, overflow: TextOverflow.ellipsis, style: Get.textTheme.headlineMedium!.merge(const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: appColor, ),))),


                            //Text("⭐️ ${this.rating}", style: TextStyle(fontSize: 13, color: appColor))
                          ],
                        ),
                        RichText(text: TextSpan(children: [
                          TextSpan(text: 'Organized by: ', style: TextStyle(color: Colors.black)),
                          TextSpan(text: controller.eventDetails.organizer, style: TextStyle(color: Colors.black))
                        ])).marginOnly(bottom: 20),
                        RichText(text: TextSpan(children: [
                          TextSpan(text: 'Starting Date: ', style: TextStyle(color: Colors.black)),
                          TextSpan(text: controller.eventDetails.startDate, style: TextStyle(color: Colors.black))
                        ])).marginOnly(bottom: 20),
                        RichText(text: TextSpan(children: [
                          TextSpan(text: 'Ending Date: ', style: TextStyle(color: Colors.black)),
                          TextSpan(text: controller.eventDetails.endDate, style: TextStyle(color: Colors.black))
                        ])).marginOnly(bottom: 20),
                        Text(controller.eventDetails.content!, style: TextStyle(fontWeight: FontWeight.normal), textAlign:TextAlign.justify, maxLines: 4, overflow: TextOverflow.ellipsis,),


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
