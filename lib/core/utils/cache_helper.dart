/// Helper for safe caching operations.
///
/// This class provides methods to cache data without throwing errors
/// when cache operations fail, allowing the main data flow to continue.
class CacheHelper {
  /// Safely executes a cache operation, ignoring any failures
  ///
  /// This is useful when we want to cache data but don't want
  /// cache failures to affect the main operation.
  static Future<void> safeCache(Future<void> Function() cacheOperation) async {
    try {
      await cacheOperation();
    } catch (_) {
      // Ignore cache errors when we have data
      // This prevents cache failures from breaking the main flow
    }
  }

  /// Safely executes a cache operation without waiting for completion
  ///
  /// This is useful for fire-and-forget cache operations.
  static void safeCacheAsync(Future<void> Function() cacheOperation) {
    cacheOperation().catchError((_) {
      // Ignore cache errors when we have data
    });
  }
}
