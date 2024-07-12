
import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/modules/community/widgets/comment_loading_widget.dart';
import 'package:mapnrank/app/repositories/community_repository.dart';
import 'package:mapnrank/app/repositories/sector_repository.dart';
import 'package:mapnrank/app/repositories/user_repository.dart';
import 'package:mapnrank/app/repositories/zone_repository.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mapnrank/common/ui.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as Im;
import 'package:share_plus/share_plus.dart';
import 'dart:math' as Math;
import '../../../models/post_model.dart';




class CommunityController extends GetxController {

  final Rx<UserModel> currentUser = Get.find<AuthService>().user;
  var floatingActionButtonTapped = false.obs;
  late CommunityRepository communityRepository ;
  var allPosts = [].obs;
  var listAllPosts = [];
  var loadingPosts = true.obs;
  var createPosts = false.obs;
  var createUpdatePosts = false.obs;
  var updatePosts = false.obs;
  var searchField = false.obs;
  var noFilter = true.obs;
  var createPostNotEvent = true.obs;
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

  var page = 0;

  RxBool registerNextStep1 = false.obs;

  late UserRepository userRepository ;
  late ZoneRepository zoneRepository ;
  late SectorRepository sectorRepository ;

  late Post postModel;

  late ScrollController scrollbarController;

  var imageFiles = [].obs;

  var likeTapped = false.obs;

  var selectedPost = [].obs;

  var sharedPost = [].obs;

  var postSelectedIndex = 0.obs;

  var postSharedIndex = 0.obs;

  var comment = ''.obs;
  var sendComment = false.obs;

  var commentList = [].obs;

  TextEditingController commentController = TextEditingController();

  RxInt? likeCount = 0.obs;
  RxInt? shareCount = 0.obs;
  RxInt? commentCount = 0.obs;

  var copyLink = false.obs;
  var chooseARegion = false.obs;
  var chooseADivision = false.obs;
  var chooseASubDivision = false.obs;

  var inputImage = false.obs;
  var inputSector = false.obs;
  var inputZone = false.obs;


  CommunityController() {

  }

  @override
  void onInit() async {
    super.onInit();

    post = Post();

    scrollbarController = ScrollController()..addListener(_scrollListener);
    communityRepository = CommunityRepository();
    userRepository = UserRepository();
    zoneRepository = ZoneRepository();
    sectorRepository = SectorRepository();



    listAllPosts = await getAllPosts(0);
    allPosts.value= listAllPosts;

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



  }


  @override
  void dispose() {
    scrollbarController.removeListener(_scrollListener);
    super.dispose();
  }

  refreshCommunity({bool showMessage = false}) async {
    loadingPosts.value = true;
    listAllPosts = await getAllPosts(0);
    allPosts.value= listAllPosts;
    emptyArrays();
  }

  void _scrollListener() async{
    print('extent is ${scrollbarController.position.extentAfter}');
    if (scrollbarController.position.extentAfter < 10) {
      var posts = await getAllPosts(page++);
        allPosts.addAll(posts);
      listAllPosts.addAll(posts);
    }
  }

  getAllPosts(int page)async{
    var postList = [];
    sharedPost.clear();

    try{
      var list = await communityRepository.getAllPosts(page);
      print(list);
      for( var i = 0; i< list.length; i++){
        UserModel user = UserModel(userId: list[i]['creator'][0]['id'],
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
            publishedDate: list[i]['humanize_date_creation'],
            imagesUrl: list[i]['images'],
            user: user,
            liked: list[i]['liked'],
            likeTapped: list[i]['liked'],
            sectors: list[i]['sectors'],


        );

        //print(User.fromJson(list[i]['creator']));
        postList.add(post);
      }
      loadingPosts.value = false;
      return postList;

    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      loadingPosts.value = false;


    }

  }
  // filterSearchPostsByName(String query){
  //   List dummySearchList = [];
  //   dummySearchList = listAllPosts;
  //   if(query.isNotEmpty) {
  //     List dummyListData = [];
  //     dummyListData = dummySearchList.where((element) => element.user.firstName
  //         .toString().toLowerCase().contains(query.toLowerCase()) || element.user.lastName
  //         .toString().toLowerCase().contains(query.toLowerCase())).toList();
  //     allPosts.value = dummyListData;
  //     return;
  //   } else {
  //     allPosts.value = listAllPosts;
  //   }
  // }

  filterSearchPostsBySectors(var query)async{
    var postList = [];
    if(sectorsSelected.isNotEmpty) {
      loadingPosts.value = true;
      try {
        page = 0;
        var list = await communityRepository.filterPostsBySectors(page, query);
        print(list);
        for( var i = 0; i< list.length; i++){
          UserModel user = UserModel(userId: list[i]['creator'][0]['id'],
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
            publishedDate: list[i]['humanize_date_creation'],
            imagesUrl: list[i]['images'],
            user: user,
            liked: list[i]['liked'],
            likeTapped: list[i]['liked'],
            sectors: list[i]['sectors'],


          );

          //print(User.fromJson(list[i]['creator']));
          postList.add(post);
        }
        loadingPosts.value = false;
        allPosts.value = postList;
        noFilter.value = false;
        return;

      }
      catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
      finally {
        loadingPosts.value = false;


      }

    }else {
      allPosts.value = listAllPosts;
      noFilter.value = false;
    }
  }

  filterSearchPostsByZone(var query)async{
    var postList = [];
    if(divisionSelectedValue.isNotEmpty || regionSelectedValue.isNotEmpty || subdivisionSelectedValue.isNotEmpty) {
      loadingPosts.value = true;
      try {
        page = 0;
        var list = await communityRepository.filterPostsByZone(page, query);
        print(list);
        for( var i = 0; i< list.length; i++){
          UserModel user = UserModel(userId: list[i]['creator'][0]['id'],
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
            publishedDate: list[i]['humanize_date_creation'],
            imagesUrl: list[i]['images'],
            user: user,
            liked: list[i]['liked'],
            likeTapped: list[i]['liked'],
            sectors: list[i]['sectors'],


          );

          //print(User.fromJson(list[i]['creator']));
          postList.add(post);
        }
        loadingPosts.value = false;
        allPosts.value = postList;
        noFilter.value = false;
        return;

      }
      catch (e) {
        Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
      }
      finally {
        loadingPosts.value = false;


      }

    }else {
      loadingPosts.value = true;
      listAllPosts = getAllPosts(0);
      allPosts.value = listAllPosts;
      noFilter.value = false;
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

  emptyArrays(){
    sectorsSelected.clear();
    imageFiles.clear();
    regionSelectedValue.clear();
    divisionSelectedValue.clear();
    subdivisionSelectedValue.clear();
  }

  createPost(Post post)async{
    try{
      await communityRepository.createPost(post);
      Get.showSnackbar(Ui.SuccessSnackBar(message: 'Post created successfully' ));
      loadingPosts.value = true;
      await getAllPosts(0);
      createPosts.value = true;
    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      createPosts.value = true;
      emptyArrays();


    }

  }

  updatePost(Post post)async{
    try{
      await communityRepository.updatePost(post);
      Get.showSnackbar(Ui.SuccessSnackBar(message: 'Post updated successfully' ));
      loadingPosts.value = true;
      await getAllPosts(0);

    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      createPosts.value = true;
      emptyArrays();
    }

  }

  likeUnlikePost(int postId)async{
    try{
      await communityRepository.likeUnlikePost(postId);

    }
    catch (e) {
      selectedPost.clear();
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {

    }

  }

  getAPost(int postId)async{
    try{
      var result= await communityRepository.getAPost(postId);
      print("Result is : ${result}");
      UserModel user = UserModel(userId: result['creator'][0]['id'],
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
        publishedDate: result['humanize_date_creation'],
        imagesUrl: result['images'],
        user: user,
        liked: result['liked'],
        likeTapped: result['liked'],
        commentList: result['comments'],
        sectors: result['sectors'],
        zonePostId: result['zone']

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
      sendComment.value = true;
      var result= await communityRepository.commentPost(postId, comment);
      print("Result is : ${result}");
      UserModel user = UserModel(userId: result['creator'][0]['id'],
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
      sendComment.value = false;
      return postModel;

    }
    catch (e) {
      sendComment.value = false;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      sendComment.value = false;
    }

  }

  sharePost(int postId)async{
    try{
      copyLink.value = false;
      showDialog(context: Get.context!, builder: (context){
        return CommentLoadingWidget();
      },);
      await communityRepository.sharePost(postId);
      Navigator.of(Get.context!).pop();
      Share.share('https://dev.residat.com/show-post/${postId}');

    }
    catch (e) {
      for(var i = 0; i< sharedPost.length; i++){
        if(sharedPost[i].postId == postId ){
          sharedPost.removeAt(i);
          break;
        }
      }
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));

    }
    finally {

    }

  }

  deletePost(int postId)async{
    print(postId);
    try{
      await communityRepository.deletePost(postId);
      Get.showSnackbar(Ui.SuccessSnackBar(message: 'Post deleted successfully' ));
      loadingPosts.value = true;
      await getAllPosts(0);

    }
    catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
    finally {
      //createPosts.value = true;
    }

  }

}


