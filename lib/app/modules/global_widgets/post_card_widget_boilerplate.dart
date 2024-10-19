import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/global_widgets/read_more_text.dart';
import 'package:mapnrank/app/services/global_services.dart';
import '../../../color_constants.dart';
import '../community/controllers/community_controller.dart';
import '../community/widgets/comment_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostCardWidgetBoilerplate extends StatelessWidget {
  PostCardWidgetBoilerplate({Key? key,
    this.user,
    this.sectors,
    this.zone,
    this.content,
    this.postId,
    this.publishedDate,
    this.likeCount,
    this.commentCount,
    this.shareCount,
    this.images,
    this.liked,
    this.onLikeTapped,
    this.onCommentTapped,
    this.onPictureTapped,
    this.onSharedTapped,
    this.shareTapped,
    this.likeTapped,
    this.commentTapped,
    this.onFollowTapped,
    this.likeWidget,
    this.onActionTapped,
    this.popUpWidget,
    this.followWidget,
    this.isCommunityPage,
  }) : super(key: key);

  final List? sectors;
  final String? publishedDate;
  final String? content;
  final int? postId;
  var zone;
  final UserModel? user;
  RxInt? likeCount;
  final int? commentCount;
  RxInt? shareCount;
  final List? images;
  final bool? liked;
  final Function()? onLikeTapped;
  final Function()? onCommentTapped;
  final Function()? onSharedTapped;
  final Function()? onPictureTapped;
  final Function()? onActionTapped;
  final Function()? onFollowTapped;
  RxBool? likeTapped;
  var commentTapped;
  var shareTapped;
  Widget? likeWidget;
  Widget? popUpWidget;
  Widget? followWidget;
  bool? isCommunityPage;





  @override
  Widget build(BuildContext context) {


    return Card(

        color: Get.theme.primaryColor,
        shape: const RoundedRectangleBorder(
          side:  BorderSide(
              color: inactive, width: 0, style: BorderStyle.none
            //travelState != 'accepted' && isUser ? inactive : interfaceColor.withOpacity(0.4), width: 2
          ) ,
          //borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                //width: Get.width,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ClipOval(
                        child: FadeInImage(
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          image:  NetworkImage('user!.avatarUrl!', headers: GlobalService.getTokenHeaders()),
                          placeholder: const AssetImage(
                              "assets/images/loading.gif"),
                          imageErrorBuilder:
                              (context, error, stackTrace) {
                            return Image.asset(
                                "assets/images/loading.gif",
                                width: 40,
                                height: 40,
                                fit: BoxFit.cover);
                          },
                        )
                    ),
                    const SizedBox(width: 5,),
                    SizedBox(
                      width: Get.width*0.8,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: Get.width*0.8,
                            height: 20,
                            child: Image.asset(
                                "assets/images/loading.gif",
                            fit: BoxFit.fitWidth,),
                          ).marginOnly(bottom: 10),

                          SizedBox(
                            height: 10,
                            width: Get.width*0.8,
                            child: Image.asset(
                                "assets/images/loading.gif",
                              fit: BoxFit.fitWidth,),
                          ),
                        ],
                      ),
                    ),







                  ],


                ),
              ),

              ReadMoreText(
                  content == null? '':content?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
                  maxLines: 2,
                  trimMode: TrimMode.line,
                  textStyle: Get.textTheme.displayMedium!),
              if(images!.isNotEmpty)...[
                if( images!.length == 1)...[
                  GestureDetector(
                    onTap: onPictureTapped,
                    child: ClipRect(
                        child: FadeInImage(
                          width: Get.width,
                          height: 375,
                          fit: BoxFit.cover,
                          image:  NetworkImage(
                              '${images![0]['url']}',
                              headers: GlobalService.getTokenHeaders()
                          ),
                          placeholder: const AssetImage(
                              "assets/images/loading.gif"),
                          imageErrorBuilder:
                              (context, error, stackTrace) {
                            return Image.asset(
                                "assets/images/loading.gif",
                                width: Get.width,
                                height: 375,
                                fit: BoxFit.fitHeight);
                          },
                        )

                    ),
                  )
                ]
                else...[
                  SizedBox(
                    height: 375,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: onPictureTapped,
                          child: FadeInImage(
                            width: Get.width,
                            height: 375,
                            fit: BoxFit.cover,
                            image: NetworkImage('${images![index]['url']}',
                                headers: GlobalService.getTokenHeaders()
                            ),
                            placeholder: const AssetImage(
                              "assets/images/loading.gif",),
                            imageErrorBuilder:
                                (context, error, stackTrace) {
                              return Image.asset(
                                  "assets/images/loading.gif",
                                  width: Get.width,
                                  height: 375,
                                  fit: BoxFit.fitHeight);
                            },
                          ).marginOnly(right: 10),
                        );

                      },
                    ),
                  )
                ]

                ,
              ],


              SizedBox(
                width: Get.width*0.95,
                child: Image.asset(
                  fit: BoxFit.fitWidth,
                    "assets/images/loading.gif"),
              ).marginOnly(bottom: 10),


              const Divider(
                color: Colors.grey,
              ),
              SizedBox(
                height: 20,
              width: Get.width-30,
              child: Image.asset(
                  fit: BoxFit.fitWidth,
              "assets/images/loading.gif"),
              ).marginOnly(bottom: 40),

              for(int i = 0; i< 6; i++)...[
                Container(

                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipOval(
                            child: FadeInImage(
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                              image:  NetworkImage('user!.avatarUrl!', headers: GlobalService.getTokenHeaders()),
                              placeholder: const AssetImage(
                                  "assets/images/loading.gif"),
                              imageErrorBuilder:
                                  (context, error, stackTrace) {
                                return Image.asset(
                                    "assets/images/loading.gif",
                                    width: 40,
                                    height: 40,
                                    fit: BoxFit.cover);
                              },
                            )
                        ).marginOnly(right: 10),


                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              //borderRadius: BorderRadius.circular(20)
                            ),
                            //height: 150,
                            width: Get.width,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: Get.width*0.95,
                                  height: 10,
                                  child: Image.asset(
                                      fit: BoxFit.fitWidth,
                                      "assets/images/loading.gif"),
                                ).marginOnly(bottom: 10),
                                SizedBox(
                                  width: Get.width*0.95,
                                  height: 20,
                                  child: Image.asset(
                                      fit: BoxFit.fitWidth,
                                      "assets/images/loading.gif"),
                                ).marginOnly(bottom: 10),
                              ],

                            ),
                          ),
                        ),

                      ]
                  ),

                ).marginOnly(bottom: 10),
              ]

            ]
        ).paddingSymmetric(horizontal: 10, vertical: 10)
    );
  }

}