
import 'package:flutter_test/flutter_test.dart';

void main() {

  testWidgets('Widget renders correctly and interacts', (WidgetTester tester) async {


  });
}







// import 'package:flutter_test/flutter_test.dart';
// import 'package:mapnrank/app/providers/dio_client.dart';
// import 'package:mockito/mockito.dart';
// import 'package:dio/dio.dart';// Replace with your actual import
//
// class MockDio extends Mock implements Dio {
//
// }
//
// void main() {
//   group('DioClient', () {
//     late DioClient dioClient;
//     late MockDio mockDio;
//
//     setUp(() {
//       mockDio = MockDio();
//
//       when(mockDio.options).thenReturn(BaseOptions(
//         baseUrl: 'https://example.com',
//         connectTimeout: Duration(milliseconds: 60000),
//         receiveTimeout: Duration(milliseconds: 60000),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'X-Requested-With': 'XMLHttpRequest',
//           'Accept-Language': 'en',
//         },
//       ));
//
//       dioClient = DioClient('https://example.com', mockDio, interceptors: Interceptors(),);
//     });
//
//     test('postUri makes a successful POST request', () async {
//       final uri = Uri.parse('https://example.com/test');
//       final data = {'key': 'value'};
//       final options = Options(
//         sendTimeout: Duration(milliseconds: 60000),
//         //connectTimeout: Duration(milliseconds: 60000),
//         receiveTimeout: Duration(milliseconds: 60000),
//         headers: {
//           'Content-Type': 'application/json; charset=UTF-8',
//           'X-Requested-With': 'XMLHttpRequest',
//           'Accept-Language': 'en',
//         },);
//       final response = Response(
//         requestOptions: RequestOptions(path: uri.toString()),
//         data: {'responseKey': 'responseValue'},
//         statusCode: 200,
//       );
//
//       when(mockDio.postUri(
//         uri,
//         data: anyNamed('data'),
//         options: anyNamed('options'),
//         onSendProgress: anyNamed('onSendProgress'),
//         onReceiveProgress: anyNamed('onReceiveProgress'),
//       )).thenAnswer((_) async => response);
//
//       final result = await dioClient.postUri(
//         uri,
//         data: data,
//         options: options,
//         onSendProgress: (int sent, int total) {
//           print('Sent $sent of $total');
//         },
//         onReceiveProgress: (int received, int total) {
//           print('Received $received of $total');
//         },
//       );
//
//       expect(result.data, {'responseKey': 'responseValue'});
//       expect(result.statusCode, 200);
//
//       verify(mockDio.postUri(
//         uri,
//         data: data,
//         options: options,
//         onSendProgress: anyNamed('onSendProgress'),
//         onReceiveProgress: anyNamed('onReceiveProgress'),
//       )).called(1);
//     });
//   });
// }
