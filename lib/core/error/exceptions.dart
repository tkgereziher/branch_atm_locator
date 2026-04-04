abstract class AppException implements Exception {
  final String message;
  final String? code;

  AppException(this.message, {this.code});

  @override
  String toString() => '$runtimeType: $message';
}

class ConnectionException extends AppException {
  ConnectionException(super.message, {super.code});
}

class ServerException extends AppException {
  ServerException(super.message, {super.code});
}

class UnauthorizedException extends AppException {
  UnauthorizedException(super.message, {super.code});
}

class NotFoundException extends AppException {
  NotFoundException(super.message, {super.code});
}

class UnknownException extends AppException {
  UnknownException(super.message, {super.code});
}
