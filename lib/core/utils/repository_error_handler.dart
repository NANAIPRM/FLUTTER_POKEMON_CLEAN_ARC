import '../error/failures.dart';

/// Handles error classification and mapping for repository operations.
/// 
/// This class centralizes error handling logic and makes it reusable
/// across different repositories.
class RepositoryErrorHandler {
  /// Determines if we should try cache when remote operation fails
  static bool shouldRetryFromCache(Failure failure) {
    return failure is ServerFailure ||
           failure is TimeoutFailure ||
           failure is ConnectionFailure;
  }

  /// Maps any error to appropriate Failure
  static Failure mapToFailure(dynamic error) {
    if (error is Failure) return error;
    return ServerFailure('Unexpected error: ${error.toString()}');
  }

  /// Creates a NetworkFailure with appropriate message for offline scenarios
  static NetworkFailure createOfflineFailure(String additionalContext) {
    return NetworkFailure(
      'No internet connection and no cached data available: $additionalContext',
    );
  }
}
