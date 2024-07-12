import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/location_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:mapnrank/common/ui.dart';
import '../../../../color_constants.dart';

class BuildSelectZone extends GetView<EventsController> {
  BuildSelectZone({Key? key,
  }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>EventsController());
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if(!controller.chooseARegion.value)...[
            GestureDetector(
              onTap: (){
                controller.chooseARegion.value = true;
              },
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey)),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Choose a region', key: Key('chooseRegion'),),
                    FaIcon(FontAwesomeIcons.angleDown, key: Key('chooseRegionIcon'),)
                  ],
                ),
              ),
            )
          ]
          else...[
            Text('Select a region',
              style: Get.textTheme.bodyMedium?.merge(const TextStyle(color: labelColor)),
              textAlign: TextAlign.start,
            ),
            Obx(() =>
                Column(
                  children: [
                    TextFieldWidget(
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      validator: (input) => input!.isEmpty ? 'Required field' : null,
                      //onChanged: (input) => controller.selectUser.value = input,
                      //labelText: "Research receiver".tr,
                      iconData: FontAwesomeIcons.search,
                      style: const TextStyle(color: labelColor),
                      hintText: 'Search by region name',
                      onChanged: (value)=>{
                        controller.filterSearchRegions(value)
                      },
                      errorText: '', suffixIcon: const Icon(null), suffix: const Icon(null),
                    ),
                    controller.loadingRegions.value ?
                    Column(
                      children: [
                        for(var i=0; i < 4; i++)...[
                          Container(
                              width: Get.width,
                              height: 60,
                              margin: const EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  'assets/images/loading.gif',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 40,
                                ),
                              ))
                        ]
                      ],
                    ) :
                    Container(
                        margin: const EdgeInsetsDirectional.only(end: 10, start: 10, top: 10, bottom: 10),
                        // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),

                        child: ListView.builder(
                          //physics: AlwaysScrollableScrollPhysics(),
                            itemCount: controller.regions.length > 5 ? 5 : controller.regions.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {

                              return GestureDetector(
                                // coverage:ignore-start
                                  onTap: () async {
                                    controller.regionSelected.value = !controller.regionSelected.value;
                                    controller.regionSelectedIndex.value = index;
                                    if(controller.regionSelectedValue.contains(controller.regions[index]) ){
                                      if(controller.noFilter.value){
                                        controller.regionSelectedValue.remove(controller.regions[index]);
                                        controller.chooseARegion.value = false;
                                        controller.regionSelectedValue.clear();


                                      }
                                      else{
                                        controller.regionSelectedValue.remove(controller.regions[index]);
                                        controller.regionSelectedValue.clear();
                                        controller.filterSearchEventsByZone(controller.regions[index]['id']);
                                        controller.chooseARegion.value = false;
                                        controller.loadingEvents.value = true;
                                        controller.listAllEvents = await controller.getAllEvents(0);
                                        controller.allEvents.value = controller.listAllEvents;
                                        //controller.allPosts.value = await controller.getAllPosts(0);
                                        //controller.filterSearchPostsByRegionZone(controller.regions[index]['id'].toString());
                                        //controller.post?.sectors?.remove(controller.sectors[index]['id']);
                                      }

                                    }
                                    else{

                                      if(controller.noFilter.value){
                                        controller.regionSelectedValue.clear();
                                        controller.event?.zoneEventId = controller.regions[index]['id'];
                                        controller.regionSelectedValue.add(controller.regions[index]);

                                      }
                                      else{
                                        controller.regionSelectedValue.clear();
                                        controller.event?.zoneEventId = controller.regions[index]['id'];
                                        controller.regionSelectedValue.add(controller.regions[index]);
                                        controller.filterSearchEventsByZone(controller.regions[index]['id']);
                                        //controller.filterSearchPostsByRegionZone(controller.regions[index]['id'].toString());
                                        //controller.post?.sectors?.remove(controller.sectors[index]['id']);
                                      }



                                    }

                                    controller.divisionsSet = await controller.getAllDivisions(index);
                                    controller.listDivisions.value =  controller.divisionsSet['data'];
                                    controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                    controller.divisions.value =  controller.listDivisions;


                                  },
                                  // coverage:ignore-end
                                  child: Obx(() => LocationWidget(
                                    regionName: controller.regions[index]['name'],
                                    selected: controller.regionSelectedIndex.value == index && controller.regionSelectedValue.contains(controller.regions[index]) ? true  : false ,
                                  ))
                              );
                            })
                    )
                  ],
                ),
            ).marginOnly(bottom: 20),
          ],
          if(!controller.chooseADivision.value ||controller.regionSelectedValue.isEmpty)...[
            GestureDetector(
              // coverage:ignore-start
              onTap: (){
                controller.chooseADivision.value = true;
                if(controller.regionSelectedValue.isEmpty) {
                  Get.showSnackbar(Ui.warningSnackBar(message: "Please Choose a region first"));
                }
              },
              // coverage:ignore-end
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey)),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Choose a Division'),
                    FaIcon(FontAwesomeIcons.angleDown)
                  ],
                ),
              ),
            ),

          ]
          else...[
            Text('Select a division',
              style: Get.textTheme.bodyMedium?.merge(const TextStyle(color: labelColor)),
              textAlign: TextAlign.start,
            ),
            Obx(() =>
                Column(
                  children: [
                    TextFieldWidget(
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      validator: (input) => input!.isEmpty ? 'Required field' : null,
                      //onChanged: (input) => controller.selectUser.value = input,
                      //labelText: "Research receiver".tr,
                      iconData: FontAwesomeIcons.search,
                      style: const TextStyle(color: labelColor),
                      hintText: 'Search by division name',
                      onChanged: (value)=>{
                        controller.filterSearchDivisions(value)
                      },
                      errorText: '', suffixIcon: const Icon(null), suffix: const Icon(null),
                    ),
                    controller.loadingDivisions.value ?
                    Column(
                      children: [
                        for(var i=0; i < 4; i++)...[
                          Container(
                              width: Get.width,
                              height: 60,
                              margin: const EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  'assets/images/loading.gif',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 40,
                                ),
                              ))
                        ]
                      ],
                    ) :
                    Container(
                        margin: const EdgeInsetsDirectional.only(end: 10, start: 10, top: 10, bottom: 10),
                        // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),

                        child: ListView.builder(
                          //physics: AlwaysScrollableScrollPhysics(),
                            itemCount: controller.divisions.length > 5 ? 5 : controller.divisions.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {

                              return GestureDetector(
                                // coverage:ignore-start
                                  onTap: () async{
                                    controller.divisionSelected.value = !controller.divisionSelected.value;
                                    controller.divisionSelectedIndex.value = index;
                                    if(controller.divisionSelectedValue.contains(controller.divisions[index]) ){
                                      if(controller.noFilter.value){
                                        controller.divisionSelectedValue.remove(controller.divisions[index]);
                                        controller.divisionSelectedValue.clear();
                                        controller.chooseADivision.value = false;

                                      }
                                      else{
                                        controller.divisionSelectedValue.remove(controller.divisions[index]);
                                        controller.divisionSelectedValue.clear();
                                        controller.chooseADivision.value = false;
                                        //controller.post?.sectors?.remove(controller.sectors[index]['id']);
                                        //controller.filterSearchPostsByDivisionZone(controller.divisions[index]['id'].toString());
                                        await controller.filterSearchEventsByZone(controller.regionSelectedValue[0]['id']);

                                      }


                                    }
                                    else{

                                      if(controller.noFilter.value){
                                        controller.divisionSelectedValue.clear();
                                        controller.event?.zoneEventId = controller.divisions[index]['id'];
                                        controller.divisionSelectedValue.add(controller.divisions[index]);
                                      }
                                      else{
                                        controller.divisionSelectedValue.clear();
                                        controller.divisionSelectedValue.add(controller.divisions[index]);
                                        await controller.filterSearchEventsByZone(controller.divisions[index]['id']);
                                        //controller.filterSearchPostsByDivisionZone(controller.divisions[index]['id'].toString());
                                      }
                                    }





                                    controller.subdivisionsSet = await controller.getAllSubdivisions(index);
                                    controller.listSubdivisions.value = controller.subdivisionsSet['data'];
                                    controller.loadingSubdivisions.value = !controller.subdivisionsSet['status'];
                                    controller.subdivisions.value = controller.listSubdivisions;
                                    //print(controller.subdivisionSelectedValue[0]['id'].toString());

                                  },
                                  // coverage:ignore-end
                                  child: Obx(() => LocationWidget(
                                    regionName: controller.divisions[index]['name'],
                                    selected: controller.divisionSelectedIndex.value == index && controller.divisionSelectedValue.contains(controller.divisions[index]) ? true  : false ,
                                  ))
                              );
                            })
                    )
                  ],
                ),
            ).marginOnly(bottom: 20),
          ],
          if(!controller.chooseASubDivision.value || controller.divisionSelectedValue.isEmpty)...[
            GestureDetector(
              onTap: (){
                controller.chooseASubDivision.value = true;
                if(controller.regionSelectedValue.isEmpty) {
                  Get.showSnackbar(Ui.warningSnackBar(message: "Please Choose a region first then a subdivision"));
                }
                else if(controller.divisionSelectedValue.isEmpty) {
                  Get.showSnackbar(Ui.warningSnackBar(message: "Please Choose a division first"));
                }
              },
              child: Container(
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey)),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Choose a Sub-Division'),
                    FaIcon(FontAwesomeIcons.angleDown)
                  ],
                ),
              ),
            )
          ]
          else...[
            Text('Select a subdivision',
              style: Get.textTheme.bodyMedium?.merge(const TextStyle(color: labelColor)),
              textAlign: TextAlign.start,
            ),
            Obx(() =>
                Column(
                  children: [
                    TextFieldWidget(
                      readOnly: false,
                      keyboardType: TextInputType.text,
                      validator: (input) => input!.isEmpty ? 'Required field' : null,
                      //onChanged: (input) => controller.selectUser.value = input,
                      //labelText: "Research receiver".tr,
                      iconData: FontAwesomeIcons.search,
                      style: const TextStyle(color: labelColor),
                      hintText: 'Search by sub-division name',
                      onChanged: (value)=>{
                        controller.filterSearchSubdivisions(value)
                      },
                      errorText: '', suffixIcon: const Icon(null), suffix: const Icon(null),
                    ),
                    controller.loadingSubdivisions.value  ?
                    Column(
                      children: [
                        for(var i=0; i < 4; i++)...[
                          Container(
                              width: Get.width,
                              height: 60,
                              margin: const EdgeInsets.all(5),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                child: Image.asset(
                                  'assets/images/loading.gif',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 40,
                                ),
                              ))
                        ]
                      ],
                    ) :
                    Container(
                        margin: const EdgeInsetsDirectional.only(end: 10, start: 10, top: 10, bottom: 10),
                        // padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                          ],
                        ),

                        child: ListView.builder(
                          //physics: AlwaysScrollableScrollPhysics(),
                            itemCount: controller.subdivisions.length > 5 ? 5 : controller.subdivisions.length,
                            shrinkWrap: true,
                            primary: false,
                            itemBuilder: (context, index) {

                              return GestureDetector(
                                  onTap: () async {
                                    controller.subdivisionSelected.value = !controller.subdivisionSelected.value;
                                    controller.subdivisionSelectedIndex.value = index;

                                    if(controller.subdivisionSelectedValue.contains(controller.subdivisions[index]) ){



                                      if(controller.noFilter.value){
                                        controller.subdivisionSelectedValue.clear();
                                        controller.subdivisionSelectedValue.remove(controller.subdivisions[index]);
                                        controller.chooseASubDivision.value = false;
                                      }
                                      else{
                                        controller.subdivisionSelectedValue.clear();
                                        controller.subdivisionSelectedValue.remove(controller.subdivisions[index]);
                                        controller.chooseASubDivision.value = false;
                                        await controller.filterSearchEventsByZone(controller.divisionSelectedValue[0]['id']);
                                        //controller.filterSearchPostsBySubdivisionZone(controller.subdivisions[index]['id'].toString());

                                      }
                                    }
                                    else{
                                      if(controller.noFilter.value){
                                        controller.subdivisionSelectedValue.clear();
                                        controller.subdivisionSelectedValue.add(controller.subdivisions[index]);
                                        controller.event?.zoneEventId = controller.subdivisions[index]['id'];
                                      }
                                      else{
                                        controller.subdivisionSelectedValue.clear();
                                        controller.subdivisionSelectedValue.add(controller.subdivisions[index]);
                                        //controller.post?.zonePostId = controller.subdivisions[index]['id'];
                                        //controller.filterSearchPostsBySubdivisionZone(controller.subdivisions[index]['id'].toString());
                                        await controller.filterSearchEventsByZone(controller.subdivisions[index]['id']);
                                      }


                                    }



                                    print(controller.subdivisions);

                                    //controller.currentUser.value.zoneId = controller.subdivisionSelectedValue[0]['id'].toString();


                                    //print(controller.subdivisionSelected);

                                  },
                                  child: Obx(() => LocationWidget(
                                    regionName: controller.subdivisions[index]['name'],
                                    selected: controller.subdivisionSelectedIndex.value == index && controller.subdivisionSelectedValue.contains(controller.subdivisions[index]) ? true  : false ,
                                  ))
                              );
                            })
                    )
                  ],
                ),
            ).marginOnly(bottom: 20),
          ],

          const SizedBox(height: 20),

        ],
      ),

    ));
  }
}