import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/location_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import '../../../../color_constants.dart';
import '../../../services/global_services.dart';

class BuildSelectZone extends GetView<CommunityController> {
  BuildSelectZone({Key? key,
   }) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Select a region',
            style: Get.textTheme.bodyText2?.merge(const TextStyle(color: labelColor)),
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
                                onTap: () async {
                                  //controller.regionSelectedValue.clear();
                                  if(controller.regionSelectedValue.contains(controller.regions[index]) ){
                                    controller.regionSelectedValue.clear();
                                    controller.regionSelectedValue.remove(controller.regions[index]);
                                  }
                                  else{
                                    controller.regionSelectedValue.clear();
                                    controller.regionSelectedValue.add(controller.regions[index]);
                                  }
                                  controller.regionSelected.value = !controller.regionSelected.value;
                                  controller.regionSelectedIndex.value = index;
                                  controller.divisionsSet = await controller.getAllDivisions(index);
                                  controller.listDivisions.value =  controller.divisionsSet['data'];
                                  controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                  controller.divisions.value =  controller.listDivisions;

                                  print(controller.regionSelected);

                                },
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
          if(controller.regionSelectedValue.isNotEmpty)...[
            Text('Select a division',
              style: Get.textTheme.bodyText2?.merge(const TextStyle(color: labelColor)),
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
                                  onTap: () async{
                                    if(controller.divisionSelectedValue.contains(controller.divisions[index]) ){
                                      controller.divisionSelectedValue.clear();
                                      controller.divisionSelectedValue.remove(controller.divisions[index]);
                                    }
                                    else{
                                      controller.divisionSelectedValue.clear();
                                      controller.divisionSelectedValue.add(controller.divisions[index]);
                                    }
                                    controller.divisionSelected.value = !controller.divisionSelected.value;
                                    controller.divisionSelectedIndex.value = index;
                                    controller.subdivisionsSet = await controller.getAllSubdivisions(index);
                                    controller.listSubdivisions.value = controller.subdivisionsSet['data'];
                                    controller.loadingSubdivisions.value = !controller.subdivisionsSet['status'];
                                    controller.subdivisions.value = controller.listSubdivisions;
                                    //print(controller.subdivisionSelectedValue[0]['id'].toString());

                                  },
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
          if(controller.divisionSelectedValue.isNotEmpty)...[
            Text('Select a subdivision',
              style: Get.textTheme.bodyText2?.merge(const TextStyle(color: labelColor)),
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

                                    if(controller.subdivisionSelectedValue.contains(controller.subdivisions[index]) ){



                                      if(controller.noFilter.value){
                                        controller.subdivisionSelectedValue.clear();
                                        controller.subdivisionSelectedValue.remove(controller.subdivisions[index]);
                                      }
                                      else{
                                        controller.subdivisionSelectedValue.clear();
                                        controller.subdivisionSelectedValue.remove(controller.subdivisions[index]);
                                        //controller.post?.sectors?.remove(controller.sectors[index]['id']);
                                        controller.filterSearchPostsByZone(controller.subdivisions[index]['id'].toString());
                                      }
                                    }
                                    else{
                                      if(controller.noFilter.value){
                                        controller.subdivisionSelectedValue.clear();
                                        controller.subdivisionSelectedValue.add(controller.subdivisions[index]);
                                        controller.post?.zonePostId = controller.subdivisions[index]['id'];
                                      }
                                      else{
                                        controller.subdivisionSelectedValue.clear();
                                        controller.subdivisionSelectedValue.add(controller.subdivisions[index]);
                                        //controller.post?.zonePostId = controller.subdivisions[index]['id'];
                                        controller.filterSearchPostsByZone(controller.subdivisions[index]['id'].toString());
                                      }


                                    }
                                    controller.subdivisionSelected.value = !controller.subdivisionSelected.value;
                                    controller.subdivisionSelectedIndex.value = index;


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