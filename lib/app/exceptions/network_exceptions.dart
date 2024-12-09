// coverage:ignore-file
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as _get;

import '../routes/app_routes.dart';

abstract class NetworkExceptions {
  static String handleResponse(Response response) {
    int statusCode = response?.statusCode ?? 0;
    switch (statusCode) {
      case 400:
      case 401:
      case 403:
        _get.Get.offAllNamed(Routes.LOGIN);
        return "Unauthorized Request";
        break;
      case 404:
        return "Not found";
        break;
      case 409:
        return "Error due to a conflict";
        break;
      case 408:
        return "Connection request timeout";
        break;
      case 500:
        return "Internal Server Error";
        break;
      case 503:
        return "Service unavailable";
        break;
      case 422:
        return "Invalid Credentials";
        break;
      default:
        return "Received invalid status code";
    }
  }

  static String getDioException(error) {
    if (error is Exception) {
      try {
        var errorMessage = "";
        if (error is DioError) {
          switch (error.type) {
            case DioExceptionType.cancel:
              errorMessage = "Request Cancelled";
              break;
            case DioExceptionType.connectionTimeout:
              errorMessage = "Connection request timeout";
              break;
            case DioExceptionType.connectionError:
              errorMessage = "No internet connection";
              break;
            case DioExceptionType.receiveTimeout:
              errorMessage = "Send timeout in connection with API server";
              break;
            case DioExceptionType.badResponse:
              errorMessage = NetworkExceptions.handleResponse(error.response!);
              break;
            case DioExceptionType.sendTimeout:
              errorMessage = "Send timeout in connection with API server";
              break;
            case DioExceptionType.badCertificate:
              // TODO: Handle this case.
            case DioExceptionType.unknown:
              // TODO: Handle this case.
          }
        } else if (error is SocketException) {
          errorMessage = "No internet connection";
        } else {
          errorMessage = "Unexpected error occurred";
        }
        return errorMessage;
      } on FormatException {
        return "Unexpected error occurred";
      } catch (_) {
        return "Unexpected error occurred";
      }
    } else {
      if (error.toString().contains("is not a subtype of")) {
        return "Unable to process the data";
      } else {
        return "Unexpected error occurred";
      }
    }
  }
}
