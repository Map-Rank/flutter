import 'package:get/get.dart';
import 'package:mapnrank/app/models/post_model.dart';
import 'package:mapnrank/app/models/user_model.dart';
import '../providers/laravel_provider.dart';

class CommunityRepository {
  late LaravelApiClient _laravelApiClient;



  Future getAllPosts(int page) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getAllPosts(page);
  }

  Future createPost(Post post) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.createPost(post);
  }

  Future updatePost(Post post) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.updatePost(post);
  }

  Future likeUnlikePost(int postId) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.likeUnlikePost(postId);
  }

  Future getAPost(int postId){
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getAPost(postId);

  }

  Future commentPost(int postId, String comment){
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.commentPost(postId, comment);

  }

  Future sharePost(int postId){
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.sharePost(postId);

  }

  Future deletePost(int postId){
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.deletePost(postId);

  }

}
