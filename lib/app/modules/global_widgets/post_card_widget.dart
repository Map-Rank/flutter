import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/global_widgets/read_more_text.dart';
import 'package:mapnrank/app/modules/other_user_profile/controllers/other_user_profile_controller.dart';
import 'package:mapnrank/app/services/global_services.dart';
import '../../../color_constants.dart';
import '../../routes/app_routes.dart';
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
    this.imageScrollController,
  }) : super(key: key);

  final List? sectors;
  final String? publishedDate;
  final String? content;
  final int? postId;
  var zone;
  final UserModel? user;
  RxInt? likeCount;
  RxInt? commentCount;
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
  ScrollController? imageScrollController;





  @override
  Widget build(BuildContext context) {
    imageScrollController = ScrollController();
    return Container(
        color: Get.theme.primaryColor,

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
                          width: Get.width*0.81,
                          child: Row(
                            //crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: Get.width*0.45,
                                child: GestureDetector(
                                  onTap: () async {
                                    if(isCommunityPage == true){
                                      Get.toNamed(Routes.OTHER_USER_PROFILE, arguments: {'userId':user?.userId});
                                    };

                                  },
                                  child: Text('${user?.firstName![0].toUpperCase()}${user?.firstName!.substring(1).toLowerCase()} ${user?.lastName![0].toUpperCase()}${user?.lastName!.substring(1).toLowerCase()}',
                                      overflow:TextOverflow.ellipsis ,
                                      style: Get.textTheme.titleSmall),
                                ),
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
                              const FaIcon(FontAwesomeIcons.locationDot, size: 15,).marginOnly(right: 10),
                              SizedBox(
                                  //width: Get.width/4,
                                  child: Text(zone.toString(), style: Get.textTheme.bodySmall, overflow: TextOverflow.ellipsis,).marginOnly(right: 10),),
                              const FaIcon(FontAwesomeIcons.solidCircle, size: 5,).marginOnly(right: 10),
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
              ).paddingSymmetric(horizontal: 10),

        ReadMoreText(
            content == null? '':content?.replaceAllMapped(RegExp(r'<p>|<\/p>'), (match) {
              return match.group(0) == '</p>' ? '\n' : ''; // Replace </p> with \n and remove <p>
            })
                .replaceAll(RegExp(r'^\s*\n', multiLine: false), ''), // Remove empty lines),
            maxLines: 2,
            trimMode: TrimMode.line,
            textStyle: Get.textTheme.displayMedium!).paddingSymmetric(horizontal: 10)
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
                      controller: imageScrollController,
                      scrollDirection: Axis.horizontal,
                      itemCount: images?.length,
                      itemBuilder: (context, index) {
                        return Stack(
                          children: [
                            GestureDetector(
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
                              ),
                            ),
                            Positioned(
                              top: 375/2.2,
                              child: SizedBox(
                                width: Get.width,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  //crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    if(index > 0)...[
                                      GestureDetector(
                                        child: Icon(Icons.arrow_back_ios_outlined,),
                                        onTap: (){
                                          imageScrollController!.jumpTo(imageScrollController!.position.pixels - Get.width);

                                        },
                                      )
                                    ],
                                    Spacer(),
                                    if(index < images!.length-1)...[
                                      GestureDetector(
                                        child: Icon(Icons.arrow_forward_ios_outlined,),
                                        onTap: (){
                                          imageScrollController!.jumpTo(imageScrollController!.position.pixels + Get.width);
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            )



                          ],
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
              ).marginOnly(top: 5, bottom: 5),).paddingSymmetric(horizontal: 10),

              const Divider(
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
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
                        Image.asset(
                          'assets/icons/comment.png',
                          //fit: BoxFit.cover,
                          // width: 150,
                          // height: 130,

                        ),
                        Text(AppLocalizations.of(context).comment_verb)
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onSharedTapped,
                    child: Column(
                      children:[
                        Image.asset(
                          'assets/icons/share.png',
                          //fit: BoxFit.cover,
                          //  width: 150,
                          //  height: 130,

                        ),
                        Text(AppLocalizations.of(context).share_verb),
                      ],
                    ),
                  ),
                ],

              ).paddingSymmetric(horizontal: 10),

            ]
        ).paddingSymmetric( vertical: 10)
    );
  }

}