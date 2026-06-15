part of 'fp.dart';

/// Utility class to wrap result data
///
/// Evaluate the result using a switch statement:
/// ```dart
/// switch (result) {
///   case Ok(): {
///     print(result.value);
///   }
///   case Err(): {
///     print(result.failure);
///   }
/// }
/// ```
sealed class const Result<T>() {
  bool get isOk => this is Ok<T>;

  bool get isFail => this is Err<T>;

  T unwrap() {
    return switch (this) {
      Ok(value: final v) => v,
      Err(failure: final f) => throw StateError('Chamou unwrap em Err: $f'),
    };
  }

  T unwrapOr(T defaultValue) {
    return switch (this) {
      Ok(value: final v) => v,
      Err() => defaultValue,
    };
  }

  T unwrapOrElse(T Function(Failure failure) orElse) {
    return switch (this) {
      Ok(value: final v) => v,
      Err(failure: final f) => orElse(f),
    };
  }

  Result<U> map<U>(U Function(T value) transform) {
    return switch (this) {
      Ok(value: final v) => Ok(transform(v)),
      Err(failure: final f, stackTrace: final s) => Err(f, s),
    };
  }

  Result<T> mapErr(Failure Function(Failure failure) transform) {
    return switch (this) {
      Ok(value: final v) => Ok(v),
      Err(failure: final f, stackTrace: final s) => Err(transform(f), s),
    };
  }

  Result<U> flatMap<U>(Result<U> Function(T value) transform) {
    return switch (this) {
      Ok(value: final v) => transform(v),
      Err(failure: final f, stackTrace: final s) => Err(f, s),
    };
  }
}

/// Subclass of Result for values
final class const Ok<T>(final T value) extends Result<T> {
  @override
  String toString() => 'Result<$T>.ok($value)';
}

const ok = Ok(unit);

/// Subclass of Result for failures
final class const Err<T>(final Failure failure, [final StackTrace? stackTrace])
    extends Result<T> {
  @override
  String toString() => 'Result<$T>.err($failure, $stackTrace)';
}
