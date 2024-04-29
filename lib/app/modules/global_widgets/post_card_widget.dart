import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/services/global_services.dart';
import '../../../color_constants.dart';


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
     this.images
  }) : super(key: key);

  final List? sectors;
  final String? publishedDate;
  final String? content;
  final int? postId;
  var zone;
  final User? user;
  final int? likeCount;
  final int? commentCount;
  final int? shareCount;
  final List? images;


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
                height: 80,
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
                        Text('${user?.firstName} ${user?.lastName}', style: const TextStyle(fontSize: 12, color: appColor, overflow: TextOverflow.ellipsis)).marginOnly(bottom: 10),
                        Expanded(
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const FaIcon(FontAwesomeIcons.locationDot).marginOnly(right: 10),
                                  Text(zone.toString()).marginOnly(right: 10),
                                  const FaIcon(FontAwesomeIcons.solidCircle, size: 10,).marginOnly(right: 10),
                                  SizedBox(
                                    width: 100,
                                      child: Text(publishedDate!, style: Get.textTheme.headline1!.merge(const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: appColor, ),))),

                                  //Text("⭐️ ${this.rating}", style: TextStyle(fontSize: 13, color: appColor))
                                ]
                            )
                        ),
                      ],
                    )


                  ],
                ),
              ),
              Text(content!),
              if(images!.isNotEmpty)...[
                ClipRect(
                  child: FadeInImage(
                    width: Get.width,
                    height: Get.height/4,
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
                  ),
                ),
              ],


              Row(
                children: [
                  const FaIcon(FontAwesomeIcons.heart),
                  const SizedBox(width: 10,),
                  if(likeCount! <= 1)...[
                    Text('${likeCount!}like'),
                  ]
                  else...[
                    Text('${likeCount!}likes'),
                  ],


                  const Spacer(),
                  if(commentCount! <= 1)...[
                    Text(' ${commentCount!} Comment'),
                  ]
                  else...[
                    Text(' ${commentCount!} Comments'),
                  ],
                  if(shareCount! <= 1)...[
                    Text(' . ${shareCount!} Share'),
                  ]
                  else...[
                    Text(' . ${shareCount!} Shares'),
                  ],




                ],
              ).marginSymmetric(vertical: 20),


              const Divider(
                color: Colors.grey,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: const [
                      FaIcon(FontAwesomeIcons.heart),
                      Text('Like')
                    ],
                  ),
                  Column(
                    children: const [
                      FaIcon(FontAwesomeIcons.comment),
                      Text('Comment')
                    ],
                  ),
                  Column(
                    children: const [
                      FaIcon(FontAwesomeIcons.shareFromSquare),
                      Text('Share'),
                    ],
                  ),

                  


                ],
                
              )




            ]
        ).paddingSymmetric(horizontal: 10, vertical: 10)
    );
  }
}