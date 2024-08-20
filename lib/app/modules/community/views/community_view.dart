import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/community/controllers/community_controller.dart';
import 'package:mapnrank/app/modules/community/widgets/buildSelectSector.dart';
import 'package:mapnrank/app/modules/community/widgets/buildSelectZone.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_loading_widget.dart';
import 'package:mapnrank/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:mapnrank/app/modules/global_widgets/block_button_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/loading_cards.dart';
import 'package:mapnrank/app/modules/global_widgets/post_card_widget.dart';
import 'package:mapnrank/app/modules/global_widgets/text_field_widget.dart';
import 'package:mapnrank/app/routes/app_routes.dart';
import '../../../../color_constants.dart';
import '../../../../common/helper.dart';
import '../../../../common/ui.dart';
import '../../../models/post_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/global_services.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../events/controllers/events_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>PostCardWidget(likeWidget: null,));
    return  WillPopScope(
      onWillPop: Helper().onWillPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: interfaceColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            onPressed: (){
            controller.rating.value =0;
            controller.feedbackController.clear();
            showModalBottomSheet(

              enableDrag: true,
              isScrollControlled: true,
              context: context,
              builder: (context) => Container(
                height: Get.height*0.7,
                child: ListView(
                  padding: EdgeInsets.all(20),
                  children: [
                    Text(AppLocalizations.of(context).send_via_whatsapp, style: TextStyle(fontSize: 16),).marginOnly(top: 20, bottom: 10),
                    SizedBox(
                      width: Get.width,
                      height: 70,
                      child: TextFormField(
                        controller: controller.feedbackController,
                        maxLines: 80,
                        decoration: InputDecoration(
                            hintText: AppLocalizations.of(context).enter_feedback_here,
                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),
                          focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),

                        ),
                        onChanged: (value) {
                          controller.feedbackController.text = value;
                        },

                      ),
                    ).marginOnly(bottom: 20),
                    RichText(text: TextSpan(
                      children: [
                        WidgetSpan(child:Text(AppLocalizations.of(context).input_image, style: TextStyle(fontSize: 16),),),
                        WidgetSpan(child:Text('  (${AppLocalizations.of(context).optional})', style: TextStyle(fontSize: 12, color: Colors.grey),),),

                      ]
                    )).marginOnly(bottom: 20),
                    Row(
                      children: [
                        Obx(() {
                          if(!controller.loadFeedbackImage.value) {
                            return buildLoader();
                          } else {
                            return controller.feedbackImage !=null? ClipRRect(
                              borderRadius: const BorderRadius.all(Radius.circular(10)),
                              child: Image.file(
                                controller.feedbackImage,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ):
                            buildLoader();
                          }
                        }
                        ),
                        const SizedBox(width: 10),
                        GestureDetector(
                          onTap: () async {

                            await controller.selectCameraOrGalleryFeedbackImage();
                            controller.loadFeedbackImage.value = false;

                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Get.theme.focusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                            child: Icon(Icons.add_photo_alternate_outlined, size: 42, color: Get.theme.focusColor.withOpacity(0.4)),
                          ),
                        )
                      ],
                    ).marginOnly(bottom: 20, left: 20),
                    Text(AppLocalizations.of(context).rate_us, style: TextStyle(fontSize: 16)).marginOnly(top: 10, bottom: 10),
                    Obx(() {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: List.generate(5, (index) {
                          return InkWell(
                            onTap: () {
                              controller.rating.value = (index + 1).toInt();
                            },
                            child: index < controller.rating.value
                                ? Icon(Icons.star, size: 50, color: Color(0xFFFFB24D))
                                : Icon(Icons.star_border, size: 50, color: Color(0xFFFFB24D)),
                          );
                        }),
                      );
                    }).marginOnly(bottom: Get.height/10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: Get.width,
                          child: BlockButtonWidget(color: interfaceColor,
                              text: Text(AppLocalizations.of(context).submit, style: TextStyle(color: Colors.white),),
                              onPressed: () async{
                            if(controller.feedbackController.text.isNotEmpty){
                              if(controller.rating.value != 0){
                                await controller.sendFeedback();
                                Navigator.of(context).pop();
                              }
                              else{
                                Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).please_rate_us));
                              }

                            }
                            else{
                              Get.showSnackbar(Ui.warningSnackBar(message: AppLocalizations.of(context).please_write_feedback));
                            }

                              } ),
                        ),
                        SizedBox(height: 10,),
                        Container(
                          width: Get.width,
                          decoration:BoxDecoration(
                            border: Border.all(color: interfaceColor),
                            borderRadius: BorderRadius.circular(20),

                          ),
                          //width: Get.width/2,
                          child: MaterialButton(
                            onPressed: (){
                              if(controller.feedbackController.text.isNotEmpty){
                                controller.launchWhatsApp(controller.feedbackController.text);
                              }
                              else{
                                Get.showSnackbar(Ui.warningSnackBar(message: 'Please write a feedback'));
                              }

                            },
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                            color: Colors.white,
                            disabledElevation: 0,
                            disabledColor: Get.theme.focusColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            child: Wrap(
                              children: [
                                Icon(FontAwesomeIcons.whatsapp, color: interfaceColor,),
                                SizedBox(width: 10,),
                                Text(AppLocalizations.of(context).send_via_whatsapp)
                              ],
                            ),
                            elevation: 0,
                          ),
                        )


                      ],
                    ),
                  ],
                ),
              ),);

        },
            heroTag: null,
            label: Text(AppLocalizations.of(context).contact_us)),
        body: RefreshIndicator(
          onRefresh: () async {
            await controller.refreshCommunity(showMessage: true);
            controller.onInit();
          },
          child:  Container(
            color: backgroundColor,
            height: Get.height,
            child: Obx(() => CustomScrollView(
              controller: controller.scrollbarController,
              //primary: true,
              shrinkWrap: false,
              slivers: <Widget>[
                
                SliverAppBar(
                  titleSpacing: 0,
                  systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.white),
                  //expandedHeight: 80,
                  backgroundColor: Colors.white,
                  leadingWidth: 0,
                  floating: true,
                  toolbarHeight: 190,
                  leading: Icon(null),
                  centerTitle: true,
                  title: Container(
                    //margin: EdgeInsets.only(bottom: 20),
                    color: Colors.white,
                    child:
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: (){
                              Scaffold.of(context).openDrawer();
                            },
                            child: Image.asset(
                                "assets/images/logo.png",
                                width: Get.width/6,
                                height: Get.width/6,
                                fit: BoxFit.fitWidth),
                          ).marginOnly(left: 10),
                          Container(
                           height: 40,
                            width: Get.width/1.6,
                            decoration: BoxDecoration(
                              color: backgroundColor,
                              borderRadius: BorderRadius.circular(10)

                            ),
                            child: TextFormField(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:BorderSide.none,),
                              hintText: AppLocalizations.of(context).search_subdivision,
                              hintStyle: TextStyle(fontSize: 14),
                              prefixIcon: Icon(FontAwesomeIcons.search, color: Colors.grey, size: 15,),
                            ),
                                                      ),
                          ),
                          ClipOval(
                              child: GestureDetector(
                                onTap: () async {

                                    await Get.toNamed(Routes.PROFILE);
                                },
                                child: FadeInImage(
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                  image:  NetworkImage(controller.currentUser.value!.avatarUrl!, headers: GlobalService.getTokenHeaders()),
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
                                ),
                              )
                          ).marginOnly(right: 10),
                        ],
                      )
                  ),

                  bottom: PreferredSize(
                    preferredSize: Size(Get.width, 120),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color:backgroundColor,
                          ),
                          padding: EdgeInsets.only(top: 10),
                          child: Container(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 10),
                            //margin:EdgeInsets.all(10),
                            height: 150,
                            decoration: BoxDecoration(
                                color: Colors.white
                              //border: Border(bottom: BorderSide(color: interfaceColor))
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    ClipOval(
                                        child: FadeInImage(
                                          width: 30,
                                          height: 30,
                                          fit: BoxFit.cover,
                                          image:  NetworkImage(controller.currentUser.value!.avatarUrl!, headers: GlobalService.getTokenHeaders()),
                                          placeholder: const AssetImage(
                                              "assets/images/loading.gif"),
                                          imageErrorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                                "assets/images/user_admin.png",
                                                width: 30,
                                                height: 30,
                                                fit: BoxFit.fitWidth);
                                          },
                                        )
                                    ),
                                    SizedBox(width: 10,),
                                    SizedBox(
                                      width: Get.width*0.79,
                                      height: 50,
                                      child: TextFormField(
                                        maxLines: 80,
                                        decoration: InputDecoration(
                                          hintText: AppLocalizations.of(context).input_placeholder,
                                          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),
                                          focusedBorder:  OutlineInputBorder(borderRadius: BorderRadius.circular(25), borderSide: BorderSide(width: 0.4, color: Colors.grey,)),

                                        ),
                                        onChanged: (value) {
                                          controller.postContentController.text = value;
                                        },

                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 20,),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: Get.width/2.3,
                                      child: BlockButtonWidget(color: interfaceColor, text: Text(AppLocalizations.of(context).post,
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          onPressed: (){
                                            controller.noFilter.value = true;
                                            controller.chooseARegion.value = false;
                                            controller.chooseADivision.value = false;
                                            controller.chooseASubDivision.value = false;
                                            if(controller.post?.sectors != null){
                                              controller.post?.sectors!.clear();
                                              controller.emptyArrays();
                                            }

                                            Get.toNamed(Routes.CREATE_POST);

                                          }),
                                    ),
                                    Spacer(),
                                    SizedBox(
                                      width: Get.width/2.3,
                                      child: BlockButtonWidget(color: interfaceColor, text: Text(AppLocalizations.of(context).create_event,
                                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                          onPressed: (){
                                            Get.find<EventsController>().noFilter.value = true;
                                            Get.find<EventsController>().chooseARegion.value = false;
                                            Get.find<EventsController>().chooseADivision.value = false;
                                            Get.find<EventsController>().chooseASubDivision.value = false;

                                            if(Get.find<EventsController>().event?.sectors != null){
                                              Get.find<EventsController>().event?.sectors!.clear();
                                              Get.find<EventsController>().emptyArrays();
                                            }
                                            Get.toNamed(Routes.CREATE_EVENT);

                                          }),
                                    )
                                  ],
                                )


                              ],),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: backgroundColor,
                            //border: Border(bottom: BorderSide(color: interfaceColor))
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 20, 5, 15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: <BoxShadow>[BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 20.0,
                                          offset: Offset(1, 1)
                                      )]
                                  ),
                                  child: TextButton.icon(
                                    icon: Image.asset(
                                        "assets/images/filter.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.fitWidth) ,
                                    label: Text(AppLocalizations.of(context).filter_by_location, style: TextStyle(color: Colors.black),),
                                    onPressed: () {

                                      controller.noFilter.value = false;

                                      showModalBottomSheet(
                                        //isScrollControlled: true,
                                        context: context,

                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                        builder: (context) {
                                          return Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))

                                              ),
                                              child: BuildSelectZone()
                                          );
                                        },
                                      );

                                    },),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(5, 20, 5, 15),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      boxShadow: <BoxShadow>[BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 20.0,
                                          offset: Offset(1, 1)
                                      )],
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: TextButton.icon(
                                    icon: Image.asset(
                                        "assets/images/filter.png",
                                        width: 20,
                                        height: 20,
                                        fit: BoxFit.fitWidth) ,
                                    label: Text(AppLocalizations.of(context).filter_by_sector, style: TextStyle(color: Colors.black)),
                                    onPressed: () {

                                      controller.noFilter.value = false;
                                      showModalBottomSheet(context: context,

                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                        builder: (context) {
                                          return Container(
                                              padding: const EdgeInsets.all(20),
                                              decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))

                                              ),
                                              child: BuildSelectSector()
                                          );
                                        },
                                      );

                                    },),
                                ),
                              ),


                            ],),
                        ),
                      ],
                    )

                  ),

                ),


                SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return controller.loadingPosts.value?
                      const LoadingCardWidget()
                          :controller.allPosts.isNotEmpty?
                      Obx(() => PostCardWidget(
                        //likeTapped: RxBool(controller.allPosts[index].likeTapped),
                        content: controller.allPosts[index].content == false?'':controller.allPosts[index].content,
                        zone: controller.allPosts[index].zone != null?controller.allPosts[index].zone['name']: '',
                        publishedDate: controller.allPosts[index].publishedDate,
                        postId: controller.allPosts[index].postId,
                        images: controller.allPosts[index].imagesUrl,
                        user: UserModel(
                            firstName: controller.allPosts[index].user.firstName,
                            lastName: controller.allPosts[index].user.lastName,
                            avatarUrl: controller.allPosts[index].user.avatarUrl
                        ),
                        commentCount: controller.allPosts[index].commentCount,
                        shareCount: RxInt(controller.allPosts[index].shareCount),
                        likeCount: RxInt(controller.allPosts[index].likeTapped.value && controller.postSelectedIndex.value == index ?
                        ++controller.allPosts[index].likeCount:
                        !controller.allPosts[index].likeTapped.value  && controller.postSelectedIndex.value == index?
                        --controller.allPosts[index].likeCount:
                        controller.allPosts[index].likeCount,),

                        likeWidget:  Obx(() =>
                        controller.allPosts[index].likeTapped.value && controller.postSelectedIndex.value == index?
                        const FaIcon(FontAwesomeIcons.solidHeart, color: interfaceColor,):
                        !controller.allPosts[index].likeTapped.value  && controller.postSelectedIndex.value == index?
                        const FaIcon(FontAwesomeIcons.heart,):
                        controller.allPosts[index].likeTapped.value ?
                        const FaIcon(FontAwesomeIcons.solidHeart, color: interfaceColor,):
                        const FaIcon(FontAwesomeIcons.heart,)

                          ,),
                        onLikeTapped: (){
                          controller.postSelectedIndex.value = index.toDouble();

                          if(controller.allPosts[index].likeTapped.value){
                            controller.allPosts[index].likeTapped.value = !controller.allPosts[index].likeTapped.value;
                              controller.likeUnlikePost(controller.allPosts[index].postId, index);
                            }
                          else{
                            controller.allPosts[index].likeTapped.value = !controller.allPosts[index].likeTapped.value;
                            controller.likeUnlikePost(controller.allPosts[index].postId, index);
                          }


                        },
                        onCommentTapped: () async{
                          controller.likeTapped.value = false;
                          Get.toNamed(Routes.COMMENT_VIEW);
                           await controller.getAPost(controller.allPosts[index].postId);
                          controller.commentList.value = controller.postDetails.value.commentList!;
                          controller.likeCount!.value = controller.allPosts.where((element)=>element.postId == controller.postDetails.value.postId).toList()[0].likeCount;


                        },
                        onPictureTapped: () async{
                          var post = controller.allPosts[index];
                          controller.initializePostDetails(post);
                          controller.likeCount!.value = controller.allPosts.where((element)=>element.postId == controller.postDetails.value.postId).toList()[0].likeCount;
                          Get.toNamed(Routes.DETAILS_VIEW);

                        },
                        onSharedTapped: ()async{
                          await controller.sharePost(controller.allPosts[index].postId);
                        },
                        isCommunityPage: true,
                        followWidget:Obx(() => !controller.allPosts[index].isFollowing.value?
                        GestureDetector(
                            onTap: (){

                                controller.postFollowedIndex.value = index;
                                controller.allPosts[index].isFollowing.value = !controller.allPosts[index].isFollowing.value;
                                controller.followUser(controller.allPosts[index].user.userId, index);


                            },
                            child: Text('+ ${AppLocalizations.of(context).follow}',style:Get.textTheme.displaySmall,)):
                        GestureDetector(
                            onTap: (){
                              controller.postSelectedIndex.value = index.toDouble();
                              controller.allPosts[index].isFollowing.value = !controller.allPosts[index].isFollowing.value;
                              controller.unfollowUser(controller.allPosts[index].user.userId, index);
                              //}
                            },
                            child: Text(AppLocalizations.of(context).following, style: Get.textTheme.displaySmall,textAlign: TextAlign.end,)
                        ),),
                        popUpWidget: SizedBox(),

                        liked: controller.allPosts[index].liked,
                      ))
                          :Center(
                        child: SizedBox(
                          height: Get.height/2,
                          child: Column(
                            //mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FaIcon(FontAwesomeIcons.folderOpen, size: 30,),
                              Text(AppLocalizations.of(context).no_posts_found)
                            ],
                          ),
                        ),

                      );
                    },
                        childCount: controller.allPosts.length
                    )),

                SliverList(
                    delegate: SliverChildListDelegate([
                       !controller.loadingPosts.value?
                       controller.allPosts.isEmpty?
                    Center(
                    child: SizedBox(
                    //height: Get.height/2,
                    child: Column(
                    //mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children:  [
                      SizedBox(height: Get.height/4),
                    FaIcon(FontAwesomeIcons.folderOpen, size: 30,),
                  Text(AppLocalizations.of(context).no_posts_found)
                  ],
                ),
            ),

          ):controller.page >0?
                       Center(
                        child: CircularProgressIndicator(color: interfaceColor, ),
                      ):SizedBox(): LoadingCardWidget()

                    ]))


              ],

            )),
          ),

        ),

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
            'assets/images/loading.gif',
            fit: BoxFit.cover,
            width: double.infinity,
            height: 100,
          ),
        ));
  }

}
