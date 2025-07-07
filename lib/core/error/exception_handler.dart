import 'package:dio/dio.dart';
import 'failures.dart';

/// Handles Dio exceptions and converts them to appropriate Failure objects
class ExceptionHandler {
  /// Converts DioException to appropriate Failure
  static Failure handleDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutFailure('Request timeout: ${error.message}');

      case DioExceptionType.badResponse:
        return _handleStatusCode(error.response?.statusCode, error.message);

      case DioExceptionType.cancel:
        return ConnectionFailure('Request was cancelled');

      case DioExceptionType.connectionError:
        return NetworkFailure('Connection error: ${error.message}');

      case DioExceptionType.badCertificate:
        return ConnectionFailure('Certificate error: ${error.message}');

      case DioExceptionType.unknown:
      default:
        return ServerFailure('Unknown error: ${error.message}');
    }
  }

  /// Handles HTTP status codes
  static Failure _handleStatusCode(int? statusCode, String? message) {
    switch (statusCode) {
      case 400:
        return ServerFailure('Bad request: $message');
      case 401:
        return UnauthorizedFailure('Unauthorized: $message');
      case 403:
        return UnauthorizedFailure('Forbidden: $message');
      case 404:
        return NotFoundFailure('Not found: $message');
      case 500:
        return ServerFailure('Internal server error: $message');
      case 502:
        return ServerFailure('Bad gateway: $message');
      case 503:
        return ServerFailure('Service unavailable: $message');
      default:
        return ServerFailure('HTTP error ($statusCode): $message');
    }
  }

  /// Handles general exceptions
  static Failure handleException(dynamic error) {
    if (error is DioException) {
      return handleDioException(error);
    }
    return ServerFailure('Unexpected error: $error');
  }
}
