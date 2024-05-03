import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/loading_cards.dart';
import 'package:mapnrank/app/modules/global_widgets/post_card_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/search_community_widget.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';


class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>PostCardWidget());
    return  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: secondaryColor,
        floatingActionButton: Obx(() => !controller.floatingActionButtonTapped.value?
        FloatingActionButton(
            child: const FaIcon(FontAwesomeIcons.add),
            heroTag: null,
            onPressed: (){
              controller.floatingActionButtonTapped.value = !controller.floatingActionButtonTapped.value;

            }):
        Container(
          child:
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            FloatingActionButton.extended(onPressed: (){
              Get.toNamed(Routes.CREATE_POST);
            },
                heroTag: null,
                icon: FaIcon(FontAwesomeIcons.add),
                label: Text('Create a post')).marginOnly(bottom: 10),
            FloatingActionButton.extended(
                onPressed: (){


            },
                heroTag: null,
                icon: FaIcon(FontAwesomeIcons.add),
                label: Text('Create an event')).marginOnly(bottom: 10),

            FloatingActionButton.extended(
                onPressed: (){
                  controller.floatingActionButtonTapped.value = !controller.floatingActionButtonTapped.value;

            },
                heroTag: null,
                icon: const FaIcon(FontAwesomeIcons.multiply),
                label: Text('Cancel')).marginOnly(bottom: 10),


          ],
        )
          ,)),
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshCommunity(showMessage: true);
              controller.onInit();
            },
            child: Container(
              decoration: const BoxDecoration(color: backgroundColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20.0),
                    topLeft: Radius.circular(20.0)),

              ),
              child: CustomScrollView(
                primary: true,
                shrinkWrap: false,
                slivers: <Widget>[
                  SliverAppBar(
                    leading: IconButton(
                      icon: const FaIcon(FontAwesomeIcons.userGroup, color: Colors.white),
                      onPressed: () => {Scaffold.of(context).openDrawer()},
                    ),
                    //expandedHeight: 200,
                    centerTitle: true,
                    backgroundColor: primaryColor,
                    actions: const [
                      SearchCommunityWidget(),
                    ],
                    title: Text(
                      'Community',
                      style: Get.textTheme.headline6!.merge(TextStyle(color: Colors.white)),
                    ),
                    flexibleSpace: FlexibleSpaceBar(
                      collapseMode: CollapseMode.parallax,
                      background: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: const <Widget>[
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Row(children: const [
                            Icon(Icons.filter_alt_off_outlined),
                            SizedBox(width: 10,),
                            Text('Filter',)
                          ],).marginSymmetric(vertical: 20, horizontal: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: const [
                            Text('Posts',  style: TextStyle(color: Color(0xff5c7d3b), fontWeight: FontWeight.bold)),
                            Text('Events', style: TextStyle(color: Color(0xff7aa64e)))
                          ],),
                       SizedBox(
                         height: Get.height,
                         child: Obx(() => controller.loadingPosts.value?
                             LoadingCardWidget()
                             :Scrollbar(
                               child: ListView.builder(
                                 //controller: controller.scrollbarController,
                           padding: EdgeInsets.only(top: 10, ),
                           itemCount: controller.allPosts.length,
                           itemBuilder: (context, index) {

                            controller.likeTapped.value = controller.allPosts[index].likeTapped;
                               return PostCardWidget(
                                 likeTapped: RxBool(controller.allPosts[index].likeTapped),
                                 content: controller.allPosts[index].content,
                                 zone: controller.allPosts[index].zone['name'],
                                 publishedDate: controller.allPosts[index].publishedDate,
                                 postId: controller.allPosts[index].postId,
                                 commentCount: controller.allPosts[index].commentCount,
                                 likeCount: controller.allPosts[index].likeCount,
                                 shareCount: controller.allPosts[index].shareCount,
                                 images: controller.allPosts[index].imagesUrl,
                                 user: User(
                                     firstName: controller.allPosts[index].user.firstName,
                                     lastName: controller.allPosts[index].user.lastName,
                                     avatarUrl: controller.allPosts[index].user.avatarUrl
                                 ),

                                 onLikeTapped: (){
                                   controller.selectedPost.clear();
                                   controller.selectedPost.add(controller.allPosts[index]);
                                   if(controller.allPosts[index]==controller.selectedPost[0]){
                                     //controller.likeTapped.value = !controller.likeTapped.value;
                                     Get.find<PostCardWidget>().likeTapped = controller.allPosts[index].likeTapped?RxBool(false):RxBool(true);
                                     controller.allPosts[index].likeTapped = !controller.allPosts[index].likeTapped;
                                     controller.likeUnlikePost(controller.allPosts[index].postId);
                                   }

                                 },
                                 onCommentTapped: () async{
                                   controller.postDetails = await controller.getAPost(controller.allPosts[index].postId);
                                   controller.commentList.value = controller.postDetails.commentList!;
                                   Get.toNamed(Routes.COMMENT_VIEW);

                                 },
                                 onPictureTapped: () async{
                                   controller.postDetails = controller.allPosts[index];
                                   Get.toNamed(Routes.DETAILS_VIEW);

                                 },
                                 onSharedTapped: ()async{
                                   await controller.sharePost(controller.allPosts[index].postId);
                                 },

                                 liked: controller.allPosts[index].liked,
                               );
                           },
                         ),
                             )

                         ),
                       ),
                        ],
                      )
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
