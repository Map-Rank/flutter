import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/services/global_services.dart';
import '../../../color_constants.dart';
import '../community/controllers/community_controller.dart';
import '../community/widgets/comment_widget.dart';


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
    this.likeWidget,
    this.onActionTapped,
    this.popUpWidget
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
  RxBool? likeTapped;
  var commentTapped;
  var shareTapped;
  Widget? likeWidget;
  Widget? popUpWidget;




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
                                image:  NetworkImage(user!.avatarUrl!, headers: {}),
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
                            image:  NetworkImage(user!.avatarUrl!, headers: {}),
                            placeholder: const AssetImage(
                                "assets/images/loading.gif"),
                            imageErrorBuilder:
                                (context, error, stackTrace) {
                              return Image.asset(
                                  "assets/images/téléchargement (3).png",
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.fitWidth);
                            },
                          )
                      ),
                    ),
                    const SizedBox(width: 20,),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user?.firstName![0].toUpperCase()}${user?.firstName!.substring(1).toLowerCase()} ${user?.lastName![0].toUpperCase()}${user?.lastName!.substring(1).toLowerCase()}',overflow:TextOverflow.ellipsis , style: Get.textTheme.headline6).marginOnly(bottom: 10),
                        Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const FaIcon(FontAwesomeIcons.locationDot, size: 10,).marginOnly(right: 10),
                                SizedBox(
                                    width: Get.width/4,
                                    child: Text(zone.toString(), style: Get.textTheme.bodyText1).marginOnly(right: 10)),
                                const FaIcon(FontAwesomeIcons.solidCircle, size: 10,).marginOnly(right: 10),
                                SizedBox(
                                    width: Get.width/4,
                                    child: Text(publishedDate!, style: Get.textTheme.bodyText1)),


                                //Text("⭐️ ${this.rating}", style: TextStyle(fontSize: 13, color: appColor))
                              ],
                            )
                        ),
                      ],
                    ),
                    const Spacer(),

                    popUpWidget!,


                  ],


                ),
              ),
              Text(content!).marginOnly(bottom: 20),
              if(images!.isNotEmpty)...[
                if( images!.length == 1)...[
                  GestureDetector(
                    onTap: onPictureTapped,
                    child: ClipRect(
                        child: FadeInImage(
                          width: Get.width,
                          height: Get.height/3,
                          fit: BoxFit.cover,
                          image:  NetworkImage('${GlobalService().baseUrl}'
                              '${images![0]['url'].substring(1,images![0]['url'].length)}',
                              headers: GlobalService.getTokenHeaders()
                          ),
                          placeholder: const AssetImage(
                              "assets/images/loading.gif"),
                          imageErrorBuilder:
                              (context, error, stackTrace) {
                            return Image.asset(
                                "assets/images/loading.gif",
                                width: Get.width,
                                height: Get.height/4,
                                fit: BoxFit.fitWidth);
                          },
                        )

                    ),
                  )
                ]
                else...[
                  SizedBox(
                    height: Get.height/4,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: images?.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: onPictureTapped,
                          child: FadeInImage(
                            width: Get.width-50,
                            height: Get.height/4,
                            fit: BoxFit.cover,
                            image:  NetworkImage('${GlobalService().baseUrl}'
                                '${images![index]['url'].substring(1,images![index]['url'].length)}',
                                headers: GlobalService.getTokenHeaders()
                            ),
                            placeholder: const AssetImage(
                                "assets/images/loading.gif"),
                            imageErrorBuilder:
                                (context, error, stackTrace) {
                              return Image.asset(
                                  "assets/images/loading.gif",
                                  width: Get.width,
                                  height: Get.height/4,
                                  fit: BoxFit.fitWidth);
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
                  Obx(() => FaIcon(FontAwesomeIcons.heart, color: likeCount!.value>0! ? interfaceColor: null),),
                  const SizedBox(width: 10,),
                  if(likeCount!.value <= 1)...[
                    Obx(() => Text('${likeCount!.value} like'),)
                  ]
                  else...[
                    Obx(() => Text('${likeCount!.value} likes'),)
                  ],


                  const Spacer(),
                  if(commentCount! <= 1)...[
                    Text(' ${commentCount!} Comment'),
                  ]
                  else...[
                    Text(' ${commentCount!} Comments'),
                  ],
                  if(shareCount! <= 1)...[
                    Obx(() =>  Text(' . ${shareCount!} Share'),),

                  ]
                  else...[
                    Obx(() =>Text(' . ${shareCount!} Shares'), )

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

                        const Text('Like')
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onCommentTapped,
                    child: Column(
                      children: const [
                        FaIcon(FontAwesomeIcons.comment),
                        Text('Comment')
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: onSharedTapped,
                    child: Column(
                      children: const [
                        FaIcon(FontAwesomeIcons.shareFromSquare, key: Key('shareIcon'),),
                        Text('Share'),
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