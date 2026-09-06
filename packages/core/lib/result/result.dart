import 'failure.dart';

/// Lightweight Result type representing either Success([T]) or Failure([F]).
sealed class Result<T, F extends Failure> {
  const Result();

  factory Result.success(T value) = Success<T, F>;
  factory Result.failure(F failure) = FailureResult<T, F>;

  bool get isSuccess => this is Success<T, F>;
  bool get isFailure => this is FailureResult<T, F>;

  T? get valueOrNull => switch (this) {
        Success(value: final v) => v,
        FailureResult() => null,
      };

  F? get failureOrNull => switch (this) {
        Success() => null,
        FailureResult(failure: final f) => f,
      };

  R fold<R>({
    required R Function(T value) onSuccess,
    required R Function(F failure) onFailure,
  }) {
    return switch (this) {
      Success(value: final v) => onSuccess(v),
      FailureResult(failure: final f) => onFailure(f),
    };
  }
}

final class Success<T, F extends Failure> extends Result<T, F> {
  const Success(this.value);
  final T value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T, F> &&
          runtimeType == other.runtimeType &&
          value == other.value;

  @override
  int get hashCode => value.hashCode;
}

final class FailureResult<T, F extends Failure> extends Result<T, F> {
  const FailureResult(this.failure);
  final F failure;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureResult<T, F> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
