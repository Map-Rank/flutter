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

class PostCardWidget extends StatelessWidget {
  PostCardWidget({Key? key,
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

                    InkWell(
                      onTap: () => showDialog(
                          context: context, builder: (_){
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                                child: IconButton(onPressed: ()=> Navigator.pop(context), icon: const Icon(Icons.close, size: 20))
                            ),
                            ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: FadeInImage(
                                width: Get.width,
                                height: Get.height/2,
                                fit: BoxFit.cover,
                                image:  NetworkImage(user!.avatarUrl!, headers: GlobalService.getTokenHeaders()),
                                placeholder: const AssetImage(
                                    "assets/images/loading.gif"),
                                imageErrorBuilder:
                                    (context, error, stackTrace) {
                                  return Center(
                                      child: Container(
                                          width: Get.width/1.5,
                                          height: Get.height/3,
                                          color: Colors.white,
                                          child: const Center(
                                              child: Icon(Icons.person, size: 150)
                                          )
                                      )
                                  );
                                },
                              ),
                            )
                          ],
                        );
                      }),
                      child: ClipOval(
                          child: FadeInImage(
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                            image:  NetworkImage(user!.avatarUrl!, headers: GlobalService.getTokenHeaders()),
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
                          )
                      ),
                    ),
                    const SizedBox(width: 5,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Get.width*0.8,
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width*0.45,
                                child: Text('${user?.firstName![0].toUpperCase()}${user?.firstName!.substring(1).toLowerCase()} ${user?.lastName![0].toUpperCase()}${user?.lastName!.substring(1).toLowerCase()}',
                                    overflow:TextOverflow.ellipsis ,
                                    style: Get.textTheme.titleSmall),
                              ),
                              Spacer(),


                              isCommunityPage!?
                              followWidget!:
                                SizedBox(
                                    width: 15,
                                    height: 15,
                                    child: popUpWidget!),


                            ],
                          ),
                        ),

                        SizedBox(
                          height: 10,
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,

                            children: [
                              const FaIcon(FontAwesomeIcons.locationDot, size: 10,).marginOnly(right: 10),
                              SizedBox(
                                  //width: Get.width/4,
                                  child: Text(zone.toString(), style: Get.textTheme.bodySmall, overflow: TextOverflow.ellipsis,).marginOnly(right: 10),),
                              const FaIcon(FontAwesomeIcons.solidCircle, size: 10,).marginOnly(right: 10),
                              SizedBox(
                                 //width: Get.width/4,
                                  child: Text(publishedDate!, style: Get.textTheme.bodySmall)),


                              //Text("⭐️ ${this.rating}", style: TextStyle(fontSize: 13, color: appColor))
                            ],
                          ),
                        ),
                      ],
                    ),







                  ],


                ),
              ),

        ReadMoreText(
            content == null? '':content?.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ''),
            maxLines: 2,
            trimMode: TrimMode.line,
            textStyle: Get.textTheme.displayMedium!)
            .marginOnly(bottom: 20),
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
                            width: Get.width-50,
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


              Obx(() => Row(
                children: [
                  Obx(() => likeCount!.value>0?FaIcon(FontAwesomeIcons.solidHeart, color: interfaceColor):FaIcon(FontAwesomeIcons.heart, color: null)),
                  const SizedBox(width: 10,),
                  if(likeCount!.value <= 1)...[
                    Obx(() => Text('${likeCount!.value} ${AppLocalizations.of(context).like}'),)
                  ]
                  else...[
                    Obx(() => Text('${likeCount!.value}  ${AppLocalizations.of(context).like}s'),)
                  ],


                  const Spacer(),
                  if(commentCount! <= 1)...[
                    Text(' ${commentCount!}  ${AppLocalizations.of(context).comment}'),
                  ]
                  else...[
                    Text(' ${commentCount!}  ${AppLocalizations.of(context).comment}s'),
                  ],
                  if(shareCount! <= 1)...[
                    Obx(() =>  Text(' . ${shareCount!}  ${AppLocalizations.of(context).share}'),),

                  ]
                  else...[
                    Obx(() =>Text(' . ${shareCount!}  ${AppLocalizations.of(context).share}s'), )

                  ],




                ],
              ).marginOnly(top: 10, bottom: 10),),


              const Divider(
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap:onLikeTapped,

                    child: Column(
                      children:  [

                        likeWidget!,

                         Text(AppLocalizations.of(context).like_verb)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onCommentTapped,
                    child: Column(
                      children: [
                        FaIcon(FontAwesomeIcons.comment),
                        Text(AppLocalizations.of(context).comment_verb)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onSharedTapped,
                    child: Column(
                      children:[
                        FaIcon(FontAwesomeIcons.shareFromSquare, key: Key('shareIcon'),),
                        Text(AppLocalizations.of(context).share_verb),
                      ],
                    ),
                  ),
                ],

              ),

            ]
        ).paddingSymmetric(horizontal: 10, vertical: 10)
    );
  }

}