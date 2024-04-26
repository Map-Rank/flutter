import 'package:get/get.dart';
import 'package:mapnrank/app/models/post_model.dart';
import 'package:mapnrank/app/models/user_model.dart';
import '../providers/laravel_provider.dart';

class CommunityRepository {
  late LaravelApiClient _laravelApiClient;



  Future getAllPosts() {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.getAllPosts();
  }

  Future createPost(Post post) {
    _laravelApiClient = Get.find<LaravelApiClient>();
    return _laravelApiClient.createPost(post);
  }

}
