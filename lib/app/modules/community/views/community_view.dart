import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/community/widgets/buildSelectSector.dart';
import 'package:mapnrank/app/modules/community/widgets/buildSelectZone.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/loading_cards.dart';
import 'package:mapnrank/app/modules/global_widgets/post_card_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/search_community_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';


class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>PostCardWidget(likeWidget: null,));
    return  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar:  AppBar(
          leading: IconButton(
            icon: const FaIcon(FontAwesomeIcons.userGroup, color: Colors.white),
            onPressed: () => {Scaffold.of(context).openDrawer()},
          ),
          //expandedHeight: 200,
          centerTitle: true,
          backgroundColor: primaryColor,
          actions: [
            GestureDetector(
              onTap: (){
                controller.searchField.value = !controller.searchField.value;

              },
              child: const Icon(
                Icons.search_off_outlined,
                color: Colors.white,
                size: 28,
              ).marginOnly(right: 20),
            ),
          ],
          title: Obx(() => !controller.searchField.value?Text(
            'Community',
            style: Get.textTheme.headline6!.merge(const TextStyle(color: Colors.white)),
          )
              :TextFormField(
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              hintText: 'Type here',
              hintStyle: TextStyle(color: Colors.white),
            ),
            onChanged: (value){
              controller.filterSearchPostsByName(value);

            },


          )).marginOnly(bottom: 10),
          flexibleSpace: FlexibleSpaceBar(
            collapseMode: CollapseMode.parallax,
            background: Stack(
              alignment: AlignmentDirectional.bottomCenter,
              children: const <Widget>[
              ],
            ),
          ),
        ),
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
                controller.noFilter.value = true;
                Get.toNamed(Routes.CREATE_POST);
              },
                  heroTag: null,
                  icon: const FaIcon(FontAwesomeIcons.add),
                  label: const Text('Create a post')).marginOnly(bottom: 10),
              FloatingActionButton.extended(
                  onPressed: (){

                  },
                  heroTag: null,
                  icon: const FaIcon(FontAwesomeIcons.add),
                  label: const Text('Create an event')).marginOnly(bottom: 10),

              FloatingActionButton.extended(
                  onPressed: (){
                    controller.floatingActionButtonTapped.value = !controller.floatingActionButtonTapped.value;

                  },
                  heroTag: null,
                  icon: const FaIcon(FontAwesomeIcons.multiply),
                  label: const Text('Cancel')).marginOnly(bottom: 10),


            ],
          )
          ,)),
        body: RefreshIndicator(
            onRefresh: () async {
              await controller.refreshCommunity(showMessage: true);
              controller.onInit();
            },
            child: ListView(
              children:[
                GestureDetector(
                  onTap: (){
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
                            child: ListView(
                              children: [
                                BuildSelectSector(),

                                BuildSelectZone(),

                              ],
                            )
                          );
                        },
                    );
                  },
                  child: Row(children: const [
                    Icon(Icons.filter_alt_off_outlined),
                    SizedBox(width: 10,),
                    Text('Filter',)
                  ],).marginSymmetric(vertical: 20, horizontal: 20),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Posts',  style: TextStyle(color: Color(0xff5c7d3b), fontWeight: FontWeight.bold)),
                    Text('Events', style: TextStyle(color: Color(0xff7aa64e)))
                  ],),
                SizedBox(
                  height: Get.height*0.63,
                  child: Obx(() => controller.loadingPosts.value?
                  const LoadingCardWidget()
                      :controller.allPosts.isNotEmpty?
                  Scrollbar(
                    child: ListView.builder(
                      //primary: true,
                      controller: controller.scrollbarController,
                      padding: const EdgeInsets.only(top: 10, ),
                      itemCount: controller.allPosts.length,
                      itemBuilder: (context, index) {
                        //controller.likeTapped.value = controller.allPosts[index].likeTapped;
                        return Obx(() => PostCardWidget(
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
                          shareCount: controller.allPosts[index].shareCount,
                          images: controller.allPosts[index].imagesUrl,
                          user: User(
                              firstName: controller.allPosts[index].user.firstName,
                              lastName: controller.allPosts[index].user.lastName,
                              avatarUrl: controller.allPosts[index].user.avatarUrl
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
                          popUpWidget:controller.allPosts[index].user.userId == controller.currentUser.value.userId?
                          PopupMenuButton(
                            onSelected: (value) async{
                              if(value == 'Delete'){
                                await controller.deletePost(controller.allPosts[index].postId);
                              }
                              if(value == 'Edit'){
                                controller.createUpdatePosts.value = true;
                                controller.post = await controller.getAPost(controller.allPosts[index].postId);
                                print('sectors ${controller.post.sectors!}');

                                for(int i = 0; i <controller.post.sectors!.length; i++) {

                                  controller.sectorsSelected.add(controller.sectors.where((element) => element['id'] == controller.post.sectors![i]['id']).toList()[0]);
                                }
                                print('sectors selected : ${controller.sectorsSelected}');


                                controller.noFilter.value = true;
                                Get.toNamed(Routes.CREATE_POST);
                              }
                            },
                            itemBuilder: (context) {
                              return {'Edit', 'Delete'}.map((String choice) {
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice, style: const TextStyle(color: Colors.black),),
                                );
                              }).toList();

                            },)
                              :PopupMenuButton(
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

                          liked: controller.allPosts[index].liked,
                        ));
                      },
                    ),
                  )
                      : Center(
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

                  )

                  ),
                ),
                Obx(() => controller.lazyLoad.value?

                const SizedBox(height: 30,
                    child: SpinKitThreeBounce(color: Colors.white, size: 20))
                  :const SizedBox(),
                )
              ] ,
            )
        ),
      ),
    );
  }
}
