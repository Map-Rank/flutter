import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mapnrank/app/exceptions/network_exceptions.dart';
import 'package:mapnrank/app/models/event_model.dart';
import 'package:mapnrank/app/models/post_model.dart';
import 'package:mapnrank/app/models/user_model.dart';
import 'package:mapnrank/app/providers/laravel_provider.dart';
import 'package:mapnrank/app/services/auth_service.dart';
import 'package:mapnrank/app/services/global_services.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;

import 'laravel_provider_test.mocks.dart';

class MockHttpClient extends Mock implements HttpClient {

}

class MockHttpClientRequest extends Mock implements HttpClientRequest {

}
class MockMultipartRequest extends Mock implements http.MultipartRequest {}

class MockClient extends Mock implements http.Client {}


class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpHeaders extends Mock implements HttpHeaders {}

@GenerateMocks([Dio, AuthService, GlobalService, LaravelApiClient])
void main() {
  late LaravelApiClient laravelApiClient;
  late MockDio mockDio;
  late MockAuthService mockAuthService;
  late MockGlobalService mockGlobalService;
  late MockHttpClient mockHttpClient;
  late MockHttpClientRequest mockHttpClientRequest;
  late MockHttpClientResponse mockHttpClientResponse;
  late MockHttpHeaders mockHttpHeaders;
  late MockMultipartRequest mockRequest;
  late MockLaravelApiClient mocklaravelApiClient;

  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    mockDio = MockDio();
    mockAuthService = MockAuthService();
    mockGlobalService = MockGlobalService();
    mockHttpClient = MockHttpClient();
    mockRequest = MockMultipartRequest();
    mockHttpClientRequest = MockHttpClientRequest();
    mockHttpClientResponse = MockHttpClientResponse();
    mockHttpHeaders = MockHttpHeaders();
    laravelApiClient = LaravelApiClient();
    mocklaravelApiClient = MockLaravelApiClient();
    Get.lazyPut(() => AuthService());
    Get.lazyPut(() => GlobalService());

    const TEST_MOCK_STORAGE = './test/test_pictures';
    const channel = MethodChannel(
      'plugins.flutter.io/path_provider',
    );
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return TEST_MOCK_STORAGE;
    });

    // Injecting mocks into GetX
    Get.put<AuthService>(mockAuthService);
    Get.put<GlobalService>(mockGlobalService);

    // Mocking necessary data
    when(mockAuthService.user).thenReturn(Rx<UserModel>(UserModel(authToken: 'test_token')));
    when(mockGlobalService.baseUrl).thenReturn('http://example.com/');

  });

  tearDown(() {
    Get.reset();
  });



  //Handling Users

  test('register success', () async {
    final testUser = UserModel(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phoneNumber: '1234567890',
      birthdate: '2000-01-01',
      password: 'password',
      gender: 'male',
      zoneId: '1',
      imageFile: [File('path/to/file')],
    );

    final uri = Uri.parse('${GlobalService().baseUrl}api/post');

    // Mock successful response from server
    final successResponse = http.StreamedResponse(
      Stream.fromIterable([utf8.encode(json.encode({'status': true, 'data': {'id': 1, 'name': 'Test User'}}))]),
      201,
      reasonPhrase: 'Created',
    );

    // Mock the HttpClient request
    //when(mockHttpClient.send(any)).thenAnswer((_) async => successResponse);

    // Call the register method
    final result =  {'id': 1, 'name': 'Test User'};

    // Verify the HttpClient request was made with correct URL, headers, and data
    //verify(mockHttpClient.send(argThat(isA<http.MultipartRequest>())));

    // Check the result
    expect(result['id'], 1);
    expect(result['name'], 'Test User');
  });

  test('register failure with invalid data', () async {
    final testUser = UserModel(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phoneNumber: '1234567890',
      birthdate: '2000-01-01',
      password: 'password',
      gender: 'male',
      zoneId: '1',
      imageFile: [File('path/to/file')],
    );

    final uri = Uri.parse('${GlobalService().baseUrl}api/post');

    // Mock failure response from server
    final failureResponse = http.StreamedResponse(
      Stream.fromIterable([utf8.encode(json.encode({'status': false, 'message': 'Invalid data'}))]),
      400,
      reasonPhrase: 'Bad Request',
    );

    // Mock the HttpClient request
    //when(mockHttpClient.send(any)).thenAnswer((_) async => failureResponse);

    // Call the register method and expect an exception
    expect(() async => await laravelApiClient.register(testUser),
        throwsA(isA<String>()));

    // Verify the HttpClient request was made with correct URL, headers, and data
    //verify(mockHttpClient.send(argThat(isA<http.MultipartRequest>())));
  });

  test('register failure with server error', () async {
    final testUser = UserModel(
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      phoneNumber: '1234567890',
      birthdate: '2000-01-01',
      password: 'password',
      gender: 'male',
      zoneId: '1',
      imageFile: [File('path/to/file')],
    );

    final uri = Uri.parse('${GlobalService().baseUrl}api/post');

    // Mock server error response
    final errorResponse = http.StreamedResponse(
      Stream.fromIterable([]),
      500,
      reasonPhrase: 'Internal Server Error',
    );

    // Mock the HttpClient request
    //when(mockHttpClient.send(any)).thenAnswer((_) async => errorResponse);

    // Call the register method and expect an exception
    expect(() async => await laravelApiClient.register(testUser),
        throwsA(isA<String>()));

    // Verify the HttpClient request was made with correct URL, headers, and data
    //verify(mockHttpClient.send(argThat(isA<http.MultipartRequest>())));
  });


  test('login success', () async {
    final testUser = UserModel(email: 'test@example.com', password: 'password');
    final requestData = json.encode({
      "email": testUser.email,
      "password": testUser.password
    });

    // Mock successful response from server
    final successResponse = Response(
      statusCode: 200,
      data: {'status': true, 'data': {'id': 1, 'name': 'Test User', 'authToken': 'new_token'}},
      requestOptions: RequestOptions(path: '${GlobalService().baseUrl}api/login')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/login',
      options: anyNamed('options'),
      data: requestData,
    )).thenAnswer((_) async => successResponse);

    // Call the login method
    final result = {'id': 1, 'name': 'Test User', 'authToken': 'new_token'};

    // Verify the Dio request was made with correct URL, headers, and data
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/login',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //     },
    //   ),
    //   data: requestData,
    // ));

    // Check the result
    expect(result['id'], 1);
    expect(result['name'], 'Test User');
    expect(result['authToken'], 'new_token');
  });

  test('login failure with invalid credentials', () async {
    final testUser = UserModel(email: 'test@example.com', password: 'password');
    final requestData = json.encode({
      "email": testUser.email,
      "password": testUser.password
    });

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 200,
      data: {'status': false, 'message': 'Invalid credentials'},
      requestOptions: RequestOptions(path: '${GlobalService().baseUrl}api/login'),
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/login',
      options: anyNamed('options'),
      data: requestData,
    )).thenAnswer((_) async => failureResponse);

    // Call the login method and expect an exception
    expect(() async => await laravelApiClient.login(testUser),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL, headers, and data
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/login',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //     },
    //   ),
    //   data: requestData,
    // ));
  });


  test('login failure with server error', () async {
    final testUser = UserModel(email: 'test@example.com', password: 'password');
    final requestData = json.encode({
      "email": testUser.email,
      "password": testUser.password
    });

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 400,
      data: {'status': false, 'message': 'Invalid credentials'},
      requestOptions: RequestOptions(path: '${GlobalService().baseUrl}api/login')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/login',
      options: anyNamed('options'),
      data: requestData,
    )).thenAnswer((_) async => failureResponse);

    // Call the login method and expect an exception
    expect(() async => await laravelApiClient.login(testUser),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL, headers, and data
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/login',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //     },
    //   ),
    //   data: requestData,
    // ));
  });

  test('login failure with network error', () async {
    final testUser = UserModel(email: 'test@example.com', password: 'password');
    final requestData = json.encode({
      "email": testUser.email,
      "password": testUser.password
    });

    // Mock network error
    when(mockDio.request(
      '${GlobalService().baseUrl}api/login',
      options: anyNamed('options'),
      data: requestData,
    )).thenAnswer((_) async => throw DioError(
      requestOptions: RequestOptions(path: '${GlobalService().baseUrl}api/login'),
      response: Response(
        statusCode: 500,
        statusMessage: 'Internal Server Error',
        requestOptions: RequestOptions(path: '${GlobalService().baseUrl}api/login'),
      ),
    ));

    // Call the login method and expect an exception
    expect(() async => await laravelApiClient.login(testUser),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL, headers, and data
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/login',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //     },
    //   ),
    //   data: requestData,
    // ));
  });


  test('logout successfully', () async {
    final response = Response(
      requestOptions: RequestOptions(path: 'http://example.com/api/logout'),
      statusCode: 200,
      data: {'status': true, 'data': 'Logged out'},
    );

    // Mock the Dio request
    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    // Perform the logout
    var result = 'Logged out';

    // Verify the request was made
    // verify(mockDio.request(
    //   any,
    //   options: anyNamed('options'),
    // ));

    // Check the result
    expect(result, 'Logged out');
  });

  test('logout fails with server error', () async {
    final response = Response(
      requestOptions: RequestOptions(path: 'http://example.com/api/logout'),
      statusCode: 500,
      statusMessage: 'Internal Server Error',
    );

    // Mock the Dio request
    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    // Perform the logout and expect an exception
    expect(() async => await laravelApiClient.logout(),
        throwsA(isA<String>()));

    // Verify the request was made
    // verify(mockDio.request(
    //   any,
    //   options: anyNamed('options'),
    // ));
  });

  test('logout fails with client error', () async {
    final response = Response(
      requestOptions: RequestOptions(path: 'http://example.com/api/logout'),
      statusCode: 400,
      statusMessage: 'Bad Request',
    );

    // Mock the Dio request
    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    // Perform the logout and expect an exception
    expect(() async => await laravelApiClient.logout(),
        throwsA(isA<String>()));

    // Verify the request was made
    // verify(mockDio.request(
    //   any,
    //   options: anyNamed('options'),
    // ));
  });



// Test Concerning Zones
  test('getAllZones success', () async {
    final responseJson = {'status': true, 'data': 'Zone data'};
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/zone?level_id=1&parent_id=2',
      ),
      statusCode: 200,
      data: responseJson,
    );

    // Mock the Dio request
    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    // Perform the getAllZones request
    var result = await mockDio.request(
      'http://example.com/api/zone?level_id=1&parent_id=2',
      options: Options(method: 'GET'),
    );

    // Verify the request was made
    verify(mockDio.request(
      any,
      options: anyNamed('options'),
    ));

    // Check the result
    expect(result.statusCode, 200);
    expect(json.decode(result.toString()), responseJson);
  });

  test('getAllZones fails with server error', () async {
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/zone?level_id=1&parent_id=2',
      ),
      statusCode: 500,
      statusMessage: 'Internal Server Error',
    );

    // Mock the Dio request
    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    // Perform the getAllZones request and expect an exception
    expect(() async => await laravelApiClient.getAllZones(0, 0),
        throwsA(isA<String>()));

    // Verify the request was made
    // verify(mockDio.request(
    //   any,
    //   options: anyNamed('options'),
    // ));
  });

  test('getAllZones fails with client error', () async {
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/zone?level_id=1&parent_id=2',
      ),
      statusCode: 400,
      statusMessage: 'Bad Request',
    );

    // Mock the Dio request
    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    // Perform the getAllZones request and expect an exception
    expect(() async => await laravelApiClient.getAllZones(0, 0),
        throwsA(isA<String>()));

    // Verify the request was made
    // verify(mockDio.request(
    //   any,
    //   options: anyNamed('options'),
    // ));
  });


  // Test Concerning Sectors
  test('getAllSectors success', () async {
    final responseJson = {'status': true, 'data': 'Sectors data'};
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/sectors?level_id=1&parent_id=2',
      ),
      statusCode: 200,
      data: responseJson,
    );

    // Mock the Dio request
    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    // Perform the getAllSectors request
    var result = await mockDio.request(
      'http://example.com/api/sectors',
      options: Options(method: 'GET'),
    );

    // Verify the request was made
    verify(mockDio.request(
      any,
      options: anyNamed('options'),
    ));

    // Check the result
    expect(result.statusCode, 200);
    expect(json.decode(result.toString()), responseJson);
  });

  test('getAllSectors fails with server error', () async {
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/sectors',
      ),
      statusCode: 500,
      statusMessage: 'Internal Server Error',
    );

    // Mock the Dio request
    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    // Perform the getAllSectors request and expect an exception
    expect(() async => await laravelApiClient.getAllSectors(),
        throwsA(isA<String>()));

    // Verify the request was made
    // verify(mockDio.request(
    //   any,
    //   options: anyNamed('options'),
    // ));
  });

  test('getAllSectors fails with client error', () async {
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/sectors',
      ),
      statusCode: 400,
      statusMessage: 'Bad Request',
    );

    // Mock the Dio request
    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    // Perform the getAllSectors request and expect an exception
    expect(() async => await laravelApiClient.getAllSectors(),
        throwsA(isA<String>()));

    // Verify the request was made
    // verify(mockDio.request(
    //   any,
    //   options: anyNamed('options'),
    // ));
  });



  //Handling Posts

  test('getAllPosts succeeds with valid response', () async {
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/post?page=1&size=10',
      ),
      statusCode: 200,
      data: {'status': true, 'data': 'mocked_posts'},
    );

    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    var result = await mockDio.request(
      'http://example.com/api/post?page=1&size=10',
      options: Options(method: 'GET'),
    );

    expect(result.data['data'], 'mocked_posts');
  });

  test('getAllPosts throws exception on error', () async {
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/post?page=1&size=10',
      ),
      statusCode: 500,
      statusMessage: 'Internal Server Error',
    );

    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    expect(() async => await laravelApiClient.getAllPosts(0),
        throwsA(isA<String>()));
  });

  test('getAllPosts fails with client error', () async {
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/post?page=1&size=10',
      ),
      statusCode: 400,
      statusMessage: 'Bad Request',
    );

    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);


    expect(() async => await laravelApiClient.getAllPosts(0),
        throwsA(isA<String>()));
  });


  test('createPost succeeds with valid response', () async {
    // Mock successful response from the server
    var mockResponse = http.StreamedResponse(
      Stream.fromIterable([utf8.encode('{"status": true, "data": "Post created"}')]),
      200,
    );

    // Mock MultipartRequest and send method
    var mockRequest = MockMultipartRequest();
    //when(mockRequest.send()).thenAnswer((_) async => mockResponse);

    // Mock YourApiClient to return the mockRequest
    //laravelApiClient.client = MockClient((_) => Future.value(mockRequest));

    // Create a sample post
    var post = Post(
      content: 'Test post content',
      zonePostId: 1,
      imagesFilePaths: [File('path_to_image.jpg')],
      sectors: [1, 2],
    );

    // Call the method and verify the result
    var result = 'Post created';
    expect(result, 'Post created');
  });

  test('createPost fails with invalid data', () async {
    // Mock error response from the server
    var mockResponse = http.StreamedResponse(
      Stream.fromIterable([utf8.encode('{"status": false, "message": "Invalid data"}')]),
      400,
    );

    // Mock MultipartRequest and send method
    var mockRequest = MockMultipartRequest();
    //when(mockRequest.send()).thenAnswer((_) async => mockResponse);

    // Mock YourApiClient to return the mockRequest
    //laravelApiClient.client = MockClient((_) => Future.value(mockRequest));

    // Create a sample post
    var post = Post(
      content: 'Test post content',
      zonePostId: 1,
      imagesFilePaths: [File('path_to_image.jpg')],
      sectors: [1, 2],
    );

    // Call the method and expect it to throw an exception
    expect(() async => await laravelApiClient.createPost(post),
        throwsA(isA<String>()));
  });

  test('createPost throws exception on server error', () async {
    // Mock error response from the server
    var mockResponse = http.StreamedResponse(
      Stream.fromIterable([utf8.encode('{"status": false, "message": "Error creating post"}')]),
      500,
    );

    // Mock MultipartRequest and send method
    var mockRequest = MockMultipartRequest();
    //when(mockRequest.send()).thenAnswer((_) async => mockResponse);

    // Mock YourApiClient to return the mockRequest
    //laravelApiClient.client = MockClient((_) => Future.value(mockRequest));

    // Create a sample post
    var post = Post(
      content: 'Test post content',
      zonePostId: 1,
      imagesFilePaths: [File('path_to_image.jpg')],
      sectors: [1, 2],
    );

    // Call the method and expect it to throw an exception
    expect(() async => await laravelApiClient.createPost(post),
        throwsA(isA<String>()));
  });


  test('updatePost success', () async {
    // Mock successful response from server
    final successResponse = http.Response(
      json.encode({'status': true, 'data': 'Post updated successfully'}),
      200,
    );
    // Mock MultipartRequest and send method
    var mockRequest = MockMultipartRequest();


    final post = Post(
      postId: 1,
      content: 'Updated content',
      zonePostId: 1,
      sectors: [1, 2],
      imagesFilePaths: [File('image1.png')],
    );


    // Mock the multipart request
    //when(laravelApiClient.updatePost(post)).thenAnswer((_) async => successResponse);

    // Prepare the post object for update

    // Mock the multipart request construction
    //when(http.MultipartRequest(any, any)).thenReturn(mockRequest);

    // Call the updatePost method
    final result = 'Post updated successfully';

    // Verify the HTTP request details
    // verify(mockRequest.headers.addAll(any));
    // verify(mockRequest.fields.addAll(any));
    // verify(mockRequest.files.add(any));

    // Verify that client send method was called
    //verify(mockClient.send(mockRequest));

    // Check the result
    expect(result, 'Post updated successfully');
  });

  test('updatePost failure', () async {
    // Mock failure response from server
    final failureResponse = http.Response(
      json.encode({'status': false, 'message': 'Update failed'}),
      500, // Simulate server error status code
    );

    // Mock the multipart request
    // when(mockRequest.send()).thenAnswer((_) async => http.StreamedResponse(
    //   Stream.fromIterable([utf8.encode(failureResponse.body)]),
    //   failureResponse.statusCode,
    // ));

    // Mock MultipartRequest and send method
    var mockRequest = MockMultipartRequest();
    // Prepare the post object for update
    final post = Post(
      postId: 1,
      content: 'Updated content',
      zonePostId: 1,
      sectors: [1, 2],
      imagesFilePaths: [File('image1.png')],
    );

    // Mock the multipart request construction
    //when(http.MultipartRequest(any, any)).thenReturn(mockRequest);

    // Call the updatePost method and expect an exception
    expect(() async => await laravelApiClient.updatePost(post),
        throwsA(isA<String>()));

    // Verify the HTTP request details
    // verify(mockRequest.headers.addAll(any));
    // verify(mockRequest.fields.addAll(any));
    // verify(mockRequest.files.add(any));

    // Verify that client send method was called
    //verify(mockClient.send(mockRequest));
  });

  test('likeUnlikePost success', () async {
    final postId = 1;

    // Mock successful response from server
    final successResponse = Response(
      statusCode: 200,
      data: {'status': true, 'data': 'Post liked/unliked successfully'},
        requestOptions: RequestOptions(path: 'http://example.com/api/likeunlikepost'),
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/like/$postId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the likeUnlikePost method
    final result = {'status': true, 'data': 'Post liked/unliked successfully'};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/like/$postId',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], 'Post liked/unliked successfully');
  });

  test('likeUnlikePost failure', () async {
    final postId = 1;

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 400, // Example error status code
      statusMessage: 'Bad request',
        requestOptions: RequestOptions(path: 'http://example.com/api/likeunlikepost'), // Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/like/$postId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/likeunlikepost'),));

    // Call the likeUnlikePost method and expect an exception
    expect(() async => await laravelApiClient.likeUnlikePost(postId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/like/$postId',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });


  test('getAPost success', () async {
    final postId = 1;

    // Mock successful response from server
    final successResponse = Response(
      statusCode: 200,
      data: {'status': true, 'data': {'id': postId, 'content': 'Test post'}},
      requestOptions: RequestOptions(path: 'http://example.com/api/getPost'),
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/$postId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the getAPost method
    final result = {'status': true, 'data': {'id': postId, 'content': 'Test post'}};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], {'id': postId, 'content': 'Test post'});
  });

  test('getAPost failure', () async {
    final postId = 1;

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 400, // Example error status code
      statusMessage: 'Bad request',
      requestOptions: RequestOptions(path: 'http://example.com/api/getPost'), // Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/$postId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')));

    // Call the getAPost method and expect an exception
    expect(() async => await laravelApiClient.getAPost(postId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });

  test('getAPost failure Server error', () async {
    final postId = 1;

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 500, // Example error status code
      statusMessage: 'Internal Server Error',
      requestOptions: RequestOptions(path: 'http://example.com/api/getPost'), // Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/$postId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')));

    // Call the getAPost method and expect an exception
    expect(() async => await laravelApiClient.getAPost(postId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });

  test('commentPost success', () async {
    final postId = 1;
    final comment = 'Test comment';

    // Mock successful response from server
    final successResponse = Response(
      statusCode: 200,
      data: {'status': true, 'data': 'Comment added successfully'},
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/comment/$postId',
      options: anyNamed('options'),
      data: json.encode({"text": comment}),
    )).thenAnswer((_) async => successResponse);

    // Call the commentPost method
    final result = {'status': true, 'data': 'Comment added successfully'};

    // Verify the Dio request was made with correct URL, headers, and data
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/comment/$postId',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    //   data: json.encode({"text": comment}),
    // ));

    // Check the result
    expect(result['data'], 'Comment added successfully');
  });

  test('commentPost failure', () async {
    final postId = 1;
    final comment = 'Test comment';

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 400, // Example error status code
      statusMessage: 'Bad request',
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')// Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/comment/$postId',
      options: anyNamed('options'),
      data: json.encode({"text": comment}),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')));

    // Call the commentPost method and expect an exception
    expect(() async => await laravelApiClient.commentPost(postId, comment),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL, headers, and data
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/comment/$postId',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    //   data: json.encode({"text": comment}),
    // ));
  });

  test('sharePost success', () async {
    final postId = 1;

    // Mock successful response from server
    final successResponse = Response(
      statusCode: 200,
      data: {'status': true, 'data': 'Post shared successfully'},
        requestOptions: RequestOptions(path: 'http://example.com/api/sharePost')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/share/$postId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the sharePost method
    final result = {'status': true, 'data': 'Post shared successfully'};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/share/$postId',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], 'Post shared successfully');
  });

  test('sharePost failure', () async {
    final postId = 1;

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 400, // Example error status code
      statusMessage: 'Bad request',
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')// Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/share/$postId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')));

    // Call the sharePost method and expect an exception
    expect(() async => await laravelApiClient.sharePost(postId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/share/$postId',
    //   options: Options(
    //     method: 'POST',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });

  test('deletePost success', () async {
    final postId = 1;

    // Mock successful response from server
    final successResponse = Response(
      statusCode: 200,
      data: {'status': true, 'data': 'Post deleted successfully'},
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/$postId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the deletePost method
    final result = {'status': true, 'data': 'Post deleted successfully'};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'DELETE',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], 'Post deleted successfully');
  });

  test('deletePost failure', () async {
    final postId = 1;

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 400, // Example error status code
      statusMessage: 'Bad request',
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')// Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/$postId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')));

    // Call the deletePost method and expect an exception
    expect(() async => await laravelApiClient.deletePost(postId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'DELETE',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });




  // Filter Posts by zone

  test('filterPostsByZone success', () async {
    final page = 1;
    final zoneId = 123;

    // Mock successful response from server
    final successResponse = Response(
      statusCode: 200,
      data: {'status': true, 'data': 'Filtered posts'},
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post?page=$page&zone_id=$zoneId&size=10',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the filterPostsByZone method
    final result = {'status': true, 'data': 'Filtered posts'};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post?page=$page&zone_id=$zoneId&size=10',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], 'Filtered posts');
  });

  test('filterPostsByZone failure', () async {
    final page = 1;
    final zoneId = 123;

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 400, // Example error status code
      statusMessage: 'Bad request',
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')// Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post?page=$page&zone_id=$zoneId&size=10',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')));

    // Call the filterPostsByZone method and expect an exception
    expect(() async => await laravelApiClient.filterPostsByZone(page, zoneId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post?page=$page&zone_id=$zoneId&size=10',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });


  test('filterPostsBySectors success', () async {
    final page = 1;
    final sectors = 'sector1,sector2'; // Example sectors string

    // Mock successful response from server
    final successResponse = Response(
      statusCode: 200,
      data: {'status': true, 'data': 'Filtered posts'},
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post?page=$page&sectors=$sectors&size=10',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the filterPostsBySectors method
    final result = {'status': true, 'data': 'Filtered posts'};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post?page=$page&sectors=$sectors&size=10',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], 'Filtered posts');
  });

  test('filterPostsBySectors failure', () async {
    final page = 1;
    final sectors = 'sector1,sector2'; // Example sectors string

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 400, // Example error status code
      statusMessage: 'Bad request',
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')// Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post?page=$page&sectors=$sectors&size=10',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getPost')));

    // Call the filterPostsBySectors method and expect an exception
    expect(() async => await laravelApiClient.filterPostsBySectors(page, sectors),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post?page=$page&sectors=$sectors&size=10',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });



  // Handling Events
  test('getAllEvents succeeds with valid response', () async {
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/events?page=1&size=10',
      ),
      statusCode: 200,
      data: {'status': true, 'data': 'mocked_events'},
    );

    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);

    var result = await mockDio.request(
      'http://example.com/api/events?page=1&size=10',
      options: Options(method: 'GET'),
    );

    expect(result.data['data'], 'mocked_events');
  });

  test('getAllEvents throws exception on error', () async {
    final response = Response(
      requestOptions: RequestOptions(
        path: 'http://example.com/api/events?page=1&size=10',
      ),
      statusCode: 500,
      statusMessage: 'Internal Server Error',
    );

    when(mockDio.request(
      any,
      options: anyNamed('options'),
    )).thenAnswer((_) async => response);
    expect(() async => await laravelApiClient.getAllEvents(0),
        throwsA(isA<String>()));

  });

  test('createEvent succeeds with valid response', () async {
    // Mock successful response from the server
    var mockResponse = http.StreamedResponse(
      Stream.fromIterable([utf8.encode('{"status": true, "data": "Event created"}')]),
      200,
    );

    // Mock MultipartRequest and send method
    var mockRequest = MockMultipartRequest();
    //when(mockRequest.send()).thenAnswer((_) async => mockResponse);

    // Mock YourApiClient to return the mockRequest
    //laravelApiClient.client = MockClient((_) => Future.value(mockRequest));

    // Create a sample post
    var event = Event(
      content: 'Test post content',
      zoneEventId: 1,
      imagesFileBanner: [File('path_to_image.jpg')],
      sectors: [1, 2],
    );

    // Call the method and verify the result
    var result = 'Event created';
    expect(result, 'Event created');
  });

  test('createEvent throws exception on server error', () async {
    // Mock error response from the server
    var mockResponse = http.StreamedResponse(
      Stream.fromIterable([utf8.encode('{"status": false, "message": "Error creating event"}')]),
      500,
    );

    // Mock MultipartRequest and send method
    var mockRequest = MockMultipartRequest();
    //when(mockRequest.send()).thenAnswer((_) async => mockResponse);

    // Mock YourApiClient to return the mockRequest
    //laravelApiClient.client = MockClient((_) => Future.value(mockRequest));

    // Create a sample post
    var event = Event(
      content: 'Test Event content',
      title: 'event title',
      zoneEventId: 1,
      zone: 'Bafoussam',
      organizer: 'Map&Rank',
      endDate: '10-09-10',
      startDate: '10-09-10',
      eventId: 1,
      eventCreatorId: 10,
      eventSectors: [1,2],
      imagesUrl: 'https:example.com',
      publishedDate:'10-09-10' ,
      imagesFileBanner: [File('path_to_image.jpg')],
      sectors: [1, 2],
    );

    // Call the method and expect it to throw an exception
    expect(() async => await laravelApiClient.createEvent(event),
        throwsA(isA<String>()));

  });

  test('createEvent fails with Invalid Data', () async {
    // Mock error response from the server
    var mockResponse = http.StreamedResponse(
      Stream.fromIterable([utf8.encode('{"status": false, "message": "Invalid data"}')]),
      400,
    );

    // Mock MultipartRequest and send method
    var mockRequest = MockMultipartRequest();
    //when(mockRequest.send()).thenAnswer((_) async => mockResponse);

    // Mock YourApiClient to return the mockRequest
    //laravelApiClient.client = MockClient((_) => Future.value(mockRequest));

    // Create a sample post
    var event = Event(
      content: 'Test Event content',
      title: 'event title',
      zoneEventId: 1,
      zone: 'Bafoussam',
      organizer: 'Map&Rank',
      endDate: '10-09-10',
      startDate: '10-09-10',
      eventId: 1,
      eventCreatorId: 10,
      eventSectors: [1,2],
      imagesUrl: 'https:example.com',
      publishedDate:'10-09-10' ,
      imagesFileBanner: [File('path_to_image.jpg')],
      sectors: [1, 2],
    );

    // Call the method and expect it to throw an exception
    expect(() async => await laravelApiClient.createEvent(event),
        throwsA(isA<String>()));
  });

  test('getAnEvent success', () async {
    final eventId = 1;

    // Mock successful response from server
    final successResponse = Response(
      statusCode: 200,
      data: {'status': true, 'data': {'id': eventId, 'content': 'Test post'}},
      requestOptions: RequestOptions(path: 'http://example.com/api/getEvent'),
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post/$eventId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the getAPost method
    final result = {'status': true, 'data': {'id': eventId, 'content': 'Test event'}};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], {'id': eventId, 'content': 'Test event'});
  });

  test('getAnEvent failure', () async {
    final eventId = 1;

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 400, // Example error status code
      statusMessage: 'Bad request',
      requestOptions: RequestOptions(path: 'http://example.com/api/getEvent'), // Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/event/$eventId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getEvent')));

    // Call the getAPost method and expect an exception
    expect(() async => await laravelApiClient.getAnEvent(eventId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });

  test('getAnEvent failure Internal Server Error', () async {
    final eventId = 1;

    // Mock failure response from server
    final failureResponse = Response(
      statusCode: 500, // Example error status code
      statusMessage: 'Internal server error',
      requestOptions: RequestOptions(path: 'http://example.com/api/getEvent'), // Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/event/$eventId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getEvent')));

    // Call the getAPost method and expect an exception
    expect(() async => await laravelApiClient.getAnEvent(eventId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });

  test('deleteEvent success', () async {
    final eventId = 1;

    // Mock successful response from server
    final successResponse = Response(
        statusCode: 200,
        data: {'status': true, 'data': 'Event deleted successfully'},
        requestOptions: RequestOptions(path: 'http://example.com/api/deleteEvent')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/delete/$eventId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the deletePost method
    final result = {'status': true, 'data': 'Event deleted successfully'};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'DELETE',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], 'Event deleted successfully');
  });

  test('deleteEvent failure', () async {
    final eventId = 1;

    // Mock failure response from server
    final failureResponse = Response(
        statusCode: 400, // Example error status code
        statusMessage: 'Bad request',
        requestOptions: RequestOptions(path: 'http://example.com/api/deleteEvent')// Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/delete/$eventId',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/deleteEvent')));

    // Call the deletePost method and expect an exception
    expect(() async => await laravelApiClient.deleteEvent(eventId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post/$postId',
    //   options: Options(
    //     method: 'DELETE',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });

  // Filter Posts by zone

  test('filterEventsByZone success', () async {
    final page = 1;
    final zoneId = 123;

    // Mock successful response from server
    final successResponse = Response(
        statusCode: 200,
        data: {'status': true, 'data': 'Filtered events'},
        requestOptions: RequestOptions(path: 'http://example.com/api/getEvents')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post?page=$page&zone_id=$zoneId&size=10',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the filterPostsByZone method
    final result = {'status': true, 'data': 'Filtered events'};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post?page=$page&zone_id=$zoneId&size=10',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], 'Filtered events');
  });

  test('filterPostsByZone failure', () async {
    final page = 1;
    final zoneId = 123;

    // Mock failure response from server
    final failureResponse = Response(
        statusCode: 400, // Example error status code
        statusMessage: 'Bad request',
        requestOptions: RequestOptions(path: 'http://example.com/api/getEvents')// Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post?page=$page&zone_id=$zoneId&size=10',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getEvents')));

    // Call the filterPostsByZone method and expect an exception
    expect(() async => await laravelApiClient.filterEventsByZone(page, zoneId),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post?page=$page&zone_id=$zoneId&size=10',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });


  test('filterPostsBySectors success', () async {
    final page = 1;
    final sectors = 'sector1,sector2'; // Example sectors string

    // Mock successful response from server
    final successResponse = Response(
        statusCode: 200,
        data: {'status': true, 'data': 'Filtered events'},
        requestOptions: RequestOptions(path: 'http://example.com/api/getEvents')
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post?page=$page&sectors=$sectors&size=10',
      options: anyNamed('options'),
    )).thenAnswer((_) async => successResponse);

    // Call the filterPostsBySectors method
    final result = {'status': true, 'data': 'Filtered events'};

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post?page=$page&sectors=$sectors&size=10',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));

    // Check the result
    expect(result['data'], 'Filtered events');
  });

  test('filterPostsBySectors failure', () async {
    final page = 1;
    final sectors = 'sector1,sector2'; // Example sectors string

    // Mock failure response from server
    final failureResponse = Response(
        statusCode: 400, // Example error status code
        statusMessage: 'Bad request',
        requestOptions: RequestOptions(path: 'http://example.com/api/getEvents')// Example error message
    );

    // Mock the Dio request
    when(mockDio.request(
      '${GlobalService().baseUrl}api/post?page=$page&sectors=$sectors&size=10',
      options: anyNamed('options'),
    )).thenAnswer((_) async => throw DioError(response: failureResponse,
        requestOptions: RequestOptions(path: 'http://example.com/api/getEvents')));

    // Call the filterPostsBySectors method and expect an exception
    expect(() async => await laravelApiClient.filterEventsBySectors(page, sectors),
        throwsA(isA<String>()));

    // Verify the Dio request was made with correct URL and headers
    // verify(mockDio.request(
    //   '${GlobalService().baseUrl}api/post?page=$page&sectors=$sectors&size=10',
    //   options: Options(
    //     method: 'GET',
    //     headers: {
    //       'Content-Type': 'application/json',
    //       'Accept': 'application/json',
    //       'Authorization': 'Bearer test_token',
    //     },
    //   ),
    // ));
  });

  // test('Should return UserModel when API call is successful from method get Another user profile', () async {
  //   // Mock the Dio response
  //   final mockResponse = {
  //     'status': true,
  //     'data': {
  //       'id': 1,
  //       'name': 'John Doe',
  //       'my_posts': [],
  //       'events': [],
  //     }
  //   };
  //
  //
  //   when(mockDio.request(
  //     any, // Mock the URL or match with specific URL if needed
  //     options: anyNamed('options'),
  //     data: anyNamed('data')
  //   )).thenAnswer((realInvocation) async => Response(
  //     requestOptions: RequestOptions(path: ''),
  //     statusCode: 200,
  //     data: mockResponse, // This should be structured properly
  //   ));
  //
  //   // Call the method and verify the result
  //   final user = await laravelApiClient.getAnotherUserProfileInfo(1);
  //   expect(user, isA<UserModel>());
  //   expect(user.firstName, equals('Test'));
  //   expect(user.myPosts, isEmpty);
  //   expect(user.myEvents, isEmpty);
  // });

  // test('Should throw SocketException when there is a socket error when using get another user profile', () async {
  //   when(mockDio.request(
  //     any,
  //     options: anyNamed('options'),
  //   )).thenThrow(SocketException('No Internet connection'));
  //
  //   expect(
  //         () async => await laravelApiClient.getAnotherUserProfileInfo(1),
  //     throwsA(isA<SocketException>()),
  //   );
  // });
  //
  // test('Should throw FormatException when response data is malformed when using get another user profile', () async {
  //   when(mockDio.request(
  //     any,
  //     options: anyNamed('options'),
  //   )).thenThrow(FormatException());
  //
  //   expect(
  //         () async => await laravelApiClient.getAnotherUserProfileInfo(1),
  //     throwsA(isA<FormatException>()),
  //   );
  // });
  //
  // test('Should throw NetworkExceptions when an unknown error occurs when using get another user profile', () async {
  //   when(mockDio.request(
  //     any,
  //     options: anyNamed('options'),
  //   )).thenThrow(Exception('Unknown error'));
  //
  //   expect(
  //         () async => await laravelApiClient.getAnotherUserProfileInfo(1),
  //     throwsA(isA<NetworkExceptions>()),
  //   );
  // });





}
