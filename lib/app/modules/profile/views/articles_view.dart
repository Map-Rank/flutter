import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/profile/controllers/profile_controller.dart';
import 'package:mapnrank/common/helper.dart';

import '../../../../color_constants.dart';
import '../../../models/user_model.dart';
import '../../../routes/app_routes.dart';
import '../../community/widgets/comment_loading_widget.dart';
import '../../global_widgets/loading_cards.dart';
import '../../global_widgets/post_card_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ArticlesView extends GetView<ProfileController> {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
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
        AppLocalizations.of(context).posts_count,
        style: TextStyle(color: Colors.black87, fontSize: 30.0),
      ),
    ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        //padding: const EdgeInsets.all(24.0),
        child: Obx(() => Get.find<CommunityController>().allPosts.isNotEmpty? ListView.builder(
          itemCount: Get.find<CommunityController>().allPosts.length,
            itemBuilder: (context, index) =>
            Obx(() => PostCardWidget(
              //likeTapped: RxBool(controller.allPosts[index].likeTapped),
              content: Get.find<CommunityController>().allPosts[index].content == false?'':Get.find<CommunityController>().allPosts[index].content,
              zone: Get.find<CommunityController>().allPosts[index].zone != null?Get.find<CommunityController>().allPosts[index].zone['name']: '',
              publishedDate: Get.find<CommunityController>().allPosts[index].publishedDate,
              postId: Get.find<CommunityController>().allPosts[index].postId,
              commentCount: Get.find<CommunityController>().allPosts[index].commentCount,
              shareCount:  RxInt(Get.find<CommunityController>().sharedPost.contains(Get.find<CommunityController>().allPosts[index])&& Get.find<CommunityController>().postSharedIndex.value == index?
              Get.find<CommunityController>().sharedPost.where((element) => element.postId == Get.find<CommunityController>().allPosts[index].postId).toList().length + Get.find<CommunityController>().allPosts[index].shareCount:
              Get.find<CommunityController>().allPosts[index].shareCount),
              images: Get.find<CommunityController>().allPosts[index].imagesUrl,
              isCommunityPage: false,
              user: UserModel(
                  firstName: controller.currentUser.value.firstName,
                  lastName: controller.currentUser.value.lastName,
                  avatarUrl: controller.currentUser.value.avatarUrl
              ),
              followWidget: SizedBox(),
              likeCount: RxInt(Get.find<CommunityController>().allPosts[index].likeTapped.value && Get.find<CommunityController>().postSelectedIndex.value == index ?
              ++Get.find<CommunityController>().allPosts[index].likeCount:
              !Get.find<CommunityController>().allPosts[index].likeTapped.value  && Get.find<CommunityController>().postSelectedIndex.value == index?
              --Get.find<CommunityController>().allPosts[index].likeCount:
              Get.find<CommunityController>().allPosts[index].likeCount,),

              likeWidget:  Obx(() =>
              Get.find<CommunityController>().allPosts[index].likeTapped.value && Get.find<CommunityController>().postSelectedIndex.value == index?
              const FaIcon(FontAwesomeIcons.solidHeart, color: interfaceColor,):
              !Get.find<CommunityController>().allPosts[index].likeTapped.value  && Get.find<CommunityController>().postSelectedIndex.value == index?
              const FaIcon(FontAwesomeIcons.heart,):
              Get.find<CommunityController>().allPosts[index].likeTapped.value ?
              const FaIcon(FontAwesomeIcons.solidHeart, color: interfaceColor,):
              const FaIcon(FontAwesomeIcons.heart,)

                ,),
              onLikeTapped: (){
                Get.find<CommunityController>().postSelectedIndex.value = index.toDouble();

                if(Get.find<CommunityController>().allPosts[index].likeTapped.value){
                  Get.find<CommunityController>().allPosts[index].likeTapped.value = !Get.find<CommunityController>().allPosts[index].likeTapped.value;
                  Get.find<CommunityController>().likeUnlikePost(Get.find<CommunityController>().allPosts[index].postId, index);
                }
                else{
                  Get.find<CommunityController>().allPosts[index].likeTapped.value = !Get.find<CommunityController>().allPosts[index].likeTapped.value;
                  Get.find<CommunityController>().likeUnlikePost(Get.find<CommunityController>().allPosts[index].postId, index);
                }


              },
              onCommentTapped: () async{

                Get.find<CommunityController>().likeTapped.value = false;
                Get.toNamed(Routes.COMMENT_VIEW,arguments: {'post': Get.find<CommunityController>().allPosts[index]} );

               await Get.find<CommunityController>().getAPost(Get.find<CommunityController>().allPosts[index].postId);
                Get.find<CommunityController>().likeCount!.value = Get.find<CommunityController>().allPosts.where((element)=>element.postId == Get.find<CommunityController>().postDetails.value.postId).toList()[0].likeCount;
                Get.find<CommunityController>().commentList.value = Get.find<CommunityController>().postDetails.value.commentList!;
                Get.find<CommunityController>().commentCount!.value =Get.find<CommunityController>().postDetails.value.commentCount!;
                Get.find<CommunityController>().likeCount?.value = Get.find<CommunityController>().postDetails.value.likeCount!;
                Get.find<CommunityController>().shareCount?.value =Get.find<CommunityController>().postDetails.value.shareCount!;

              },
              onPictureTapped: () async{
                var post = Get.find<CommunityController>().allPosts[index];
                post.user = controller.currentUser.value;
                await Get.find<CommunityController>().initializePostDetails(post);
                Get.find<CommunityController>().likeCount?.value = Get.find<CommunityController>().postDetails.value.likeCount!;
                Get.find<CommunityController>().shareCount?.value =Get.find<CommunityController>().postDetails.value.shareCount!;
                Get.toNamed(Routes.DETAILS_VIEW, arguments: {'post': Get.find<CommunityController>().allPosts[index]} );

              },
              onSharedTapped: ()async{
                Get.find<CommunityController>().postSharedIndex.value = index;
                Get.find<CommunityController>().sharedPost.add(Get.find<CommunityController>().allPosts[index]);
                await Get.find<CommunityController>().sharePost(Get.find<CommunityController>().allPosts[index].postId);


              },
              popUpWidget:
              GestureDetector(
                  onTap: (){
                    Get.find<CommunityController>().selectedIndex.value = index;
                    showModalBottomSheet(context: context, builder: (context) {
                      return
                        Container(
                          height: Get.height/3,
                          child: ListView(
                            padding: EdgeInsets.all(20),
                            children: [
                              GestureDetector(onTap: () async{
                                showDialog(context: context, builder: (context){
                                  return CommentLoadingWidget();
                                },);
                                await Get.find<CommunityController>().deletePost(Get.find<CommunityController>().allPosts[index].postId);
                                Navigator.of(context).pop();
                              }, child: Row(children: [
                                Icon(FontAwesomeIcons.trashCan),
                                SizedBox(width: 20,),
                                Text(AppLocalizations.of(context).delete, style: TextStyle(fontSize: 16, color: Colors.grey.shade900),),
                              ],)).marginSymmetric(vertical: 10, ),

                              GestureDetector(onTap: () async{
                                showDialog(context: context, builder: (context){
                                  return CommentLoadingWidget();
                                },);
                                Get.find<CommunityController>().createUpdatePosts.value = true;
                                Get.find<CommunityController>().post = await Get.find<CommunityController>().getAPost(Get.find<CommunityController>().allPosts[index].postId);

                                Get.find<CommunityController>().postContentController.text = Get.find<CommunityController>().post.content!;

                                for(int i = 0; i <Get.find<CommunityController>().post.sectors!.length; i++) {

                                  Get.find<CommunityController>().sectorsSelected.add(Get.find<CommunityController>().sectors.where((element) => element['id'] == Get.find<CommunityController>().post.sectors![i]['id']).toList()[0]);
                                }
                                print('sectors selected : ${Get.find<CommunityController>().sectorsSelected}');

                                if(Get.find<CommunityController>().post.zoneLevelId == '2'){
                                  Get.find<CommunityController>().divisionsSet = await Get.find<CommunityController>().zoneRepository.getAllDivisions(3, Get.find<CommunityController>().post.zonePostId);
                                  Get.find<CommunityController>().listDivisions.value =  Get.find<CommunityController>().divisionsSet['data'];
                                  Get.find<CommunityController>().loadingDivisions.value = ! Get.find<CommunityController>().divisionsSet['status'];
                                  Get.find<CommunityController>().divisions.value =  Get.find<CommunityController>().listDivisions;
                                  Get.find<CommunityController>().regionSelectedValue.add(Get.find<CommunityController>().regions.where((element) => element['id'] == Get.find<CommunityController>().post.zonePostId).toList()[0]);

                                }
                                else if(Get.find<CommunityController>().post.zoneLevelId == '3'){

                                  Get.find<CommunityController>().divisionsSet = await Get.find<CommunityController>().zoneRepository.getAllDivisions(3, int.parse(Get.find<CommunityController>().post.zoneParentId));
                                  Get.find<CommunityController>().listDivisions.value =  Get.find<CommunityController>().divisionsSet['data'];
                                  Get.find<CommunityController>().loadingDivisions.value = ! Get.find<CommunityController>().divisionsSet['status'];
                                  Get.find<CommunityController>().divisions.value =  Get.find<CommunityController>().listDivisions;
                                  Get.find<CommunityController>().regionSelectedValue.add(Get.find<CommunityController>().regions.where((element) => element['id'].toString() == Get.find<CommunityController>().post.zoneParentId).toList()[0]);

                                  Get.find<CommunityController>().subdivisionsSet = await Get.find<CommunityController>().zoneRepository.getAllSubdivisions(4, Get.find<CommunityController>().post.zonePostId);
                                  Get.find<CommunityController>().listSubdivisions.value =  Get.find<CommunityController>().subdivisionsSet['data'];
                                  Get.find<CommunityController>().loadingSubdivisions.value = ! Get.find<CommunityController>().subdivisionsSet['status'];
                                  Get.find<CommunityController>().subdivisions.value =  Get.find<CommunityController>().listSubdivisions;
                                  Get.find<CommunityController>().divisionSelectedValue.add(Get.find<CommunityController>().divisions.where((element) => element['id'] == Get.find<CommunityController>().post.zonePostId).toList()[0]);
                                }
                                else if(Get.find<CommunityController>().post.zoneLevelId == '4'){
                                  var region = await Get.find<CommunityController>().getSpecificZone(int.parse(Get.find<CommunityController>().post.zoneParentId));
                                  print(region);

                                  Get.find<CommunityController>().divisionsSet = await Get.find<CommunityController>().zoneRepository.getAllDivisions(3, int.parse(region['parent_id']));
                                  Get.find<CommunityController>().listDivisions.value =  Get.find<CommunityController>().divisionsSet['data'];
                                  Get.find<CommunityController>().loadingDivisions.value = ! Get.find<CommunityController>().divisionsSet['status'];
                                  Get.find<CommunityController>().divisions.value =  Get.find<CommunityController>().listDivisions;

                                  Get.find<CommunityController>().subdivisionsSet = await Get.find<CommunityController>().zoneRepository.getAllSubdivisions(4, int.parse(Get.find<CommunityController>().post.zoneParentId));
                                  Get.find<CommunityController>().listSubdivisions.value =  Get.find<CommunityController>().subdivisionsSet['data'];
                                  Get.find<CommunityController>().loadingSubdivisions.value = ! Get.find<CommunityController>().subdivisionsSet['status'];
                                  Get.find<CommunityController>().subdivisions.value =  Get.find<CommunityController>().listSubdivisions;
                                  Get.find<CommunityController>().divisionSelectedValue.add(Get.find<CommunityController>().divisions.where((element) => element['id'] == int.parse(Get.find<CommunityController>().post.zoneParentId)).toList()[0]);

                                  Get.find<CommunityController>().regionSelectedValue.add(Get.find<CommunityController>().regions.where((element) => element['id'].toString() == Get.find<CommunityController>().divisionSelectedValue[0]['parent_id']).toList()[0]);

                                  Get.find<CommunityController>().subdivisionSelectedValue.add(Get.find<CommunityController>().subdivisions.where((element) => element['id'] == Get.find<CommunityController>().post.zonePostId).toList()[0]);
                                }


                                Navigator.of(context).pop();
                                Get.find<CommunityController>().noFilter.value = true;
                                Get.toNamed(Routes.CREATE_POST);
                              }, child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(FontAwesomeIcons.edit),
                                  SizedBox(width: 20,),
                                  Text(AppLocalizations.of(context).edit, style: TextStyle(fontSize: 16, color: Colors.grey.shade900),),
                                ],))
                            ],

                          ),
                        );
                    },);

                  },
                  child: Icon(FontAwesomeIcons.ellipsisVertical, size: 20,)),

              liked: Get.find<CommunityController>().allPosts[index].liked,
            ))
        ):Center(
          child: SizedBox(
            height: Get.height/4,
            child: Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.folderOpen, size: 30,),
                Text(AppLocalizations.of(context).no_posts_found)
              ],
            ),
          ),

        ),)
      ),
    );
  }
}