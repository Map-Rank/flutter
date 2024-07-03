import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/post_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_loading_widget.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_widget.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import '../../../../color_constants.dart';
import '../../../models/user_model.dart';
import '../../../services/global_services.dart';
import '../../global_widgets/post_card_widget.dart';

class DetailsView extends GetView<CommunityController> {
  DetailsView({
    this.post,
    super.key
  });
  Post? post;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipOval(
                    child: FadeInImage(
                        width: 30,
                        height: 30,
                        fit: BoxFit.cover,
                        image: NetworkImage(controller.postDetails!.user!.avatarUrl!, headers: GlobalService.getTokenHeaders()),
                        placeholder: const AssetImage(
                            "assets/images/loading.gif"),
                        imageErrorBuilder:
                            (context, error, stackTrace) {
                          return Image.asset(
                              "assets/images/téléchargement (3).png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.fitWidth);
                        }
                    )
                ),
                const SizedBox(
                  width: 20,
                ),

                Text('${controller.postDetails!.user!.firstName!} ${controller.postDetails!.user!.lastName!}', style: Get.textTheme.headline4!.merge(const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)), overflow: TextOverflow.ellipsis,),


              ]
          ).paddingAll(20),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
            onPressed: () => {
              Navigator.pop(context),
              //Get.back()
            },
          ),
        ),
        bottomSheet: Container(
          color: Colors.black,
          height: 120,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  onTap: (){
                    showModalBottomSheet(context: context,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                      builder: (context) {
                        return Container(
                          height: Get.height/2,
                          padding: EdgeInsets.all(20),
                          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                          child: Text(controller.postDetails!.content!, style: const TextStyle(color: Colors.black), ).marginOnly(bottom: 50),

                        );
                      },
                    );
                  },
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                          child: Text(controller.postDetails!.content!, style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,)).marginAll(20)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: (){
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
                      icon: const FaIcon(FontAwesomeIcons.thumbsUp, color: Colors.white,),
                      label: Obx(() => Text('${controller.likeCount}', style: TextStyle(color: Colors.white,),)),),
                    TextButton.icon(
                        onPressed: () async{
                          showDialog(context: context, builder: (context){
                            return CommentLoadingWidget();
                          },);
                          controller.postDetails = await controller.getAPost(controller.postDetails!.postId!);
                          controller.commentList.value = controller.postDetails.commentList!;
                          Navigator.of(context).pop();
                          controller.commentCount!.value = controller.postDetails.commentCount!;
                          Get.toNamed(Routes.COMMENT_VIEW);
                        },
                        icon: const FaIcon(FontAwesomeIcons.comment, color: Colors.white,),
                        label: Text('${controller.postDetails.commentCount}', style:  TextStyle(color: Colors.white,),)),
                    TextButton.icon(
                        onPressed: () async{
                          var arguments = Get.arguments as Map<String, dynamic>;
                          if(arguments!=null) {
                            if (arguments['post'] != null) {
                              post = arguments['post'];
                            }}

                            controller.shareCount?.value = (controller.shareCount!.value + 1);
                            controller.sharedPost.add(post);
                            controller.sharePost(post!.postId!);


                        },
                        icon: const FaIcon(FontAwesomeIcons.share, color: Colors.white,),
                        label: Obx(() => Text('${controller.shareCount}', style: TextStyle(color: Colors.white,),)))

                  ],)

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
            decoration: const BoxDecoration(color: Colors.black,
            ),
            child:   Column(
              children:
              [
                if(controller.postDetails.imagesUrl!.isNotEmpty)...[
                  if( controller.postDetails.imagesUrl!.length == 1)...[
                    Expanded(
                      child: GestureDetector(
                        //onTap: onPictureTapped,
                        child: ClipRect(
                            child: FadeInImage(
                              width: Get.width,
                              height: Get.height,
                              fit: BoxFit.cover,
                              image:  NetworkImage('${GlobalService().baseUrl}'
                                  '${controller.postDetails.imagesUrl![0]['url'].substring(1,controller.postDetails.imagesUrl![0]['url'].length)}',
                                  headers: GlobalService.getTokenHeaders()
                              ),
                              placeholder: const AssetImage(
                                  "assets/images/loading.gif"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    "assets/images/loading.gif",
                                    width: Get.width,
                                    height: Get.height,
                                    fit: BoxFit.fitWidth);
                              },
                            )

                        ),
                      ),
                    )
                  ]
                  else...[
                    Expanded(
                      //width: Get.width,
                      //height: Get.height*0.7,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.postDetails.imagesUrl?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            //onTap: onPictureTapped,
                            child: FadeInImage(
                              width: Get.width,
                              height: Get.height*0.8,
                              fit: BoxFit.cover,
                              image:  NetworkImage('${GlobalService().baseUrl}'
                                  '${controller.postDetails.imagesUrl![index]['url'].substring(1,controller.postDetails.imagesUrl![index]['url'].length)}',
                                  headers: GlobalService.getTokenHeaders()
                              ),
                              placeholder: const AssetImage(
                                  "assets/images/loading.gif"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    "assets/images/loading.gif",
                                    width: Get.width,
                                    height: Get.height,
                                    fit: BoxFit.fitWidth);
                              },
                            ).marginOnly(right: 10,),
                          );

                        },
                      ),
                    )
                  ]

                  ,
                ],





              ],).paddingOnly(bottom: 80),
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
