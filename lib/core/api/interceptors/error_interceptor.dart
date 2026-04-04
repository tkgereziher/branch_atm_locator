import 'package:dio/dio.dart';
import '../../error/exceptions.dart';
import '../../services/secure_storage_service.dart';

class ErrorInterceptor extends Interceptor {
  final SecureStorageService _storageService;

  ErrorInterceptor(this._storageService);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      // Logic for token refresh could go here.
      // For now, let's just clear tokens and potentially navigate to login.
      await _storageService.clearTokens();
    }
    
    // Convert DioException to a more generic app-level exception
    final appException = _mapDioExceptionToAppException(err);
    return handler.next(DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: appException,
    ));
  }

  AppException _mapDioExceptionToAppException(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ConnectionException('Connection timed out');
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) return UnauthorizedException('Unauthorized');
        if (statusCode == 404) return NotFoundException('Resource not found');
        return ServerException('Server error: $statusCode');
      default:
        return UnknownException('An unexpected error occurred');
    }
  }
}
