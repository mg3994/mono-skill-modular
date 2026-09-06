/// Base class representing domain and data layer failures/errors.
abstract class Failure {
  const Failure({required this.message, this.cause});

  final String message;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message${cause != null ? ' (Cause: $cause)' : ''}';
}

/// Generic database/persistence failure.
final class DatabaseFailure extends Failure {
  const DatabaseFailure(String message, [Object? cause])
      : super(message: message, cause: cause);
}

/// Generic network/API failure.
final class NetworkFailure extends Failure {
  const NetworkFailure(String message, [Object? cause])
      : super(message: message, cause: cause);
}

/// Generic validation failure.
final class ValidationFailure extends Failure {
  const ValidationFailure(String message, [Object? cause])
      : super(message: message, cause: cause);
}

/// Fallback unexpected failure.
final class UnexpectedFailure extends Failure {
  const UnexpectedFailure(String message, [Object? cause])
      : super(message: message, cause: cause);
}
