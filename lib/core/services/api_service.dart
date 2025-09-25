import 'package:dio/dio.dart';
import 'package:ecommerce_flutter/core/services/endpoints.dart';

class ApiService {
  final Dio _dio;

  ApiService()
      : _dio = Dio(BaseOptions(
          baseUrl: EndPoints.baseUrl,
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          sendTimeout: const Duration(seconds: 30),
        )) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        print('🚀 Request: ${options.method} ${options.uri}');
        print('📤 Headers: ${options.headers}');
        if (options.data != null) {
          print('📦 Data: ${options.data}');
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        print(
            '✅ Response: ${response.statusCode} ${response.requestOptions.uri}');
        print('📥 Data: ${response.data}');
        handler.next(response);
      },
      onError: (DioError e, handler) {
        print('❌ Error: ${e.message}');
        print('🔗 URL: ${e.requestOptions.uri}');
        if (e.response != null) {
          print('📊 Status: ${e.response?.statusCode}');
          print('📥 Response Data: ${e.response?.data}');
        }
        handler.next(e);
      },
    ));
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      return await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: Options(responseType: responseType),
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      return await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(responseType: responseType),
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      return await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(responseType: responseType),
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    ResponseType responseType = ResponseType.json,
  }) async {
    try {
      return await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: Options(responseType: responseType),
      );
    } on DioError catch (e) {
      throw _handleDioError(e);
    }
  }

  // Handle all status codes and network errors
  Exception _handleDioError(DioError e) {
    if (e.response != null) {
      final statusCode = e.response?.statusCode ?? 0;
      final data = e.response?.data;
      String message = 'Something went wrong';

      if (data != null && data is Map && data.containsKey('message')) {
        message = data['message'];
      } else {
        switch (statusCode) {
          case 400:
            message = 'Bad request';
            break;
          case 401:
            message = 'Unauthorized. Please login again.';
            break;
          case 403:
            message = 'Forbidden';
            break;
          case 404:
            message = 'Not found';
            break;
          case 500:
            message = 'Internal server error';
            break;
          default:
            message = 'Error $statusCode: ${e.response?.statusMessage}';
        }
      }
      return Exception(message);
    } else {
      if (e.type == DioErrorType.connectionTimeout ||
          e.type == DioErrorType.sendTimeout ||
          e.type == DioErrorType.receiveTimeout) {
        return Exception('Connection timed out. Please try again.');
      } else if (e.type == DioErrorType.cancel) {
        return Exception('Request was cancelled.');
      } else {
        return Exception(
            'Network error. Please check your internet connection.');
      }
    }
  }
}
