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
                        image: NetworkImage(controller.postDetails!.value.user!.avatarUrl!, headers: GlobalService.getTokenHeaders()),
                        placeholder: const AssetImage(
                            "assets/images/loading.gif"),
                        imageErrorBuilder:
                            (context, error, stackTrace) {
                          return Image.asset(
                              "assets/images/user_admin.png",
                              width: 50,
                              height: 50,
                              fit: BoxFit.fitWidth);
                        }
                    )
                ),
                const SizedBox(
                  width: 10,
                ),

                SizedBox(
                  width: Get.width*0.48,
                    child: Text('${controller.postDetails!.value.user!.firstName!} ${controller.postDetails!.value.user!.lastName!}', style: Get.textTheme.headlineMedium!.merge(const TextStyle(fontSize: 13, color: Colors.white, fontWeight: FontWeight.bold)), overflow: TextOverflow.ellipsis,)),


              ]
          ).paddingOnly(left: 5),
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
                          width: Get.width,
                          height: Get.height/2,
                          padding: EdgeInsets.all(20),
                          decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                          child: Text(controller.postDetails!.value.content!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''), style: const TextStyle(color: Colors.black), ).marginOnly(bottom: 50),

                        );
                      },
                    );
                  },
                  child: Align(
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                          child: Text(controller.postDetails!.value.content!.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''), style: const TextStyle(color: Colors.white), overflow: TextOverflow.ellipsis,)).marginAll(20)),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Obx(() => controller.postDetails!.value.likeTapped!.value?
                    TextButton.icon(
                      onPressed: (){

                          controller.postDetails!.value.likeTapped!.value = false;
                          --controller.likeCount!.value;
                          print(controller.postDetails!.value.likeTapped!.value);
                          controller.allPosts[controller.allPosts.indexOf(controller.allPosts.where((element)=>element.postId == controller.postDetails.value.postId).toList()[0])].likeTapped.value
                          = !controller.allPosts[controller.allPosts.indexOf(controller.allPosts.where((element)=>element.postId == controller.postDetails.value.postId).toList()[0])].likeTapped.value;
                          controller.likeUnlikePost(controller.postDetails!.value.postId!,  controller.allPosts.indexOf(controller.allPosts.where((element)=>element.postId == controller.postDetails.value.postId).toList()[0]));




                      },
                      icon: const FaIcon(FontAwesomeIcons.thumbsUp, color: Colors.white,),
                      label:  Text('${controller.likeCount}', style: TextStyle(color: Colors.white,),)):
                    TextButton.icon(
                      onPressed: (){


                          controller.postDetails!.value.likeTapped!.value = true;
                          ++controller.likeCount!.value;
                          print(controller.postDetails!.value.likeTapped!.value);
                          controller.allPosts[controller.allPosts.indexOf(controller.allPosts.where((element)=>element.postId == controller.postDetails.value.postId).toList()[0])].likeTapped.value
                          = !controller.allPosts[controller.allPosts.indexOf(controller.allPosts.where((element)=>element.postId == controller.postDetails.value.postId).toList()[0])].likeTapped.value;
                          controller.likeUnlikePost(controller.postDetails!.value.postId!, controller.allPosts.indexOf(controller.allPosts.where((element)=>element.postId == controller.postDetails.value.postId).toList()[0]));


                      },
                      icon: const FaIcon(FontAwesomeIcons.thumbsUp, color: Colors.white,),
                      label:  Text('${controller.likeCount}', style: TextStyle(color: Colors.white,),)),),

                    TextButton.icon(
                        onPressed: () async{
                          Get.toNamed(Routes.COMMENT_VIEW);
                          controller.postDetails = await controller.getAPost(controller.postDetails!.value.postId!);
                          controller.commentList.value = controller.postDetails.value.commentList!;
                          controller.commentCount!.value = controller.postDetails.value.commentCount!;

                        },
                        icon: const FaIcon(FontAwesomeIcons.comment, color: Colors.white,),
                        label: Text('${controller.postDetails.value.commentCount}', style:  TextStyle(color: Colors.white,),)),
                    TextButton.icon(
                        onPressed: () async{

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
                if(controller.postDetails.value.imagesUrl!.isNotEmpty)...[
                  if( controller.postDetails.value.imagesUrl!.length == 1)...[
                    Expanded(
                      child: GestureDetector(
                        //onTap: onPictureTapped,
                        child: ClipRect(
                            child: FadeInImage(
                              width: Get.width,
                              height: Get.height,
                              fit: BoxFit.cover,
                              image:  NetworkImage(
                                  '${controller.postDetails.value.imagesUrl![0]['url']}',
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
                        itemCount: controller.postDetails.value.imagesUrl?.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            //onTap: onPictureTapped,
                            child: FadeInImage(
                              width: Get.width,
                              height: Get.height*0.8,
                              fit: BoxFit.cover,
                              image:  NetworkImage(
                                  '${controller.postDetails.value.imagesUrl![index]['url']}',
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
