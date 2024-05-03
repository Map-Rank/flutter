import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/providers/laravel_provider.dart';
import 'package:mapnrank/app/repositories/community_repository.dart';
import 'package:mapnrank/app/repositories/sector_repository.dart';
import 'package:mapnrank/app/repositories/user_repository.dart';
import 'package:mapnrank/app/repositories/zone_repository.dart';
import 'package:mapnrank/common/ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as Im;
import 'dart:math' as Math;


import '../../../models/post_model.dart';
import '../../global_widgets/post_card_widget.dart';




class CommunityController extends GetxController {


  var floatingActionButtonTapped = false.obs;
  late CommunityRepository communityRepository ;
  var allPosts = [].obs;
  var loadingPosts = true.obs;
  var createPosts = false.obs;
  late Post post;
  Post postDetails = Post();

  var loadingRegions = true.obs;
  var regions = [].obs;
  var regionSelected = false.obs;
  var regionSelectedIndex = 0.obs;
  var listRegions = [].obs;
  var regionsSet ={};
  var regionSelectedValue = [].obs;

  var loadingDivisions = true.obs;
  var divisions = [].obs;
  var divisionSelected = false.obs;
  var divisionSelectedValue = [].obs;
  var divisionSelectedIndex = 0.obs;
  var listDivisions = [].obs;
  var divisionsSet ={};

  var loadingSubdivisions = true.obs;
  var subdivisions = [].obs;
  var subdivisionSelected = false.obs;
  var subdivisionSelectedValue = [].obs;
  var subdivisionSelectedIndex = 0.obs;
  var listSubdivisions = [].obs;
  var subdivisionsSet ={};

  var loadingSectors = true.obs;
  var sectors = [].obs;
  var sectorsSelected = [].obs;
  var selectedIndex = 0.obs;
  var listSectors = [].obs;
  var sectorsSet ={};

  RxBool registerNextStep1 = false.obs;

  late UserRepository userRepository ;
  late ZoneRepository zoneRepository ;
  late SectorRepository sectorRepository ;

  late Post postModel;

  late ScrollController scrollbarController;

  var imageFiles = [].obs;

  RxBool likeTapped = false.obs;

  var selectedPost = [].obs;

  var postSelectedIndex = 0.obs;

  var comment = ''.obs;

  var commentList = [].obs;

  CommunityController() {

  }

  @override
  void onInit() async {
    communityRepository = CommunityRepository();
    userRepository = UserRepository();
    zoneRepository = ZoneRepository();
    sectorRepository = SectorRepository();

    scrollbarController = ScrollController()..addListener(_scrollListener);

    await getAllPosts();

    var box = GetStorage();

    var boxRegions = box.read("allRegions");

    if(boxRegions == null){
      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
        content: Text('Loading Regions...'),
        duration: Duration(seconds: 3),
      ));

      regionsSet = await getAllRegions();
      listRegions.value = regionsSet['data'];
      loadingRegions.value = !regionsSet['status'];
      regions.value = listRegions;

      box.write("allRegions", regionsSet);

    }
    else{

      listRegions.value = boxRegions['data'];
      loadingRegions.value = !boxRegions['status'];
      regions.value = listRegions;


    }

    var boxSectors = box.read("allSectors");

    if(boxSectors == null){

      ScaffoldMessenger.of(Get.context!).showSnackBar(const SnackBar(
        content: Text('Loading Sectors...'),
        duration: Duration(seconds: 3),
      ));

      sectorsSet = await getAllSectors();
      listSectors.value = sectorsSet['data'];
      loadingSectors.value = !sectorsSet['status'];
      sectors.value = listSectors;

      box.write("allSectors", sectorsSet);

    }
    else{
      listSectors.value = boxSectors['data'];
      loadingSectors.value = !boxSectors['status'];
      sectors.value = listSectors;


    }

    super.onInit();
  }

  Future refreshCommunity({bool showMessage = false}) async {
    await getAllPosts();
  }

  void _scrollListener() {
    print(scrollbarController.position.extentAfter);
    if (scrollbarController.position.extentAfter < 10) {
        allPosts.addAll(List.generate(5, (index) => 'Inserted $index'));
    }
  }

  getAllPosts()async{
    allPosts.clear();
    try{
      var list = await communityRepository.getAllPosts();
      print(list);
      for( var i = 0; i< list.length; i++){
        User user = User(userId: list[i]['creator'][0]['id'],
            lastName:list[i]['creator'][0]['last_name'],
            firstName: list[i]['creator'][0]['first_name'],
            avatarUrl: list[i]['creator'][0]['avatar']
        );
        post = Post(
            zone: list[i]['zone'],
            postId: list[i]['id'],
            commentCount:list[i] ['comment_count'],
            likeCount:list[i] ['like_count'] ,
            shareCount:list[i] ['share_count'],
            content: list[i]['content'],
            publishedDate: list[i]['published_at'],
            imagesUrl: list[i]['images'],
            user: user,
            liked: list[i]['liked'],
            likeTapped: list[i]['liked'],

        );

        //print(User.fromJson(list[i]['creator']));
        allPosts.add(post);
      }

    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      loadingPosts.value = false;
    }

  }

  getAllRegions() async{
    return zoneRepository.getAllRegions(2, 1);
  }

  void filterSearchRegions(String query) {
    List dummySearchList = [];
    dummySearchList = listRegions;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['name']
          .toString().toLowerCase().contains(query.toLowerCase())).toList();
      regions.value = dummyListData;
      return;
    } else {
      regions.value = listRegions;
    }
  }

  getAllDivisions(int index) async{
    return zoneRepository.getAllDivisions(3, regions[index]['id']);

  }

  void filterSearchDivisions(String query) {
    List dummySearchList = [];
    dummySearchList = listDivisions;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['name']
          .toString().toLowerCase().contains(query.toLowerCase())).toList();
      divisions.value = dummyListData;
      return;
    } else {
      divisions.value = listDivisions;
    }
  }

  getAllSubdivisions(int index) async{
    return zoneRepository.getAllSubdivisions(4, divisions[index]['id']);

  }

  void filterSearchSubdivisions(String query) {
    List dummySearchList = [];
    dummySearchList = listSubdivisions;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['name']
          .toString().toLowerCase().contains(query.toLowerCase())).toList();
      subdivisions.value = dummyListData;
      return;
    } else {
      subdivisions.value = listSubdivisions;
    }
  }


  void filterSearchSectors(String query) {
    List dummySearchList = [];
    dummySearchList = listSectors;
    if(query.isNotEmpty) {
      List dummyListData = [];
      dummyListData = dummySearchList.where((element) => element['name']
          .toString().toLowerCase().contains(query.toLowerCase())).toList();
      sectors.value = dummyListData;
      return;
    } else {
      sectors.value = listSectors;
    }
  }
  getAllSectors() async{
    return sectorRepository.getAllSectors();
  }

  Future  pickImage(ImageSource source) async {

    ImagePicker imagePicker = ImagePicker();

    if(source.toString() == ImageSource.camera.toString())
    {
      var compressedImage;
      XFile? pickedFile = await imagePicker.pickImage(source: source, imageQuality: 80);
      File imageFile = File(pickedFile!.path);
      if(imageFile.lengthSync()>pow(1024, 2)){
        final tempDir = await getTemporaryDirectory();
        final path = tempDir.path;
        int rand = Math.Random().nextInt(10000);
        Im.Image? image1 = Im.decodeImage(imageFile.readAsBytesSync());
        compressedImage = File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1!, quality: 25));


      }
      else{

        compressedImage = File(pickedFile.path);

      }

        imageFiles.add(compressedImage) ;
      post.imagesFilePaths = imageFiles;

    }
    else{
      var compressedImage;
      var i =0;
      var galleryFiles = await imagePicker.pickMultiImage();

      while(i<galleryFiles.length){
        File imageFile = File(galleryFiles[i].path);
        if(imageFile.lengthSync()>pow(1024, 2)){
          final tempDir = await getTemporaryDirectory();
          final path = tempDir.path;
          int rand = Math.Random().nextInt(10000);
          Im.Image? image1 = Im.decodeImage(imageFile.readAsBytesSync());
          compressedImage =  File('${path}/img_$rand.jpg')..writeAsBytesSync(Im.encodeJpg(image1!, quality: 25));


        }
        else{

          compressedImage = File(galleryFiles[i].path);

        }


        imageFiles.add(compressedImage) ;
        post.imagesFilePaths = imageFiles;


        i++;
      }
    }
  }

  createPost(Post post)async{
    try{
      await communityRepository.createPost(post);
      Get.showSnackbar(Ui.SuccessSnackBar(message: 'Post created successfully' ));
      await getAllPosts();

    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      createPosts.value = true;
    }

  }

  likeUnlikePost(int postId)async{
    try{
      //await communityRepository.likeUnlikePost(postId);

    }
    catch (e) {
      likeTapped.value = !likeTapped.value;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {

    }

  }

  getAPost(int postId)async{
    try{
      var result= await communityRepository.getAPost(postId);
      print("Result is : ${result}");
      User user = User(userId: result['creator'][0]['id'],
          lastName:result['creator'][0]['last_name'],
          firstName: result['creator'][0]['first_name'],
          avatarUrl: result['creator'][0]['avatar']
      );
      Post postModel = Post(
        zone: result['zone'],
        postId: result['id'],
        commentCount:result ['comment_count'],
        likeCount:result ['like_count'] ,
        shareCount:result ['share_count'],
        content: result['content'],
        publishedDate: result['published_at'],
        imagesUrl: result['images'],
        user: user,
        liked: result['liked'],
        likeTapped: result['liked'],
        commentList: result['comments']

      );
      return postModel;

    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {

    }

  }

  commentPost(int postId, String comment)async{
    try{
      var result= await communityRepository.commentPost(postId, comment);
      print("Result is : ${result}");
      User user = User(userId: result['creator'][0]['id'],
          lastName:result['creator'][0]['last_name'],
          firstName: result['creator'][0]['first_name'],
          avatarUrl: result['creator'][0]['avatar']
      );
      Post postModel = Post(
          zone: result['zone'],
          postId: result['id'],
          commentCount:result ['comment_count'],
          likeCount:result ['like_count'] ,
          shareCount:result ['share_count'],
          content: result['content'],
          publishedDate: result['published_at'],
          imagesUrl: result['images'],
          user: user,
          liked: result['liked'],
          likeTapped: result['liked'],
          commentList: result['comments']

      );
      return postModel;

    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {

    }

  }

  sharePost(int postId)async{
    try{
      await communityRepository.sharePost(postId);
      showDialog(context: Get.context!,
          barrierDismissible: true,
          builder: (context) {
        return Center(
          child: Container(
            height: Get.height/2.5,
            width: Get.width-20,
            padding: EdgeInsets.all(20),
            color: Colors.white,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                  Expanded(child: Text('https://dev.residat.com/show-post/${postId}', style: TextStyle(color: Colors.grey, fontSize: 14),)),
                    GestureDetector(
                      onTap: () async{
                        await Clipboard.setData(ClipboardData(text: "your text"));
                      },
                        child: FaIcon(FontAwesomeIcons.copy))
                ],)

              ],
            ),
          ),
        );
          },
      );

    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {

    }

  }

}


