import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:mapnrank/app/models/post_model.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mapnrank/app/services/global_services.dart';
import 'dio_client.dart';
//import 'package:dio/dio.dart' as dio_form_data;

class LaravelApiClient extends GetxService {
  late DioClient _httpClient;
  late String baseUrl;
  late dio.Options _optionsNetwork;
  late dio.Options _optionsCache;

  LaravelApiClient() {
    baseUrl = GlobalService().baseUrl;
    _httpClient = DioClient(baseUrl, dio.Dio());
  }

  Future<LaravelApiClient> init() async {
    _optionsNetwork = _httpClient.optionsNetwork!;
    _optionsCache = _httpClient.optionsCache!;
    return this;
  }

  bool isLoading({required String task, required List<String> tasks}) {
    return _httpClient.isLoading(task: task, tasks: tasks);
  }


  void forceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      _optionsCache = dio.Options(headers: _optionsCache.headers);
      _optionsNetwork = dio.Options(headers: _optionsNetwork.headers);
    }
  }

  void unForceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      _optionsNetwork = buildCacheOptions(const Duration(days: 3), forceRefresh: true, options: _optionsNetwork);
      _optionsCache = buildCacheOptions(const Duration(minutes: 10), forceRefresh: false, options: _optionsCache);
    }
  }

  Future<User> register(User user) async {
    Uri uri = getApiBaseUri("register");
    Get.log(uri.toString());
    var response = await _httpClient.postUri(
      uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
      onSendProgress: (int count, int total) {  },
      onReceiveProgress: (int count, int total) {  },
    );
    if (response.data['status'] == true) {
      response.data['data']['auth'] = true;
      User.auth = true;
      return User.fromJson(response.data['data']);
    } else {
      throw  Exception(response.data['message']);
    }
  }

  //
  //
  // Future<User> getUser(User user) async {
  //   if (!authService.isAuth) {
  //     throw new Exception("You don't have the permission to access to this area!".tr + "[ getUser() ]");
  //   }
  //   var _queryParameters = {
  //     'api_token': authService.apiToken,
  //   };
  //   Uri _uri = getApiBaseUri("user").replace(queryParameters: _queryParameters);
  //   Get.log(_uri.toString());
  //   var response = await _httpClient.getUri(
  //     _uri,
  //     options: _optionsNetwork,
  //   );
  //   if (response.data['success'] == true) {
  //     return User.fromJson(response.data['data']);
  //   } else {
  //     throw new Exception(response.data['message']);
  //   }
  // }
  //
  Future<User> login(User user) async {
    Uri _uri = getApiBaseUri("login");
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: _optionsNetwork,
      onSendProgress: (int count, int total) {  },
      onReceiveProgress: (int count, int total) {  },
    );
    if (response.data['status'] == true) {
      User.auth = true;
      return User.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message']);
    }
  }

  Future<User> logout() async {
    Uri _uri = getApiBaseUri("logout");
    Get.log(_uri.toString());
    var response = await _httpClient.postUri(
      _uri,
      data: json.encode('user.toJson()'),
      options: _optionsNetwork,
      onSendProgress: (int count, int total) {  },
      onReceiveProgress: (int count, int total) {  },
    );
    if (response.data['status'] == true) {
      return User.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message']);
    }
  }

  String getBaseUrl(String path) {
    if (!path.endsWith('/')) {
      path += '/';
    }
    if (path.startsWith('/')) {
      path = path.substring(1);
    }
    if (!baseUrl.endsWith('/')) {
      return baseUrl + '/' + path;
    }
    return baseUrl + path;
  }

  String getApiBaseUrl(String path) {
    String _apiPath = GlobalService().apiPath;
    if (path.startsWith('/')) {
      return getBaseUrl(_apiPath) + path.substring(1);
    }
    return getBaseUrl(_apiPath) + path;
  }

  Uri getApiBaseUri(String path) {
    return Uri.parse(getApiBaseUrl(path));
  }

Future getAllZones(int levelId, int parentId) async {
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}',

  };
  var dio1 = Dio();
  var response = await dio1.request(
    '${baseUrl}api/zone?level_id=$levelId&parent_id=$parentId',
    options:_optionsNetwork,
  );

  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
      print(response.data);
      return response.data;
    } else {
      throw  Exception(response.data['message']);
    }
  }
  else {
    print(response.statusMessage);
  }


}

  Future getAllSectors() async {
    Uri uri = getApiBaseUri("sector");
    Get.log(uri.toString());
    var response = await _httpClient.getUri(
      uri,
      options: _optionsNetwork,
      onReceiveProgress: (int count, int total) {  },
    );
    if (response.data['status'] == true) {
      return response.data;
    } else {
      throw  Exception(response.data['message']);
    }
  }

Future getAllPosts() async {
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}',
  };
  var dio = Dio();
  var response = await dio.request(
    '${GlobalService().baseUrl}api/post',
    options: Options(
      method: 'GET',
      headers: headers,
    ),
  );

  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
      return response.data['data'];
    } else {
      throw  Exception(response.data['message']);
    }
  }
  else {
    //print(response.statusMessage);
    throw  Exception(response.statusMessage);
  }


}

Future createPost(Post post)async{

  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}',
  };
  var list = [];
  for(var i = 0; i < post.imagesFilePaths!.length; i++){
    list.add(await dio.MultipartFile.fromFile(post.imagesFilePaths![i].path, filename: ''),);

  }
  var data = dio.FormData.fromMap({
    'files': list,
    'content': post.content,
    'published_at': post.publishedDate,
    'zone_id': post.zonePostId,
    'sectors': 1,
  });

  var dio1 = Dio();
  var response = await dio1.request(
    '${GlobalService().baseUrl}api/post',
    options: Options(
      method: 'POST',
      headers: headers,
    ),
    data: data,
  );

  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
      return response.data['data'];
    } else {
      throw  Exception(response.data['message']);
    }
  }
  else {
    //print(response.statusMessage);
    throw  Exception(response.statusMessage);
  }

}






}
