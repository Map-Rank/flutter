
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('Widget renders correctly and interacts', (WidgetTester tester) async {


  });
}







// import 'dart:convert';
// import 'package:dio/dio.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:dio/dio.dart' as dio;
// import 'package:mapnrank/app/models/user_model.dart';
// import 'package:mapnrank/app/providers/dio_client.dart';
// import 'package:mapnrank/app/providers/laravel_provider.dart';
// import 'package:mapnrank/app/services/auth_service.dart';
// import 'package:mapnrank/app/services/global_services.dart';
// import 'package:mockito/mockito.dart';
// import 'package:get/get.dart';
//
// // Mock Classes
// class MockDioClient extends Mock implements DioClient {
//   late final String baseUrl;
//   Dio? dioo;
//   Options? optionsNetwork;
//   Options? optionsCache;
//   late final List<Interceptor>? interceptors;
//   final _progress = <String>[].obs;
//   MockDioClient(this.baseUrl, this.dioo);
//
//   @override
//   Future<dynamic> postUri(
//       Uri uri, {
//         data,
//         required Options options,
//         CancelToken? cancelToken,
//         required ProgressCallback onSendProgress,
//         required ProgressCallback onReceiveProgress,
//       }) async {
//
//   }
// }
//
// class MockLaravelApiClient extends GetxService with Mock implements LaravelApiClient {
//   late String baseUrl;
//   late MockDioClient dioClient;
//   late dio.Options optionsNetwork;
//   late dio.Options optionsCache;
// }
//
// // Main Test Code
// void main() {
//   TestWidgetsFlutterBinding.ensureInitialized();
//
//   group('LaravelApiClient', () {
//     late MockLaravelApiClient mockLaravelApiClient;
//     late MockDioClient mockDioClient;
//
//     setUp(() {
//       mockLaravelApiClient = MockLaravelApiClient();
//
//       Get.lazyPut(() => mockLaravelApiClient);
//
//       mockLaravelApiClient.baseUrl = 'https://example.com/';
//       mockDioClient = MockDioClient(mockLaravelApiClient.baseUrl, dio.Dio());
//       mockLaravelApiClient.dioClient = mockDioClient;
//       mockLaravelApiClient.optionsNetwork = dio.Options();
//       mockLaravelApiClient.optionsCache = dio.Options();
//     });
//
//     test('register', () async {
//       final user = UserModel(email: 'test@example.com', password: 'password');
//       final Uri uri = Uri.parse('${mockLaravelApiClient.baseUrl}register');
//
//       final mockResponse = mockLaravelApiClient.dioClient.postUri(
//         uri,
//         data: {
//           'status': true,
//           'data': {
//             'id': 1,
//             'first_name': 'Test User',
//             'email': 'test@example.com',
//           }
//         },
//         options: mockLaravelApiClient.optionsNetwork,
//         onSendProgress: (int count, int total) {
//           print('Register Progress: $count/$total');
//         },
//         onReceiveProgress: (int count, int total) {
//           print('Register Progress: $count/$total');
//         },
//       );
//
//       when( mockLaravelApiClient.dioClient.postUri(
//         uri,
//         data: {
//           'status': true,
//           'data': {
//             'id': 1,
//             'first_name': 'Test User',
//             'email': 'test@example.com',
//           }
//         },
//         options: mockLaravelApiClient.optionsNetwork,
//         onSendProgress: (int count, int total) {
//           print('Register Progress: $count/$total');
//         },
//         onReceiveProgress: (int count, int total) {
//           print('Register Progress: $count/$total');
//         },
//       )).thenAnswer((_) async => mockResponse);
//
//       final result = await mockLaravelApiClient.register(user);
//
//       expect(result.id, 1);
//       expect(result.firstName, 'Test User');
//       expect(result.email, 'test@example.com');
//       expect(UserModel.auth, true);
//     });
//
//     test('login', () async {
//       final user = UserModel(email: 'test@example.com', password: 'password');
//       final Uri uri = Uri.parse('${mockLaravelApiClient.baseUrl}login');
//
//       final mockResponse = mockLaravelApiClient.dioClient.postUri(
//         uri,
//         data: {
//           'status': true,
//           'data': {
//             'id': 1,
//             'first_name': 'Test User',
//             'email': 'test@example.com',
//           }
//         },
//         options: mockLaravelApiClient.optionsNetwork,
//         onSendProgress: (int count, int total) {
//           print('Register Progress: $count/$total');
//         },
//         onReceiveProgress: (int count, int total) {
//           print('Register Progress: $count/$total');
//         },
//       );
//
//       when( mockLaravelApiClient.dioClient.postUri(
//         uri,
//         data: anyNamed('data'),
//         options: mockLaravelApiClient.optionsNetwork,
//         onSendProgress: (int count, int total) {
//           print('Register Progress: $count/$total');
//         },
//         onReceiveProgress: (int count, int total) {
//           print('Register Progress: $count/$total');
//         },
//       )).thenAnswer((_) async => mockResponse);
//
//       final result = await mockLaravelApiClient.login(user);
//
//       expect(result.id, 1);
//       expect(result.firstName, 'Test User');
//       expect(result.email, 'test@example.com');
//       expect(UserModel.auth, true);
//     });
//   });
// }
