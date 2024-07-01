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
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowLeft, color: interfaceColor),
            onPressed: () => {
              Navigator.pop(context),
              //Get.back()
            },
          ),
        ),
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
                                prefixIcon: const Icon(Icons.description),
                                hintText: 'Share your thoughts ',
                                hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                              suffixIcon: GestureDetector(
                                onTap: () async {
                                  var result =  await controller.commentPost(controller.postDetails!.postId!, controller.comment.value);
                                   controller.commentList.value = result.commentList;
                                },
                                  child: const FaIcon(FontAwesomeIcons.paperPlane))
                            ),

                          )
                      )
                  ),
                )
              ]
          ),
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
              decoration: const BoxDecoration(color: Colors.white,
              ),
              child:   SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child:Column(
    children:
                [
                  PostCardWidget(
                    popUpWidget: SizedBox(),
                    likeTapped: RxBool(controller.postDetails!.likeTapped!),
                    content: controller.postDetails!.content,
                    zone: controller.postDetails!.zone['name'],
                    publishedDate: controller.postDetails!.publishedDate,
                    postId: controller.postDetails!.postId,
                    commentCount: controller.postDetails!.commentCount,
                    likeCount: RxInt(controller.selectedPost.contains(controller.postDetails) && controller.postDetails!.likeTapped!?
                    controller.postDetails.likeCount!-1
                        :controller.selectedPost.contains(controller.postDetails) && !controller.postDetails!.likeTapped!?
                    controller.postDetails.likeCount!+1:
                    controller.postDetails.likeCount!,),
                    shareCount: controller.postDetails!.shareCount,
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

                      if( controller.selectedPost.contains(controller.postDetails)){
                        controller.selectedPost.remove(controller.postDetails);
                        controller.likeUnlikePost(controller.postDetails.postId!);
                      }
                      else{
                        controller.selectedPost.add(controller.postDetails);
                        controller.likeUnlikePost(controller.postDetails.postId!);
                      }

                    },
                    liked: controller.postDetails!.liked,
                  ).marginOnly(top: 20, bottom: 5),




                  Obx(() => buildCommentList(context, controller.commentList.value!).marginOnly(left:20 , right: 20),)




                ],)
              ).paddingOnly(bottom: 80),
          ),
        )
    );
  }

  Widget buildCommentList(BuildContext context, var commentsList) {
    return SizedBox(
      height: Get.height,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: commentsList.length,
          itemBuilder: (context, index) {
            return  CommentWidget(
              user: '${commentsList[index]['user']['first_name']} ${commentsList[index]['user']['last_name']}' ,
              comment: commentsList[index]['text'],
              imageUrl: commentsList[index]['user']['avatar'],
            );
          },
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
            'assets/img/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }
}
