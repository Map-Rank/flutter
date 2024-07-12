import 'dart:convert';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
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

  LaravelApiClient({Dio? dio}) {
    baseUrl = GlobalService().baseUrl;
    httpClient = DioClient(baseUrl, dio??Dio(BaseOptions(baseUrl: 'http://192.168.43.184:8080/api')));
  }

  // LaravelApiClient({Dio? dio})
  //     : httpClient = dio ?? Dio(BaseOptions(baseUrl: 'http://192.168.43.184:8080/api'));

  Future<LaravelApiClient> init() async {
    optionsNetwork = httpClient.optionsNetwork!;
    optionsCache = httpClient.optionsCache!;
    return this;
  }



  void forceRefresh() {
    if (!foundation.kIsWeb && !foundation.kDebugMode) {
      optionsCache = dio.Options(headers: optionsCache.headers);
      optionsNetwork = dio.Options(headers: optionsNetwork.headers);
    }
  }


  Future<UserModel> register(UserModel user) async {
    var headers = {
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json'
    };
    var request = http.MultipartRequest('POST', Uri.parse('${GlobalService().baseUrl}api/post'));
    request.fields.addAll({
      'first_name': user.firstName!,
      'last_name': user.lastName!,
      'email': user.email!,
      'phone': user.phoneNumber,
      'date_of_birth': user.birthdate!,
      'password': user.password!,
      'gender': user.gender!,
      'zone_id': user.zoneId!,
      //'sectors': '1'
    });

    request.files.add(await http.MultipartFile.fromPath('media', ".${user.imageFile![0].path}"));


    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

// coverage:ignore-start
    if (response.statusCode == 201) {
      var data = await response.stream.bytesToString();
      var result = json.decode(data);
      if (result['status'] == true) {
        return UserModel.fromJson(result['data']);
      } else {
        throw  Exception((result['message']));
      }
    }
    else {
      throw Exception(response.reasonPhrase);
    }// coverage:ignore-end

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
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    var data = json.encode({
      "email": user.email,
      "password": user.password
    });
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/login',
      options: Options(
        method: 'POST',
        headers: headers,
      ),
      data: data,
    );
// coverage:ignore-start
    if (response.statusCode == 200) {
      if (response.data['status'] == true) {
        print("Data is: ${response.data['data']}");

        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    }
    else {
      throw  Exception(response.statusMessage);
    }// coverage:ignore-end


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
// coverage:ignore-start
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
    }// coverage:ignore-end
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
// coverage:ignore-start
  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
      return response.data;
    } else {
      throw  Exception(response.data['message']);
    }
  }
  else {
    print(response.statusMessage);
  }// coverage:ignore-end


}

  Future getAllSectors() async {
    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json'
    };
    var dio = Dio();
    var response = await dio.request(
      '${GlobalService().baseUrl}api/sector',
      options: Options(
        method: 'GET',
        headers: headers,
      ),
    );
// coverage:ignore-start
    if (response.statusCode == 200) {
      if (response.data['status'] == true) {
        return response.data;
      } else {
        throw  Exception(response.data['message']);
      }
    }
    else {
      print(response.statusMessage);
      throw  Exception(response.statusMessage);
    }// coverage:ignore-end

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
// coverage:ignore-start
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
  }// coverage:ignore-end


}

Future createPost(Post post)async{


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
// coverage:ignore-start
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
  }// coverage:ignore-end

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
// coverage:ignore-start
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
  }// coverage:ignore-end

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
// coverage:ignore-start
  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
      return response.data['data'];
    } else {
      throw  Exception(response.data['message']);
    }
  }
  else {
    throw Exception(response.statusMessage);
  }// coverage:ignore-end

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
// coverage:ignore-start
  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
      return response.data['data'];
    } else {
      throw  Exception(response.data['message']);
    }
  }
  else {
    throw Exception(response.statusMessage);
  }// coverage:ignore-end
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
// coverage:ignore-start
  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
      return response.data['data'];
    } else {
      throw  Exception(response.data['message']);
    }
  }
  else {
    throw Exception(response.statusMessage);
  }// coverage:ignore-end


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
// coverage:ignore-start
  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
      return response.data['data'];
    } else {
      throw  Exception(response.data['message']);
    }
  }
  else {
    throw Exception(response.statusMessage);
  }// coverage:ignore-end
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
// coverage:ignore-start
  if (response.statusCode == 200) {
    if (response.data['status'] == true) {
      return response.data['data'];
    } else {
      throw  Exception(response.data['message']);
    }
  }
  else {
    throw Exception(response.statusMessage);
  }// coverage:ignore-end

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
// coverage:ignore-start
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
    }// coverage:ignore-end


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
// coverage:ignore-start
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
    }// coverage:ignore-end


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
// coverage:ignore-start
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
    }// coverage:ignore-end


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
// coverage:ignore-start
    if (response.statusCode == 200) {
      if (response.data['status'] == true) {
        return response.data['data'];
      } else {
        throw  Exception(response.data['message']);
      }
    }
    else {
      throw Exception(response.statusMessage);
    }// coverage:ignore-end
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
// coverage:ignore-start
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
    }// coverage:ignore-end
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
// coverage:ignore-start
    if (response.statusCode == 200) {
      if (response.data['status'] == true) {
        return response.data['data'];
      } else {
        throw  Exception(response.data['message']);
      }
    }
    else {
      throw Exception(response.statusMessage);
    }// coverage:ignore-end

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
// coverage:ignore-start
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
    }// coverage:ignore-end


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
// coverage:ignore-start
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
    }// coverage:ignore-end


  }







}
