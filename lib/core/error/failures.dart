import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure([String? message])
      : super(message ?? 'Server error occurred');
}

class CacheFailure extends Failure {
  const CacheFailure([String? message])
      : super(message ?? 'Cache error occurred');
}

class NetworkFailure extends Failure {
  const NetworkFailure([String? message])
      : super(message ?? 'Network error occurred');
}

// Dio-specific failures
class TimeoutFailure extends Failure {
  const TimeoutFailure([String? message]) : super(message ?? 'Request timeout');
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([String? message])
      : super(message ?? 'Connection failed');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([String? message])
      : super(message ?? 'Unauthorized access');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([String? message])
      : super(message ?? 'Resource not found');
}
