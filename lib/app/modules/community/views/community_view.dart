import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/community/widgets/buildSelectSector.dart';
import 'package:mapnrank/app/modules/community/widgets/buildSelectZone.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_loading_widget.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/loading_cards.dart';
import 'package:mapnrank/app/modules/global_widgets/post_card_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../services/auth_service.dart';


class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>PostCardWidget(likeWidget: null,));
    return  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: interfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: (){
          controller.noFilter.value = true;
          controller.chooseARegion.value = false;
          controller.chooseADivision.value = false;
          controller.chooseASubDivision.value = false;
          if(controller.post?.sectors != null){
            controller.post?.sectors!.clear();
          }

          Get.toNamed(Routes.CREATE_POST);
        },
            heroTag: null,
            icon: const FaIcon(FontAwesomeIcons.add,),
            label: const Text('Create post')),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshCommunity(showMessage: true);
            controller.onInit();
          },
          child:  Container(
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
                          controller.regionSelectedValue.clear();
                          controller.divisionSelectedValue.clear();
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
                      return controller.loadingPosts.value?
                      const LoadingCardWidget()
                          :controller.allPosts.isNotEmpty?
                      Obx(() => PostCardWidget(
                        //likeTapped: RxBool(controller.allPosts[index].likeTapped),
                        content: controller.allPosts[index].content,
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
                              controller.postSelectedIndex.value = index;

                              if( controller.postFollowed.contains(controller.allPosts[index])){
                                controller.postFollowed.remove(controller.allPosts[index]);
                                controller.postFollowedIndex.value = index;
                                controller.unfollowUser(controller.allPosts[index].postId);
                              }
                              else{
                                controller.postFollowed.add(controller.allPosts[index]);
                                controller.postFollowedIndex.value = index;
                                controller.followUser(controller.allPosts[index].user.userId);
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
                                controller.followUser(controller.allPosts[index].user.userId);
                              }



                            }, child: Text('+ Follow', style: TextStyle(fontSize: 16,  height: 1.4, color: secondaryColor),)):
                        !controller.allPosts[index].isFollowing?
                        GestureDetector(
                            onTap: (){
                              controller.postSelectedIndex.value = index;

                              if( !controller.postFollowed.contains(controller.allPosts[index])){
                                controller.postFollowed.add(controller.allPosts[index]);
                                controller.postFollowedIndex.value = index;
                                controller.followUser(controller.allPosts[index].user.userId);
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

                                               }, child: Row(children: [
                                                 Icon(FontAwesomeIcons.cancel),
                                                 SizedBox(width: 20,),
                                                 Text('Unfollow', style: TextStyle(fontSize: 16, color: Colors.grey.shade900),),
                                               ],)

                                             )
                                             )],
                                         ),
                                       );
                                     },);

                               },
                                child: Icon(FontAwesomeIcons.ellipsisVertical, size: 20,))
                        ,

                        liked: controller.allPosts[index].liked,
                      ).marginOnly(bottom: 5))
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
}
