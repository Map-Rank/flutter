import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/events/controllers/events_controller.dart';
import 'package:mapnrank/app/modules/events/widgets/buildSelectSector.dart';
import 'package:mapnrank/app/modules/events/widgets/buildSelectZone.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:mapnrank/app/services/global_services.dart';
import '../../../../color_constants.dart';

class CreateEventView extends GetView<EventsController> {
  const CreateEventView({super.key});


  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>CommunityController());
    return Scaffold(
        backgroundColor: backgroundColor,
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,

          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: interfaceColor),
            onPressed: () => {
              Navigator.pop(context),
              //Get.back()
            },
          ),
          actions: [
            Center(
                child: InkWell(
                    onTap: () async{
                      controller.createEvents.value = !controller.createEvents.value;
                      //controller.createEvents.value = !controller.createEvents.value;
                      !controller.createUpdateEvents.value?
                      controller.createEvents.value?
                      await controller.createEvent(controller.event!):(){}
                          :controller.updateEvents.value?
                      await controller.updateEvent(controller.event!):(){};
                      Navigator.pop(context);
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: interfaceColor,
                        ),

                        width: Get.width/3.5,
                        height: 40,
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        child: Center(
                            child: Obx(() =>  !controller.createUpdateEvents.value?!controller.createEvents.value ?
                            Text('Create', style: Get.textTheme.bodyText2!.merge(const TextStyle(color: Colors.white)))
                                : const SizedBox(height: 20,
                                child: SpinKitThreeBounce(color: Colors.white, size: 20)):
                            !controller.updateEvents.value?
                            Text('Update', style: Get.textTheme.bodyText2!.merge(const TextStyle(color: Colors.white)))
                                : const SizedBox(height: 20,
                                child: SpinKitThreeBounce(color: Colors.white, size: 20))

                            )
                        )
                    )
                )
            )
          ],
        ),
        bottomSheet: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),

            TextButton.icon(
                icon: FaIcon(FontAwesomeIcons.add, color: interfaceColor, size: 15,),
                onPressed: (){
                  controller.inputSector.value = !controller.inputSector.value;
                }, label: Text('Add sector', style: TextStyle(color: interfaceColor),)),
            TextButton.icon(
                icon: FaIcon(FontAwesomeIcons.add, color: interfaceColor, size: 15),
                onPressed: (){
                  controller.inputZone.value = !controller.inputZone.value;
                }, label: Text('Add zone', style: TextStyle(color: interfaceColor,),)),
            //buildInputImages(context),

          ],
        ).marginAll(20),
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
              decoration: const BoxDecoration(color: backgroundColor,),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child:  ListView(
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        buildInputImages(context),
                        Text('Event Title'),
                        Card(
                            elevation: 0,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: Get.height*0.05,
                                  child: TextFormField(
                                    initialValue: !controller.createUpdateEvents.value?'':controller.event.title,
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                    cursorColor: Colors.black,
                                    textInputAction:TextInputAction.done ,
                                    maxLines: 4,
                                    minLines: 2,
                                    onChanged: (input) => controller.event!.title = input,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //label: Text(AppLocalizations.of(context).description),
                                      fillColor: Palette.background,
                                      enabledBorder: InputBorder.none,
                                      //filled: true,
                                      prefixIcon: const Icon(Icons.description),
                                      hintText: 'Enter Event title ',
                                      //hintStyle: TextStyle(fontSize: 28, color: Colors.grey.shade400)
                                    ),

                                  ),
                                )
                            )
                        )
                      ]
                  ).marginOnly(top: 20, bottom: 5),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Enter Event Description'),
                        Card(
                            elevation: 0,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: SizedBox(
                                  height: Get.height*0.15,
                                  child: TextFormField(
                                    initialValue: !controller.createUpdateEvents.value?'':controller.event.content,
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                                    cursorColor: Colors.black,
                                    textInputAction:TextInputAction.done ,
                                    maxLines: 20,
                                    minLines: 2,
                                    onChanged: (input) => controller.event!.content = input,
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      //label: Text(AppLocalizations.of(context).description),
                                      fillColor: Palette.background,
                                      enabledBorder: InputBorder.none,
                                      //filled: true,
                                      prefixIcon: const Icon(Icons.description),
                                      hintText: 'Event Description ',
                                      //hintStyle: TextStyle(fontSize: 28, color: Colors.grey.shade400)
                                    ),

                                  ),
                                )
                            )
                        )
                      ]
                  ).marginOnly(top: 20, bottom: 5),

                  TextFieldWidget(
                    readOnly: false,
                    labelText: 'Location',
                    hintText: "yaounde",
                    initialValue: !controller.createUpdateEvents.value?'':controller.event.zone,
                    keyboardType: TextInputType.text,
                    onChanged: (value) => {
                      controller.event.zone = value
                    },
                    iconData: FontAwesomeIcons.locationDot,
                    key: null, errorText: '', suffixIcon: const Icon(null), suffix: Icon(null),
                  ),

                  TextFieldWidget(
                    readOnly: false,
                    labelText: 'Organized by',
                    hintText: "Map & Rank",
                    initialValue: !controller.createUpdateEvents.value?'':controller.event.organizer,
                    keyboardType: TextInputType.text,
                    onChanged: (value) => {
                      controller.event.organizer = value
                    },
                    iconData: FontAwesomeIcons.locationDot,
                    key: null, errorText: '', suffixIcon: const Icon(null), suffix: Icon(null),
                  ),

                  InkWell(
                      onTap: ()=>{ controller.startingDatePicker() },
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                        margin:const  EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius:const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                            ],
                            border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Starting Date'.tr, style: const TextStyle(color: labelColor)
                            ),
                            Obx(() =>
                                ListTile(
                                    leading: const Icon(Icons.calendar_today),
                                    title: Text(controller.startingDateDisplay.value,
                                      style: Get.textTheme.headline1?.merge(const TextStyle(color: Colors.black, fontSize: 16)),
                                    )
                                ))
                          ],
                        ),
                      )
                  ),

                  InkWell(
                      onTap: ()=>{ controller.endingDatePicker() },
                      child: Container(
                        padding: const EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                        margin:const  EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
                        decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius:const BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Get.theme.focusColor.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5)),
                            ],
                            border: Border.all(color: Get.theme.focusColor.withOpacity(0.05))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Ending Date'.tr, style: const TextStyle(color: labelColor)
                            ),
                            Obx(() =>
                                ListTile(
                                    leading: const Icon(Icons.calendar_today),
                                    title: Text(controller.endingDateDisplay.value,
                                      style: Get.textTheme.headline1?.merge(const TextStyle(color: Colors.black, fontSize: 16)),
                                    )
                                ))
                          ],
                        ),
                      )
                  ),



                  Obx(() => Visibility(
                    visible: controller.inputSector.value,
                    child: BuildSelectSector(),)),
                  Obx(() => Visibility(
                    visible: controller.inputZone.value,
                    child: BuildSelectZone(),))






                ],
              ).paddingOnly(bottom: 80)
          ),
        )
    );
  }



  Widget buildInputImages(BuildContext context){
    return Container(
      decoration: const BoxDecoration(
        color: backgroundColor,
      ),
      //padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Obx(() =>
          controller.createUpdateEvents.value?
          SizedBox(
            height: Get.height/4,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: controller.event.imagesUrl?.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  //onTap: onPictureTapped,
                  child: FadeInImage(
                    width: Get.width-50,
                    height: Get.height/4,
                    fit: BoxFit.cover,
                    image:  NetworkImage('${GlobalService().baseUrl}'
                        '${controller.event.imagesUrl![index].substring(1,controller.event.imagesUrl![index].length)}',
                        headers: GlobalService.getTokenHeaders()
                    ),
                    placeholder: const AssetImage(
                        "assets/images/loading.gif"),
                    imageErrorBuilder:
                        (context, error, stackTrace) {
                      return Image.asset(
                          "assets/images/loading.gif",
                          width: Get.width,
                          height: Get.height/4,
                          fit: BoxFit.fitWidth);
                    },
                  ).marginOnly(right: 10),
                );

              },
            ),
          )
              :SizedBox()

          ),
          Obx(() => Stack(children: [
            controller.imageFiles.length <= 0 ?Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                width: double.infinity,
                height: 140,
                child: Image.asset(
                  'assets/images/loading.gif',
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
            ):
            Obx(() => ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: Image.file(
                controller.imageFiles[0],
                fit: BoxFit.cover,
                width: double.infinity,
                height: 140,
              ),
            ),),
            Positioned(
                right: 20,
                top: 10,
                child: GestureDetector(
                    onTap: (){
                      controller.imageFiles.clear();
                      showDialog(
                          context: Get.context!,
                          builder: (_){
                            return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              content: Container(
                                  height: 140,
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                      children: [
                                        ListTile(
                                          onTap: ()async{
                                            await controller.pickImage(ImageSource.camera);
                                            Navigator.pop(Get.context!);
                                          },
                                          leading: const Icon(FontAwesomeIcons.camera),
                                          title: Text('Take a picture', style: Get.textTheme.headline1!.merge(const TextStyle(fontSize: 15))),
                                        ),
                                        ListTile(
                                          onTap: ()async{
                                            await controller.pickImage(ImageSource.gallery);
                                            Navigator.pop(Get.context!);
                                          },
                                          leading: const Icon(FontAwesomeIcons.image),
                                          title: Text('Upload an image', style: Get.textTheme.headline1!.merge(const TextStyle(fontSize: 15))),
                                        )
                                      ]
                                  )
                              ),
                              actions: [
                                TextButton(
                                    onPressed: ()=> Navigator.pop(context),
                                    child: Text('Cancel', style: Get.textTheme.headline4!.merge(const TextStyle(color: inactive)),))
                              ],
                            );
                          });

                    },
                    child: FaIcon(FontAwesomeIcons.edit))),
            controller.imageFiles.length <= 0 ?Align(
              alignment: Alignment.bottomCenter,
              child: Text('Upload Event Banner'),
            ).paddingOnly(top: 20):SizedBox()

          ]),),

        ],
      ),
    );
  }

  Widget buildLoader() {
    return Container(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }
}
