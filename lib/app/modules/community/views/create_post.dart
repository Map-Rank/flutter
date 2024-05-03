import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapnrank/app/models/post_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/location_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import '../../../../color_constants.dart';

class CreatePostView extends GetView<CommunityController> {
  const CreatePostView({super.key});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: Get.theme.colorScheme.secondary,
          elevation: 0,
          title:  Text(
            'Create a Post'.tr,
            style: Get.textTheme.headline6!.merge(TextStyle(color: Colors.white)),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => {
              Navigator.pop(context),
              //Get.back()
            },
          ),
        ),
        bottomSheet: SizedBox(
            height: 80,
            child: Center(
                child: InkWell(
                    onTap: () async{
                      controller.createPost(controller.post!);
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: interfaceColor,
                          ),

                        width: Get.width/2,
                        height: 40,
                        margin: EdgeInsets.symmetric(vertical: 10),
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Center(
                            child: Obx(() =>  !controller.createPosts.value ?
                            Text('Post', style: Get.textTheme.bodyText2!.merge(TextStyle(color: Colors.white)))
                                : SizedBox(height: 20,
                                child: SpinKitThreeBounce(color: Colors.white, size: 20))
                            )
                        )
                    )
                )
            )
        ),
        body: Theme(
          data: ThemeData(
            //canvasColor: Colors.yellow,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: Get.theme.colorScheme.secondary,
                //background: Colors.red,
                secondary: validateColor,
              )
          ),
          child: Container(
            decoration: const BoxDecoration(color: backgroundColor,
              ),
            child:  Obx(() => ListView(
              children: [
                Column(
                    children: <Widget>[
                      Card(
                          elevation: 0,
                          child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                height: Get.height*0.5,
                                child: TextFormField(
                                  style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                  cursorColor: Colors.black,
                                  textInputAction:TextInputAction.done ,
                                  maxLines: 20,
                                  minLines: 2,
                                  onChanged: (input) => controller.post!.content = input,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //label: Text(AppLocalizations.of(context).description),
                                      fillColor: Palette.background,
                                      enabledBorder: InputBorder.none,
                                      //filled: true,
                                      prefixIcon: Icon(Icons.description),
                                      hintText: 'Share your thoughts ',
                                      hintStyle: TextStyle(fontSize: 28, color: Colors.grey.shade400)
                                  ),

                                ),
                              )
                          )
                      )
                    ]
                ).marginOnly(top: 20, bottom: 5),

                buildInputImages(context),

                buildSelectSector(context),

                buildSelectZone(context),




              ],
            ).paddingOnly(bottom: 80),)
          ),
        )
    );
  }

  Widget buildSelectSector(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [

        Text('Select a sector',
          style: Get.textTheme.bodyText2?.merge(TextStyle(color: labelColor)),
          textAlign: TextAlign.start,
        ),
        Obx(() =>
            Column(
              children: [
                TextFieldWidget(
                  readOnly: false,
                  keyboardType: TextInputType.text,
                  validator: (input) => input!.isEmpty ? 'Required field' : null,
                  iconData: FontAwesomeIcons.search,
                  style: const TextStyle(color: labelColor),
                  hintText: 'Select or search by sector name',
                  onChanged: (value)=>{
                    controller.filterSearchSectors(value)
                  },
                  errorText: '', suffixIcon: const Icon(null), suffix: const Icon(null),
                ),
                controller.loadingSectors.value ?
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
                        itemCount:controller.sectors.length,
                        shrinkWrap: true,
                        primary: false,
                        itemBuilder: (context, index) {

                          return GestureDetector(
                              onTap: () async {


                                controller.selectedIndex. value = index;
                                if(controller.sectorsSelected.contains(controller.sectors[index]) ){
                                  controller.sectorsSelected.remove(controller.sectors[index]);
                                }
                                else{
                                  controller.sectorsSelected.add(controller.sectors[index]);
                                  controller.post?.sectorPostId = controller.sectors[index]['id'];
                                }



                              },
                              child: Obx(() => LocationWidget(
                                regionName: controller.sectors[index]['name'],
                                selected: controller.sectorsSelected.contains(controller.sectors[index])? true : false,
                              ).marginOnly(bottom: 5))
                          );
                        })
                )
              ],
            ),
        ).marginOnly(bottom: 20),

        const SizedBox(height: 20),
      ],
    );
  }

  Widget buildSelectZone(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('Select a region',
            style: Get.textTheme.bodyText2?.merge(TextStyle(color: labelColor)),
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
              style: Get.textTheme.bodyText2?.merge(TextStyle(color: labelColor)),
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
                    controller.loadingSubdivisions.value ?
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
                                      controller.subdivisionSelectedValue.clear();
                                      controller.subdivisionSelectedValue.remove(controller.subdivisions[index]);
                                    }
                                    else{
                                      controller.subdivisionSelectedValue.clear();
                                      controller.subdivisionSelectedValue.add(controller.subdivisions[index]);
                                      controller.post?.zonePostId = controller.subdivisions[index]['id'];
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

    );
  }

  Widget buildInputImages(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        //borderRadius: BorderRadius.all(Radius.circular(10)),
        color: backgroundColor,
      ),
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          SizedBox(height: 10),
         Obx(() =>  controller.imageFiles.length <= 0 ?
         GestureDetector(
             onTap: () {
               showDialog(
                   context: Get.context!,
                   builder: (_){
                     return AlertDialog(
                       shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.all(Radius.circular(20))
                       ),
                       content: Container(
                           height: 140,
                           padding: EdgeInsets.all(10),
                           child: Column(
                               children: [
                                 ListTile(
                                   onTap: ()async{
                                     await controller.pickImage(ImageSource.camera);
                                     Navigator.pop(Get.context!);
                                   },
                                   leading: Icon(FontAwesomeIcons.camera),
                                   title: Text('Take a picture', style: Get.textTheme.headline1!.merge(TextStyle(fontSize: 15))),
                                 ),
                                 ListTile(
                                   onTap: ()async{
                                     await controller.pickImage(ImageSource.gallery);
                                     Navigator.pop(Get.context!);
                                   },
                                   leading: Icon(FontAwesomeIcons.image),
                                   title: Text('Upload an image', style: Get.textTheme.headline1!.merge(TextStyle(fontSize: 15))),
                                 )
                               ]
                           )
                       ),
                       actions: [
                         TextButton(
                             onPressed: ()=> Navigator.pop(context),
                             child: Text('Cancel', style: Get.textTheme.headline4!.merge(TextStyle(color: inactive)),))
                       ],
                     );
                   });
             },
             child: const Align(
                 alignment: Alignment.centerRight,

                 child: FaIcon(FontAwesomeIcons.camera))
         )
             : Column(
           children: [
             SizedBox(
               height:Get.width/2,
               child: ListView.separated(
                   scrollDirection: Axis.horizontal,
                   padding: EdgeInsets.all(12),
                   itemBuilder: (context, index){
                     return Stack(
                       //mainAxisAlignment: MainAxisAlignment.end,
                       children: [
                         Padding(
                             padding: EdgeInsets.symmetric(vertical: 10),
                             child: ClipRRect(
                               borderRadius: BorderRadius.all(Radius.circular(10)),
                               child: Image.file(
                                 controller.imageFiles[index],
                                 fit: BoxFit.cover,
                                 width: Get.width/2,
                                 height:Get.width/2,
                               ),
                             )
                         ),
                         Positioned(
                           top:0,
                           right:0,
                           child: Align(
                             //alignment: Alignment.centerRight,
                             child: IconButton(
                                 onPressed: (){
                                   controller.imageFiles.removeAt(index);
                                 },
                                 icon: Icon(Icons.delete, color: inactive, size: 25, )
                             ),
                           ),
                         ),
                       ],
                     );
                   },
                   separatorBuilder: (context, index){
                     return SizedBox(width: 8);
                   },
                   itemCount: controller.imageFiles.length),
             ),
             Align(
               alignment: Alignment.centerRight,
               child: Visibility(
                   child: InkWell(
                     onTap: (){
                       showDialog(
                           context: Get.context!,
                           builder: (_){
                             return AlertDialog(
                               shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.all(Radius.circular(20))
                               ),
                               content: Container(
                                   height: 140,
                                   padding: EdgeInsets.all(10),
                                   child: Column(
                                     children: [
                                       ListTile(
                                         onTap: ()async{
                                           await controller.pickImage(ImageSource.camera);
                                           Navigator.pop(Get.context!);
                                         },
                                         leading: Icon(FontAwesomeIcons.camera),
                                         title: Text('Take a picture', style: Get.textTheme.headline1!.merge(TextStyle(fontSize: 15))),
                                       ),
                                       ListTile(
                                         onTap: ()async{
                                           await controller.pickImage(ImageSource.gallery);
                                           Navigator.pop(Get.context!);
                                         },
                                         leading: Icon(FontAwesomeIcons.image),
                                         title: Text(
                                             'Upload an image', style: Get.textTheme.headline1!.merge(TextStyle(fontSize: 15))),
                                       )
                                     ],
                                   )
                               ),
                               actions: [
                                 TextButton(
                                     onPressed: ()=> Navigator.pop(context),
                                     child: Text('Cancel', style: Get.textTheme.headline4!.merge(TextStyle(color: inactive)),))
                               ],
                             );
                           });
                     },
                     child: Icon(FontAwesomeIcons.circlePlus),
                   )
               ),
             )
           ],
         ),
         ),
        ],
      ),
    );
  }

  Widget buildLoader() {
    return Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }
}
