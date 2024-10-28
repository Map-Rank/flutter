// coverage:ignore-file
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../common/custom_trace.dart';
import '../exceptions/network_exceptions.dart';

const _defaultConnectTimeout = Duration.millisecondsPerMinute;
const _defaultReceiveTimeout = Duration.millisecondsPerMinute;

class DioClient {
  final String baseUrl;

  late Dio dioo;
  late Options optionsNetwork;
  late Options optionsCache;
  final List<Interceptor>? interceptors;
  final _progress = <String>[].obs;

  DioClient(
      this.baseUrl,
      Dio? dio, {
        this.interceptors,
      }) {
    dioo = dio ?? Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(milliseconds: _defaultConnectTimeout,),
      receiveTimeout: Duration(milliseconds: _defaultReceiveTimeout),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'X-Requested-With': 'XMLHttpRequest',
        'Accept-Language': 'en',
      },
    ));

    if (interceptors?.isNotEmpty ?? false) {
      dioo.interceptors.addAll(interceptors as Iterable<Interceptor>);
    }
    if (kDebugMode) {
      dioo.interceptors.add(LogInterceptor(
        responseBody: true,
        error: true,
        requestHeader: false,
        responseHeader: false,
        request: false,
        requestBody: false,
      ));
    }

    optionsNetwork = Options(headers: dioo.options.headers);
    optionsCache = Options(headers: dioo.options.headers);
  }

  Future<dynamic> get(
      String uri, {
        required Map<String, dynamic> queryParameters,
        required Options options,
        required CancelToken cancelToken,
        required ProgressCallback onReceiveProgress,
      }) async {
    try {
      var response = await dioo.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<dynamic> getUri(
      Uri uri, {
        required Options options,
        CancelToken? cancelToken,
        required ProgressCallback onReceiveProgress,
      }) async {
    CustomTrace programInfo = CustomTrace(StackTrace.current);
    try {
      _startProgress(programInfo);
      var response = await dioo.getUri(
        uri,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      _endProgress(programInfo);
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    } finally {
      _endProgress(programInfo);
    }
  }

  void _endProgress(CustomTrace programInfo) {
    try {
      _progress.remove(_getTaskName(programInfo));
    } on FlutterError {}
  }

  void _startProgress(CustomTrace programInfo) {
    try {
      _progress.add(_getTaskName(programInfo));
    } on FlutterError {}
  }

  Future<dynamic> post(
      String uri, {
        data,
        required Map<String, dynamic> queryParameters,
        required Options options,
        required CancelToken cancelToken,
        required ProgressCallback onSendProgress,
        required ProgressCallback onReceiveProgress,
      }) async {
    try {
      var response = await dioo.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    }
  }

  Future<dynamic> postUri(
      Uri uri, {
        data,
        required Options options,
        CancelToken? cancelToken,
        required ProgressCallback onSendProgress,
        required ProgressCallback onReceiveProgress,
      }) async {
    CustomTrace programInfo = CustomTrace(StackTrace.current);
    try {
      _startProgress(programInfo);
      var response = await dioo.postUri(
        uri,
        data: data,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      _endProgress(programInfo);
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      throw NetworkExceptions.getDioException(e);
    } finally {
      _endProgress(programInfo);
    }
  }

  String _getTaskName(CustomTrace programInfo) {
    return programInfo.callerFunctionName!.split('.')[1];
  }
}


// import 'dart:io';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
//
// import '../../common/custom_trace.dart';
// import '../exceptions/network_exceptions.dart';
//
// const _defaultConnectTimeout = Duration.millisecondsPerMinute;
// const _defaultReceiveTimeout = Duration.millisecondsPerMinute;
//
// class DioClient {
//   final String baseUrl;
//
//   Dio? dioo;
//   Options? optionsNetwork;
//   Options? optionsCache;
//   final List<Interceptor>? interceptors;
//   final _progress = <String>[].obs;
//
//   DioClient(
//       this.baseUrl,
//       Dio dio, {
//         this.interceptors,
//       }) {
//     dioo?.options = BaseOptions(
//       connectTimeout: Duration(milliseconds: 60000),
//       receiveTimeout: Duration(milliseconds: 60000),
//       headers: {
//         'Content-Type': 'application/json; charset=UTF-8',
//         'X-Requested-With': 'XMLHttpRequest',
//         'Accept-Language': 'en',
//       },
//     );
//     // dioo = dio ?? Dio();
//     // dioo
//     //   ?..options.baseUrl = baseUrl
//     //   ..options.connectTimeout = Duration(milliseconds: _defaultConnectTimeout)
//     //   ..options.receiveTimeout = Duration(milliseconds: _defaultReceiveTimeout)
//     //   ..httpClientAdapter
//     //   ..options.headers = {'Content-Type': 'application/json; charset=UTF-8', 'X-Requested-With': 'XMLHttpRequest', 'Accept-Language': 'en'};
//     if (interceptors?.isNotEmpty ?? false) {
//       dioo?.interceptors.addAll(interceptors as Iterable<Interceptor>);
//     }
//     if (kDebugMode) {
//       dioo?.interceptors.add(LogInterceptor(responseBody: true, error: true, requestHeader: false, responseHeader: false, request: false, requestBody: false));
//     }
//     optionsNetwork = Options(headers: dioo?.options.headers);
//     optionsCache = Options(headers: dioo?.options.headers);
//     // if (!kIsWeb && !kDebugMode) {
//     //   optionsNetwork = Options();
//     //       buildCacheOptions(Duration(days: 3), forceRefresh: true, options: optionsNetwork);
//     //   optionsCache = buildCacheOptions(Duration(minutes: 10), forceRefresh: false, options: optionsCache);
//     //   _dio?.interceptors.add(DioCacheManager(CacheConfig(baseUrl: baseUrl)).interceptor);
//     // }
//   }
//
//   Future<dynamic> get(
//       String uri, {
//         required Map<String, dynamic> queryParameters,
//         required Options options,
//         required CancelToken cancelToken,
//         required ProgressCallback onReceiveProgress,
//       }) async {
//     try {
//       var response = await dioo?.get(
//         uri,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onReceiveProgress: onReceiveProgress,
//       );
//       return response;
//     } on SocketException catch (e) {
//       throw SocketException(e.toString());
//     } on FormatException catch (_) {
//       throw const FormatException("Unable to process the data");
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     }
//   }
//
//   Future<dynamic> getUri(
//       Uri uri, {
//         data,
//         required Options options,
//         CancelToken? cancelToken,
//         required ProgressCallback onReceiveProgress,
//       }) async {
//     CustomTrace programInfo = CustomTrace(StackTrace.current);
//     try {
//       _startProgress(programInfo);
//       var response = await dioo?.getUri(
//         uri,
//         options: options,
//         cancelToken: cancelToken,
//         onReceiveProgress: onReceiveProgress,
//       );
//       _endProgress(programInfo);
//       return response;
//     } on SocketException catch (e) {
//       throw SocketException(e.toString());
//     } on FormatException catch (_) {
//       throw const FormatException("Unable to process the data");
//     } on FlutterError catch (e) {
//       print(e.runtimeType);
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     } finally {
//       _endProgress(programInfo);
//     }
//   }
//
//   void _endProgress(CustomTrace programInfo) {
//     try {
//       _progress.remove(_getTaskName(programInfo));
//     } on FlutterError {}
//   }
//
//   void _startProgress(CustomTrace programInfo) {
//     try {
//       _progress.add(_getTaskName(programInfo));
//     } on FlutterError {}
//   }
//
//   Future<dynamic> post(
//       String uri, {
//         data,
//         required Map<String, dynamic> queryParameters,
//         required Options options,
//         required CancelToken cancelToken,
//         required ProgressCallback onSendProgress,
//         required ProgressCallback onReceiveProgress,
//       }) async {
//     try {
//       var response = await dioo?.post(
//         uri,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       return response;
//     } on FormatException catch (_) {
//       throw const FormatException("Unable to process the data");
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     }
//   }
//
//   Future<dynamic> postUri(
//       Uri uri, {
//         data,
//         required Options options,
//         CancelToken? cancelToken,
//         required ProgressCallback onSendProgress,
//         required ProgressCallback onReceiveProgress,
//       }) async {
//     CustomTrace programInfo = CustomTrace(StackTrace.current);
//     try {
//       _startProgress(programInfo);
//       var response = await dioo?.postUri(
//         uri,
//         data: data,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       _endProgress(programInfo);
//       return response;
//     } on FormatException catch (_) {
//       throw const FormatException("Unable to process the data");
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     } finally {
//       _endProgress(programInfo);
//     }
//   }
//
//   Future<dynamic> put(
//       String uri, {
//         data,
//         required Map<String, dynamic> queryParameters,
//         required Options options,
//         required CancelToken cancelToken,
//         required ProgressCallback onSendProgress,
//         required ProgressCallback onReceiveProgress,
//       }) async {
//     try {
//       var response = await dioo?.put(
//         uri,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       return response;
//     } on FormatException catch (_) {
//       throw FormatException("Unable to process the data");
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     }
//   }
//
//   Future<dynamic> putUri(
//       Uri uri, {
//         data,
//         required Options options,
//         required CancelToken cancelToken,
//         required ProgressCallback onSendProgress,
//         required ProgressCallback onReceiveProgress,
//       }) async {
//     CustomTrace programInfo = CustomTrace(StackTrace.current);
//     try {
//       _startProgress(programInfo);
//       var response = await dioo?.putUri(
//         uri,
//         data: data,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       _endProgress(programInfo);
//       return response;
//     } on FormatException catch (_) {
//       throw FormatException("Unable to process the data");
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     } finally {
//       _endProgress(programInfo);
//     }
//   }
//
//   Future<dynamic> patch(
//       String uri, {
//         data,
//         required Map<String, dynamic> queryParameters,
//         required Options options,
//         required CancelToken cancelToken,
//         required ProgressCallback onSendProgress,
//         required ProgressCallback onReceiveProgress,
//       }) async {
//     try {
//       var response = await dioo?.patch(
//         uri,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       return response;
//     } on FormatException catch (_) {
//       throw const FormatException("Unable to process the data");
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     }
//   }
//
//   Future<dynamic> patchUri(
//       Uri uri, {
//         data,
//         required Options options,
//         required CancelToken cancelToken,
//         required ProgressCallback onSendProgress,
//         required ProgressCallback onReceiveProgress,
//       }) async {
//     CustomTrace programInfo = CustomTrace(StackTrace.current);
//     try {
//       _startProgress(programInfo);
//       var response = await dioo?.patchUri(
//         uri,
//         data: data,
//         options: options,
//         cancelToken: cancelToken,
//         onSendProgress: onSendProgress,
//         onReceiveProgress: onReceiveProgress,
//       );
//       _endProgress(programInfo);
//       return response;
//     } on FormatException catch (_) {
//       throw const FormatException("Unable to process the data");
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     } finally {
//       _endProgress(programInfo);
//     }
//   }
//
//   Future<dynamic> delete(
//       String uri, {
//         data,
//         required Map<String, dynamic> queryParameters,
//         required Options options,
//         required CancelToken cancelToken,
//       }) async {
//     try {
//       var response = await dioo?.delete(
//         uri,
//         data: data,
//         queryParameters: queryParameters,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       return response;
//     } on FormatException catch (_) {
//       throw const FormatException("Unable to process the data");
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     }
//   }
//
//   Future<dynamic> deleteUri(
//       Uri uri, {
//         data,
//         required Options options,
//         required CancelToken cancelToken,
//       }) async {
//     CustomTrace programInfo = CustomTrace(StackTrace.current);
//     try {
//       _startProgress(programInfo);
//       var response = await dioo?.deleteUri(
//         uri,
//         data: data,
//         options: options,
//         cancelToken: cancelToken,
//       );
//       _endProgress(programInfo);
//       return response;
//     } on FormatException catch (_) {
//       throw const FormatException("Unable to process the data");
//     } catch (e) {
//       throw NetworkExceptions.getDioException(e);
//     } finally {
//       _endProgress(programInfo);
//     }
//   }
//
//   bool isLoading({required String task, required List<String> tasks}) {
//     if (tasks != null) {
//       return _progress.any((_task) => _progress.contains(_task));
//     }
//     return _progress.contains(task);
//   }
//
//   String _getTaskName(programInfo) {
//     return programInfo.callerFunctionName.split('.')[1];
//   }
// }
//
// /*
// *     (_dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
//         (HttpClient client) {
//       client.badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//       return client;
//     };
// *
// * */
