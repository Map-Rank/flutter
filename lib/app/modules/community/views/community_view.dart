import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/community/widgets/buildSelectSector.dart';
import 'package:mapnrank/app/modules/community/widgets/buildSelectZone.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_loading_widget.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/block_button_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/loading_cards.dart';
import 'package:mapnrank/app/modules/global_widgets/post_card_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../services/auth_service.dart';
import '../../../services/global_services.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../events/controllers/events_controller.dart';


class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>PostCardWidget(likeWidget: null,));
    return  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: interfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: (){
            controller.rating.value =0;
            controller.feedbackController.clear();
            showModalBottomSheet(

              enableDrag: true,
              isScrollControlled: true,
              context: context,
              builder: (context) => Container(
                height: Get.height*0.7,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Text('Send us Your feedback', style: TextStyle(fontSize: 16),).marginOnly(top: 20, bottom: 10),
                    SizedBox(
                      width: Get.width,
                      height: 70,
                      child: TextFormField(
                        controller: controller.feedbackController,
                        maxLines: 80,
                        decoration: InputDecoration(
                            hintText: "Enter your feedback here...",
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),
                          focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),

                        ),
                        onChanged: (value) {
                          controller.feedbackController.text = value;
                        },

                      ),
                    ).marginOnly(bottom: 20),
                    RichText(text: TextSpan(
                      children: [
                        WidgetSpan(child:Text('Input an image', style: TextStyle(fontSize: 16),),),
                        WidgetSpan(child:Text('  (Optional)', style: TextStyle(fontSize: 12, color: Colors.grey),),),

                      ]
                    )).marginOnly(bottom: 20),
                    Row(
                      children: [
                        Obx(() {
                          if(!controller.loadFeedbackImage.value) {
                            return buildLoader();
                          } else {
                            return controller.feedbackImage !=null? ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                controller.feedbackImage,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ):
                            buildLoader();
                          }
                        }
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {

                            await controller.selectCameraOrGalleryFeedbackImage();
                            controller.loadFeedbackImage.value = false;

                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Get.theme.focusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.add_photo_alternate_outlined, size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
                          ),
                        )
                      ],
                    ).marginOnly(bottom: 20, left: 20),
                    Text('Rate us', style: TextStyle(fontSize: 16)).marginOnly(top: 10, bottom: 10),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          return InkWell(
                            onTap: () {
                              controller.rating.value = (index + 1).toInt();
                            },
                            child: index < controller.rating.value
                                ? Icon(Icons.star, size: 50, color: Color(0xFFFFB24D))
                                : Icon(Icons.star_border, size: 50, color: Color(0xFFFFB24D)),
                          );
                        }),
                      );
                    }).marginOnly(bottom: Get.height/10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Get.width,
                          child: BlockButtonWidget(color: interfaceColor,
                              text: Text('Submit', style: TextStyle(color: Colors.white),),
                              onPressed: () async{
                            if(controller.feedbackController.text.isNotEmpty){
                              if(controller.rating.value != 0){
                                await controller.sendFeedback();
                                Navigator.of(context).pop();
                              }
                              else{
                                Get.showSnackbar(Ui.warningSnackBar(message: 'Please rate us'));
                              }

                            }
                            else{
                              Get.showSnackbar(Ui.warningSnackBar(message: 'Please write a feedback'));
                            }

                              } ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: Get.width,
                          decoration:BoxDecoration(
                            border: Border.all(color: interfaceColor),
                            borderRadius: BorderRadius.circular(20),

                          ),
                          //width: Get.width/2,
                          child: MaterialButton(
                            onPressed: (){
                              controller.launchWhatsApp(controller.feedbackController.text);
                            },
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            color: Colors.white,
                            disabledElevation: 0,
                            disabledColor: Get.theme.focusColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Wrap(
                              children: [
                                Icon(FontAwesomeIcons.whatsapp, color: interfaceColor,),
                                SizedBox(width: 10,),
                                Text('Send through Whatsapp')
                              ],
                            ),
                            elevation: 0,
                          ),
                        )


                      ],
                    ),
                  ],
                ),
              ),);

        },
            heroTag: null,
            label: const Text('Contact us')),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshCommunity(showMessage: true);
            controller.onInit();
          },
          child:  Container(
            color: backgroundColor,
            height: Get.height,
            child: Obx(() => CustomScrollView(
              controller: controller.scrollbarController,
              //primary: true,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverAppBar(
                  //expandedHeight: 80,
                  leadingWidth: 0,
                  floating: true,
                  toolbarHeight: 140,
                  leading: Icon(null),
                  centerTitle: true,
                  title: Container(
                    //margin: EdgeInsets.only(bottom: 20),
                    color: Colors.white,
                    child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Scaffold.of(context).openDrawer();
                            },
                            child: Image.asset(
                                "assets/images/logo.png",
                                width: Get.width/6,
                                height: Get.width/6,
                                fit: BoxFit.fitWidth),
                          ),
                          Container(
                           height: 40,
                            width: Get.width/1.6,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10)
                              
                            ),
                            child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:BorderSide.none,),
                              hintText: 'Search subdivision',
                              hintStyle: TextStyle(fontSize: 14),
                              prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.grey, size: 15,)
                            ),
                                                      ),
                          ),
                          ClipOval(
                              child: GestureDetector(
                                onTap: () async {
                                  showDialog(context: context, builder: (context){
                                    return CommentLoadingWidget();
                                  },);
                                  try {
                                    await Get.find<AuthController>().getUser();
                                    await Get.toNamed(Routes.PROFILE);
                                  }catch (e) {
                                    Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
                                  }
                                },
                                child: FadeInImage(
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                  image:  NetworkImage(controller.currentUser.value!.avatarUrl!, headers: GlobalService.getTokenHeaders()),
                                  placeholder: const AssetImage(
                                      "assets/images/loading.gif"),
                                  imageErrorBuilder:
                                      (context, error, stackTrace) {
                                    return Image.asset(
                                        "assets/images/user_admin.png",
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.fitWidth);
                                  },
                                ),
                              )
                          ),
                        ],
                      )
                  ),

                  bottom: PreferredSize(
                    preferredSize: Size(Get.width, 120),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10),
                          //margin:EdgeInsets.all(10),
                          height: 150,
                          decoration: BoxDecoration(
                              color: Colors.white
                            //border: Border(bottom: BorderSide(color: interfaceColor))
                          ),
                          child: Column(
                            children: [
                              SizedBox(
                                width: Get.width,
                                height: 70,
                                child: TextFormField(
                                  maxLines: 80,
                                  decoration: InputDecoration(
                                    hintText: "What's on your mind?",
                                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),
                                    focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),

                                  ),
                                  onChanged: (value) {
                                    controller.postContentController.text = value;
                                  },

                                ),
                              ),
                              SizedBox(height: 10,),
                              Row(
                                children: [
                                  SizedBox(
                                    width: Get.width/2.2,
                                    child: BlockButtonWidget(color: interfaceColor, text: Text('Post',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        onPressed: (){
                                          controller.noFilter.value = true;
                                          controller.chooseARegion.value = false;
                                          controller.chooseADivision.value = false;
                                          controller.chooseASubDivision.value = false;
                                          if(controller.post?.sectors != null){
                                            controller.post?.sectors!.clear();
                                            controller.emptyArrays();
                                          }

                                          Get.toNamed(Routes.CREATE_POST);

                                        }),
                                  ),
                                  Spacer(),
                                  SizedBox(
                                    width: Get.width/2.2,
                                    child: BlockButtonWidget(color: interfaceColor, text: Text('Create Event',
                                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                        onPressed: (){
                                          Get.find<EventsController>().noFilter.value = true;
                                          Get.find<EventsController>().chooseARegion.value = false;
                                          Get.find<EventsController>().chooseADivision.value = false;
                                          Get.find<EventsController>().chooseASubDivision.value = false;

                                          if(Get.find<EventsController>().event?.sectors != null){
                                            Get.find<EventsController>().event?.sectors!.clear();
                                            Get.find<EventsController>().emptyArrays();
                                          }
                                          Get.toNamed(Routes.CREATE_EVENT);

                                        }),
                                  )
                                ],
                              )


                            ],),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: backgroundColor
                            //border: Border(bottom: BorderSide(color: interfaceColor))
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(10, 10, 5, 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: TextButton.icon(
                                    icon: Icon(Icons.filter_list_rounded, color: interfaceColor) ,
                                    label: Text('Filter by zone', style: TextStyle(color: interfaceColor),),
                                    onPressed: () {

                                      controller.noFilter.value = false;

                                      showModalBottomSheet(
                                        //isScrollControlled: true,
                                        context: context,

                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                        builder: (context) {
                                          return Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: const BoxDecoration(
                                                  color: backgroundColor,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))

                                              ),
                                              child: BuildSelectZone()
                                          );
                                        },
                                      );

                                    },),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 10, 10, 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: TextButton.icon(
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
                                              child: BuildSelectSector()
                                          );
                                        },
                                      );

                                    },),
                                ),
                              ),


                            ],),
                        ),
                      ],
                    )

                  ),

                ),


                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return controller.loadingPosts.value?
                      const LoadingCardWidget()
                          :controller.allPosts.isNotEmpty?
                      Obx(() => PostCardWidget(
                        //likeTapped: RxBool(controller.allPosts[index].likeTapped),
                        content: controller.allPosts[index].content == false?'':controller.allPosts[index].content,
                        zone: controller.allPosts[index].zone != null?controller.allPosts[index].zone['name']: '',
                        publishedDate: controller.allPosts[index].publishedDate,
                        postId: controller.allPosts[index].postId,
                        commentCount: controller.allPosts[index].commentCount,
                        likeCount: RxInt(controller.selectedPost.contains(controller.allPosts[index])&& controller.postSelectedIndex.value == index &&controller.allPosts[index].likeTapped ?
                        controller.allPosts[index].likeCount-1:
                        controller.selectedPost.contains(controller.allPosts[index])&& controller.postSelectedIndex.value == index && !controller.allPosts[index].likeTapped ?
                        controller.allPosts[index].likeCount+1:
                        controller.allPosts[index].likeCount,),
                        shareCount:  RxInt(controller.sharedPost.contains(controller.allPosts[index])&& controller.postSharedIndex.value == index?
                          controller.sharedPost.where((element) => element.postId == controller.allPosts[index].postId).toList().length + controller.allPosts[index].shareCount:
                        controller.allPosts[index].shareCount),
                        images: controller.allPosts[index].imagesUrl,
                        user: UserModel(
                            firstName: controller.allPosts[index].user.firstName,
                            lastName: controller.allPosts[index].user.lastName,
                            avatarUrl: controller.allPosts[index].user.avatarUrl
                        ),
                        followWidget: Obx(() =>controller.postFollowed.contains(controller.allPosts[index])&& controller.postFollowedIndex.value == index &&controller.allPosts[index].isFollowing?
                        GestureDetector(
                            onTap: (){
                              if( !controller.postFollowed.contains(controller.allPosts[index])){
                                controller.postFollowed.add(controller.allPosts[index]);
                                controller.postFollowedIndex.value = index;
                                controller.followUser(controller.allPosts[index].user.userId,controller.allPosts[index].postId );
                              }



                            },
                            child: Text('+ Follow',style: TextStyle(fontSize: 16,  height: 1.4, color: secondaryColor),)):
                        controller.postFollowed.contains(controller.allPosts[index])&& controller.postFollowedIndex.value == index  &&!controller.allPosts[index].isFollowing?
                        Text('Following', style: TextStyle(fontSize: 16,  height: 1.4, color: secondaryColor),):
                        !controller.postFollowed.contains(controller.allPosts[index]) && !controller.allPosts[index].isFollowing?
                        GestureDetector(
                            onTap: (){
                              controller.postSelectedIndex.value = index;

                              if( !controller.postFollowed.contains(controller.allPosts[index])){
                                controller.postFollowed.add(controller.allPosts[index]);
                                controller.postFollowedIndex.value = index;
                                controller.followUser(controller.allPosts[index].user.userId, controller.allPosts[index].postId );
                              }



                            }, child: Text('+ Follow', style: TextStyle(fontSize: 16,  height: 1.4, color: secondaryColor),)):
                        !controller.allPosts[index].isFollowing?
                        GestureDetector(
                            onTap: (){
                              controller.postSelectedIndex.value = index;

                              if( !controller.postFollowed.contains(controller.allPosts[index])){
                                controller.postFollowed.add(controller.allPosts[index]);
                                controller.postFollowedIndex.value = index;
                                controller.followUser(controller.allPosts[index].user.userId, controller.allPosts[index].postId );
                              }



                            }, child: Text('+ Follow',style: TextStyle(fontSize: 16,  height: 1.4, color: secondaryColor), )):
                        Text('Following', style: TextStyle(fontSize: 16,  height: 1.4, color: secondaryColor),),
                        ),
                        likeWidget:  Obx(() =>
                        controller.selectedPost.contains(controller.allPosts[index])&& controller.postSelectedIndex.value == index &&controller.allPosts[index].likeTapped?
                        const FaIcon(FontAwesomeIcons.heart,):
                        controller.selectedPost.contains(controller.allPosts[index])&& controller.postSelectedIndex.value == index  &&!controller.allPosts[index].likeTapped?
                        const FaIcon(FontAwesomeIcons.solidHeart, color: interfaceColor,):
                        !controller.allPosts[index].likeTapped?
                        const FaIcon(FontAwesomeIcons.heart,):
                        const FaIcon(FontAwesomeIcons.solidHeart, color: interfaceColor,)


                          ,),


                        onLikeTapped: (){
                          controller.postSelectedIndex.value = index;

                          if( controller.selectedPost.contains(controller.allPosts[index])){
                            controller.selectedPost.remove(controller.allPosts[index]);
                            controller.postSelectedIndex.value = index;
                            controller.likeUnlikePost(controller.allPosts[index].postId);
                          }
                          else{
                            controller.selectedPost.add(controller.allPosts[index]);
                            controller.postSelectedIndex.value = index;
                            controller.likeUnlikePost(controller.allPosts[index].postId);
                          }

                        },
                        onCommentTapped: () async{
                          showDialog(context: context, builder: (context){
                            return CommentLoadingWidget();
                          },);

                          controller.postDetails = await controller.getAPost(controller.allPosts[index].postId);
                          controller.commentList.value = controller.postDetails.commentList!;
                          controller.commentCount!.value =controller.postDetails.commentCount!;
                          controller.likeCount?.value = controller.postDetails.likeCount!;
                          controller.shareCount?.value =controller.postDetails.shareCount!;
                              Navigator.of(context).pop();
                          Get.toNamed(Routes.COMMENT_VIEW,arguments: {'post': controller.allPosts[index]} );

                        },
                        onPictureTapped: () async{
                          controller.postDetails = controller.allPosts[index];
                          controller.likeCount?.value = controller.postDetails.likeCount!;
                          controller.shareCount?.value =controller.postDetails.shareCount!;
                          print(controller.postDetails.postId);
                          Get.toNamed(Routes.DETAILS_VIEW, arguments: {'post': controller.allPosts[index]} );

                        },
                        onSharedTapped: ()async{
                          controller.postSharedIndex.value = index;
                            controller.sharedPost.add(controller.allPosts[index]);
                            await controller.sharePost(controller.allPosts[index].postId);


                        },
                        popUpWidget:
                            GestureDetector(
                               onTap: (){
                                     showModalBottomSheet(context: context, builder: (context) {
                                       return controller.allPosts[index].user.userId == controller.currentUser.value.userId?
                                         Container(
                                           height: Get.height/3,
                                         child: ListView(
                                           padding: EdgeInsets.all(20),
                                           children: [
                                             GestureDetector(onTap: () async{
                                               showDialog(context: context, builder: (context){
                                                 return CommentLoadingWidget();
                                               },);
                                               await controller.deletePost(controller.allPosts[index].postId);
                                               Navigator.of(context).pop();
                                             }, child: Row(children: [
                                               Icon(FontAwesomeIcons.trashCan),
                                               SizedBox(width: 20,),
                                               Text('Delete', style: TextStyle(fontSize: 16, color: Colors.grey.shade900),),
                                             ],)).marginSymmetric(vertical: 10, ),

                                             GestureDetector(onTap: () async{
                                               showDialog(context: context, builder: (context){
                                                 return CommentLoadingWidget();
                                               },);
                                               controller.createUpdatePosts.value = true;
                                               controller.post = await controller.getAPost(controller.allPosts[index].postId);

                                               controller.postContentController.text = controller.post.content!;

                                               for(int i = 0; i <controller.post.sectors!.length; i++) {

                                                 controller.sectorsSelected.add(controller.sectors.where((element) => element['id'] == controller.post.sectors![i]['id']).toList()[0]);
                                               }
                                               print('sectors selected : ${controller.sectorsSelected}');

                                               if(controller.post.zoneLevelId == '2'){
                                                 controller.divisionsSet = await controller.zoneRepository.getAllDivisions(3, controller.post.zonePostId);
                                                 controller.listDivisions.value =  controller.divisionsSet['data'];
                                                 controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                                 controller.divisions.value =  controller.listDivisions;
                                                 controller.regionSelectedValue.add(controller.regions.where((element) => element['id'] == controller.post.zonePostId).toList()[0]);

                                               }
                                               else if(controller.post.zoneLevelId == '3'){

                                                 controller.divisionsSet = await controller.zoneRepository.getAllDivisions(3, int.parse(controller.post.zoneParentId));
                                                 controller.listDivisions.value =  controller.divisionsSet['data'];
                                                 controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                                 controller.divisions.value =  controller.listDivisions;
                                                 controller.regionSelectedValue.add(controller.regions.where((element) => element['id'].toString() == controller.post.zoneParentId).toList()[0]);
                                                 //controller.regionSelectedValue.add(controller.regions.where((element) => element['id'] == controller.post.zonePostId).toList()[0]);
                                                 print('Divisions : ${controller.divisions}');
                                                 print('Divisions : ${controller.post.zonePostId}');

                                                 controller.subdivisionsSet = await controller.zoneRepository.getAllSubdivisions(4, controller.post.zonePostId);
                                                 controller.listSubdivisions.value =  controller.subdivisionsSet['data'];
                                                 controller.loadingSubdivisions.value = ! controller.subdivisionsSet['status'];
                                                 controller.subdivisions.value =  controller.listSubdivisions;
                                                 controller.divisionSelectedValue.add(controller.divisions.where((element) => element['id'] == controller.post.zonePostId).toList()[0]);
                                               }
                                               else if(controller.post.zoneLevelId == '4'){
                                                 var region = await controller.getSpecificZone(int.parse(controller.post.zoneParentId));
                                                 print(region);

                                                 controller.divisionsSet = await controller.zoneRepository.getAllDivisions(3, int.parse(region['parent_id']));
                                                 controller.listDivisions.value =  controller.divisionsSet['data'];
                                                 controller.loadingDivisions.value = ! controller.divisionsSet['status'];
                                                 controller.divisions.value =  controller.listDivisions;

                                                 controller.subdivisionsSet = await controller.zoneRepository.getAllSubdivisions(4, int.parse(controller.post.zoneParentId));
                                                 controller.listSubdivisions.value =  controller.subdivisionsSet['data'];
                                                 controller.loadingSubdivisions.value = ! controller.subdivisionsSet['status'];
                                                 controller.subdivisions.value =  controller.listSubdivisions;
                                                 controller.divisionSelectedValue.add(controller.divisions.where((element) => element['id'] == int.parse(controller.post.zoneParentId)).toList()[0]);

                                                 print(controller.divisionSelectedValue);


                                                 controller.regionSelectedValue.add(controller.regions.where((element) => element['id'].toString() == controller.divisionSelectedValue[0]['parent_id']).toList()[0]);

                                                 controller.subdivisionSelectedValue.add(controller.subdivisions.where((element) => element['id'] == controller.post.zonePostId).toList()[0]);
                                               }


                                               Navigator.of(context).pop();
                                               controller.noFilter.value = true;
                                               Get.toNamed(Routes.CREATE_POST);
                                             }, child: Row(
                                               mainAxisAlignment: MainAxisAlignment.start,
                                               children: [
                                               Icon(FontAwesomeIcons.edit),
                                               SizedBox(width: 20,),
                                               Text('Edit', style: TextStyle(fontSize: 16, color: Colors.grey.shade900),),
                                             ],))
                                           ],

                                         ),
                                       ):
                                       Container(
                                         height: Get.height/3,
                                         child: ListView(
                                           padding: EdgeInsets.all(20),
                                           children: [
                                             Align(
                                               alignment: Alignment.centerLeft,
                                               child: GestureDetector(onTap: (){
                                                 controller.postSelectedIndex.value = index;

                                                 if(controller.postFollowed.contains(controller.allPosts[index])){
                                                   controller.postFollowed.remove(controller.allPosts[index]);
                                                   controller.postFollowedIndex.value = index;
                                                   controller.unfollowUser(controller.allPosts[index].user.userId);
                                                 }
                                                 else{
                                                   controller.postFollowedIndex.value = index;
                                                   controller.unfollowUser(controller.allPosts[index].user.userId);
                                                 }

                                               }, child:  controller.allPosts[index].isFollowing || controller.postFollowed.contains(controller.allPosts[index])?
                                               Row(children: [
                                                 Icon(FontAwesomeIcons.cancel),
                                                 SizedBox(width: 20,),
                                                 Text('Unfollow', style: TextStyle(fontSize: 16, color: Colors.grey.shade900),),
                                               ],):Text('No actions to perform', style: TextStyle(fontSize: 16, color: Colors.grey.shade900),),


                                             )
                                             )],
                                         ),
                                       );
                                     },);

                               },
                                child: Icon(FontAwesomeIcons.ellipsisVertical, size: 20,))
                        ,

                        liked: controller.allPosts[index].liked,
                      ))
                          :Center(
                        child: SizedBox(
                          height: Get.height/2,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              FaIcon(FontAwesomeIcons.folderOpen, size: 30,),
                              Text('No posts found')
                            ],
                          ),
                        ),

                      );
                    },
                        childCount: controller.allPosts.length
                    )),

                SliverList(
                    delegate: SliverChildListDelegate([
                       !controller.loadingPosts.value?
                       controller.allPosts.isEmpty?
                    Center(
                    child: SizedBox(
                    //height: Get.height/2,
                    child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      SizedBox(height: Get.height/4),
                    FaIcon(FontAwesomeIcons.folderOpen, size: 30,),
                  Text('No posts found')
                  ],
                ),
            ),

          ):controller.page >0?
                       Center(
                        child: CircularProgressIndicator(color: interfaceColor, ),
                      ):SizedBox(): LoadingCardWidget()

                    ]))


              ],

            )),
          ),

        ),

      ),


    );

  }

  Widget buildLoader() {
    return SizedBox(
        width: 100,
        height: 100,
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image.asset(
            'assets/images/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }

}
