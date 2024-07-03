import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/post_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_widget.dart';
import '../../../../color_constants.dart';
import '../../../models/user_model.dart';
import '../../global_widgets/post_card_widget.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CommentView extends GetView<CommunityController> {
   CommentView({
     this.post,
    super.key
  });
  Post? post;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        bottomSheet: SizedBox(
          height: 100,
          child: Column(
              children: <Widget>[
                SizedBox(
                  child: Card(
                      elevation: 0,
                      child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: controller.commentController,
                            style: TextStyle(color: Colors.grey.shade700, fontSize: 12),
                            cursorColor: Colors.black,
                            textInputAction:TextInputAction.done ,
                            maxLines: 20,
                            minLines: 2,
                            onChanged: (input) => controller.comment.value = input,
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                //label: Text(AppLocalizations.of(context).description),
                                fillColor: Palette.background,
                                enabledBorder: InputBorder.none,
                                //filled: true,
                                prefixIcon: const Icon(Icons.description, color: Colors.grey,),
                                hintText: 'Share your thoughts ',
                                hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                              suffixIcon: Obx(() => !controller.sendComment.value?GestureDetector(
                                  onTap: () async {
                                    controller.comment.value = controller.commentController.text;

                                    var result =  await controller.commentPost(controller.postDetails!.postId!, controller.comment.value);
                                    controller.commentCount!.value =  controller.commentCount!.value +1;
                                    controller.commentController.clear();
                                    controller.commentList.value = result.commentList;
                                  },
                                  child: FaIcon(FontAwesomeIcons.paperPlane,color: Colors.grey, )

                              ):SizedBox(
                                  height: 10,
                                  width: 10,
                                  child: SpinKitDualRing(color: interfaceColor, size: 10,))),

                          )
                      )
                  ),
                )
                )]
          ),
        ),
        body: Container(
          padding: EdgeInsets.only(bottom: 100),
          //height:  Get.height,
          child: CustomScrollView(
            //controller: controller.scrollbarController,
            //primary: true,
            shrinkWrap: false,
            slivers: <Widget>[
              SliverAppBar(
                //expandedHeight: 80,
                floating: true,
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(FontAwesomeIcons.arrowLeft, color: interfaceColor),
                  onPressed: () => {
                    controller.sendComment.value = false,
                    Navigator.pop(context),
                    //Get.back()
                  },
                ),

                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                ),

              ),


              Obx(() => SliverToBoxAdapter(
                child:   PostCardWidget(
                  popUpWidget: SizedBox(),
                  likeTapped: RxBool(controller.postDetails!.likeTapped!),
                  content: controller.postDetails!.content,
                  zone: controller.postDetails!.zone['name'],
                  publishedDate: controller.postDetails!.publishedDate,
                  postId: controller.postDetails!.postId,
                  commentCount: controller.commentList?.length,
                  likeCount: controller.likeCount,
                  shareCount: controller.shareCount,
                  images: controller.postDetails!.imagesUrl,
                  user: controller.postDetails!.user!,
                  likeWidget:  Obx(() =>
                  controller.selectedPost.contains(controller.postDetails) &&controller.postDetails.likeTapped!?
                  const FaIcon(FontAwesomeIcons.heart,):
                  controller.selectedPost.contains(controller.postDetails) &&!controller.postDetails.likeTapped!?
                  const FaIcon(FontAwesomeIcons.solidHeart, color: interfaceColor,):
                  !controller.postDetails.likeTapped!?
                  const FaIcon(FontAwesomeIcons.heart,):
                  const FaIcon(FontAwesomeIcons.solidHeart, color: interfaceColor,)


                    ,),


                  onLikeTapped: (){

                    var arguments = Get.arguments as Map<String, dynamic>;
                    if(arguments!=null) {
                      if (arguments['post'] != null) {
                        post = arguments['post'];
                      }}

                    if( controller.selectedPost.contains(post)){
                      controller.likeCount?.value = (controller.likeCount!.value - 1);
                      controller.selectedPost.remove(post);
                      //controller.postSelectedIndex.value = index;
                      controller.likeUnlikePost(post!.postId!);
                    }
                    else{
                      controller.likeCount?.value = (controller.likeCount!.value + 1);
                      controller.selectedPost.add(post);
                      controller.likeUnlikePost(post!.postId!);
                    }

                  },
                  onSharedTapped: (){
                    var arguments = Get.arguments as Map<String, dynamic>;
                    if(arguments!=null) {
                      if (arguments['post'] != null) {
                        post = arguments['post'];
                      }}

                    controller.shareCount?.value = (controller.shareCount!.value + 1);
                    controller.sharedPost.add(post);
                    controller.sharePost(post!.postId!);

                  },
                  liked: controller.postDetails!.liked,
                ).marginOnly(top: 20, bottom: 5),)),



              Obx(() => SliverList(
                  delegate: SliverChildBuilderDelegate(

                  childCount: controller.commentList.length,
                      (context, index){
                        return Container(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: CommentWidget(
                            user: '${controller.commentList[index]['user']['first_name'][0].toUpperCase()}${controller.commentList[index]['user']['first_name'].substring(1).toLowerCase()} '
                                '${controller.commentList[index]['user']['last_name'][0].toUpperCase()}${controller.commentList[index]['user']['last_name'].substring(1).toLowerCase()}' ,
                            comment: controller.commentList[index]['text'],
                            imageUrl: controller.commentList[index]['user']['avatar'],
                          ),
                        );

              }
                       )))



            ],

          ),
        )
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
