import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:mapnrank/app/models/post_model.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mapnrank/app/services/global_services.dart';
import '../models/event_model.dart';
import 'dio_client.dart';
//import 'package:dio/dio.dart' as dio_form_data;

class LaravelApiClient extends GetxService {
  late DioClient httpClient;
  late String baseUrl;
  late dio.Options optionsNetwork;
  late dio.Options optionsCache;

  LaravelApiClient() {
    baseUrl = GlobalService().baseUrl;
    httpClient = DioClient(baseUrl, dio.Dio());
  }

  Future<LaravelApiClient> init() async {
    optionsNetwork = httpClient.optionsNetwork!;
    optionsCache = httpClient.optionsCache!;
    return this;
  }

  // bool isLoading({required String task, required List<String> tasks}) {
  //   return httpClient.isLoading(task: task, tasks: tasks);
  // }


  void forceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      optionsCache = dio.Options(headers: optionsCache.headers);
      optionsNetwork = dio.Options(headers: optionsNetwork.headers);
    }
  }


  Future<UserModel> register(UserModel user) async {
    Uri uri = getApiBaseUri("register");
    Get.log(uri.toString());
    var response = await httpClient.postUri(
      uri,
      data: json.encode(user.toJson()),
      options: optionsNetwork,
      onSendProgress: (int count, int total) {
        print('Register Progress: $count/$total');
      },
      onReceiveProgress: (int count, int total) {
        print('Register Progress: $count/$total');
      },
    );
    if (response.data['status'] == true) {
      response.data['data']['auth'] = true;
      UserModel.auth = true;
      return UserModel.fromJson(response.data['data']);
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

  //Handling User
  Future<UserModel> login(UserModel user) async {
    Uri _uri = getApiBaseUri("login");
    Get.log(_uri.toString());
    var response = await httpClient.postUri(
      _uri,
      data: json.encode(user.toJson()),
      options: optionsNetwork,
      onSendProgress: (int count, int total) {
        print('Register Progress: $count/$total');
      },
      onReceiveProgress: (int count, int total) {
        print('Register Progress: $count/$total');
      },
    );
    if (response.data['status'] == true) {
      UserModel.auth = true;
      print("Data is: ${response.data['data']}");

      return UserModel.fromJson(response.data['data']);
    } else {
      throw Exception(response.data['message']);
    }
  }

  Future logout() async {
    print(Get.find<AuthService>().user.value.authToken);
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
    };
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/logout',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
    );

    if (response.statusCode == 200) {
      if (response.data['status'] == true) {
        print('Finally Logged out');
        return response.data['data'];
      } else {
        throw  Exception(response.data['message']);
      }
    }
    else {
      throw  Exception(response.statusMessage);
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


  // Handling Sectors and zones
Future getAllZones(int levelId, int parentId) async {
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json'

  };
  var dio = Dio();
  var response = await dio.request(
    '${GlobalService().baseUrl}api/zone?level_id=$levelId&parent_id=$parentId',
    options:Options(
      method: 'GET',
      headers: headers,
    ),
  );

  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
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
    var response = await httpClient.getUri(
      uri,
      options: optionsNetwork,
      onReceiveProgress: (int count, int total) {  },
    );
    if (response.data['status'] == true) {
      return response.data;
    } else {
      throw  Exception(response.data['message']);
    }
  }


  // Handling Posts
Future getAllPosts(int page) async {
    print("Page is: ${page}");
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}',
  };
  var dio = Dio();
  var response = await dio.request(
    '${GlobalService().baseUrl}api/post?page=$page&size=10',
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
  print(post.zonePostId);
  print(post.content);
  print(post.imagesFilePaths);
  print(post.sectors);


  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
  };
  var request = http.MultipartRequest('POST', Uri.parse('${GlobalService().baseUrl}api/post'));
  request.fields.addAll({
    'content': post.content!,
    'zone_id': post.zonePostId.toString(),
    'published_at': DateTime.now().toString(),
    //'sectors': '1'
  });

  for(var i = 0; i < post.imagesFilePaths!.length; i++){
    request.files.add(await http.MultipartFile.fromPath('media[]', ".${post.imagesFilePaths![i].path}"));
    }
  for(var i =0; i < post.sectors!.length; i++)
    {
      request.fields['sectors[${i}]'] = post.sectors![i].toString();
    }

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    var result = json.decode(data);
    if (result['status'] == true) {
      return result['data'];
    } else {
      throw  Exception((result['message']));
    }
  }
  else {
    throw Exception(response.reasonPhrase);
  }

}

Future updatePost(Post post) async{
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
  };

  var request = http.MultipartRequest('POST', Uri.parse('${GlobalService().baseUrl}api/post/${post.postId}'));
  request.fields.addAll({
    'content': post.content!,
    'zone_id': post.zonePostId.toString(),
    'published_at': '2024-04-29T14:44:42',
    'sectors[]': '${post.sectors}',
    '_method': 'PUT'
  });

  for(var i = 0; i < post.imagesFilePaths!.length; i++){
    request.files.add(await http.MultipartFile.fromPath('media[]', ".${post.imagesFilePaths![i].path}"));
  }

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    var result = json.decode(data);
    if (result['status'] == true) {
      return result['data'];
    } else {
      throw  Exception((result['message']));
    }
  }
  else {
    throw Exception(response.reasonPhrase);
  }

}


Future likeUnlikePost(int postId)async{
    print(postId);

  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
  };
  var dio = Dio();
  var response = await dio.request(
    '${GlobalService().baseUrl}api/post/like/$postId',
    options: Options(
      method: 'POST',
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
    throw Exception(response.statusMessage);
  }

}

Future getAPost(int postId) async{
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
  };
  var dio = Dio();
  var response = await dio.request(
    '${GlobalService().baseUrl}api/post/$postId',
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
    throw Exception(response.statusMessage);
  }
}

Future commentPost(int postId, String comment)async{
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
  };
  var data = json.encode({
    "text": comment
  });
  var dio = Dio();
  var response = await dio.request(
    '${GlobalService().baseUrl}api/post/comment/$postId',
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
    throw Exception(response.statusMessage);
  }


}

sharePost(int postId) async{
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
  };
  var dio = Dio();
  var response = await dio.request(
    '${GlobalService().baseUrl}api/post/share/$postId',
    options: Options(
      method: 'POST',
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
    throw Exception(response.statusMessage);
  }
}

deletePost(int postId) async{
  var headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
  };
  var dio = Dio();
  var response = await dio.request(
    '${GlobalService().baseUrl}api/post/$postId',
    options: Options(
      method: 'DELETE',
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
    throw Exception(response.statusMessage);
  }

}

//Filter Posts by zone
  Future filterPostsByZone(int page, int zoneId) async {
    print("Page is: ${page}");
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}',
    };
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/post?page=$page&zone_id=$zoneId&size=10',
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

  //Filter Posts by sectors
  Future filterPostsBySectors(int page, var sectors) async {
    print("Page is: ${page}");
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}',
    };
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/post?page=$page&sectors=$sectors&size=10',
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


//Handling Events

  Future getAllEvents(int page) async {
    print("Page is: ${page}");
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}',
    };
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/events?page=$page&size=10',
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

  Future getAnEvent(int eventId) async{
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
    };
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/events/$eventId',
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
      throw Exception(response.statusMessage);
    }
  }

  createEvent(Event event) async{
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
    };

    var request = http.MultipartRequest('POST', Uri.parse('${GlobalService().baseUrl}api/events'));
    request.fields.addAll({
      'title': event.title!,
      'description': event.content!,
      'location': event.zone!,
      'organized_by': event.organizer!,
      'user_id': Get.find<AuthService>().user.value.userId.toString(),
      'date_debut': event.startDate!,
      'date_fin': event.endDate!,
      'sector_id': '1',
      'zone_id': event.zoneEventId!.toString(),
      'published_at': DateTime.now().toString()
    });

      request.files.add(await http.MultipartFile.fromPath('media', ".${event.imagesFilePaths![0].path}"));

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 201) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      if (result['status'] == true) {
        return result['data'];
      } else {
        throw  Exception((result['message']));
      }
    }
    else {
      throw Exception(response.reasonPhrase);
    }
  }

  updateEvent(Event event)async{

  }

  deleteEvent(int eventId) async{
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}'
    };
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/events/$eventId',
      options: Options(
        method: 'DELETE',
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
      throw Exception(response.statusMessage);
    }

  }


  //Filter Events by zone
  Future filterEventsByZone(int page, int zoneId) async {
    print("Page is: ${page}");
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}',
    };
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/events?page=$page&zone_id=$zoneId&size=10',
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

  //Filter Events by sectors
  Future filterEventsBySectors(int page, var sectors) async {
    print("Page is: ${page}");
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${Get.find<AuthService>().user.value.authToken}',
    };
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/events?page=$page&sectors=$sectors&size=10',
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







}
