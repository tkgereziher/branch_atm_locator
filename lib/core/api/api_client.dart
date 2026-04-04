import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../constants/api_constants.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/error_interceptor.dart';
import '../services/secure_storage_service.dart';

class ApiClient {
  late final Dio dio;
  final SecureStorageService _storageService;

  ApiClient(this._storageService) {
    dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: Duration(milliseconds: ApiConstants.connectTimeout),
      receiveTimeout: Duration(milliseconds: ApiConstants.receiveTimeout),
      contentType: 'application/json',
      responseType: ResponseType.json,
    ));

    // Add interceptors
    dio.interceptors.add(AuthInterceptor(_storageService));
    dio.interceptors.add(ErrorInterceptor(_storageService));
    
    // Add logger
    dio.interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: true,
      maxWidth: 90,
    ));
  }

  // Generic Request methods
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    return await dio.get(path, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    return await dio.post(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
  }

  Future<Response> put(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    return await dio.put(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
  }

  Future<Response> delete(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options, CancelToken? cancelToken}) async {
    return await dio.delete(path, data: data, queryParameters: queryParameters, options: options, cancelToken: cancelToken);
  }
}
