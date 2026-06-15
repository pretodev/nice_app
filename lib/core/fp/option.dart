part of 'fp.dart';

/// Utility class to wrap optional values
///
/// Evaluate the option using a switch statement:
/// ```dart
/// switch (option) {
///   case Some(): {
///     print(option.value);
///   }
///   case None(): {
///     print('No value');
///   }
/// }
/// ```
sealed class const Option<T>() {
  bool get isSome => this is Some<T>;

  bool get isNone => this is None<T>;

  T unwrap() {
    return switch (this) {
      Some(value: final v) => v,
      None() => throw StateError('Chamou unwrap em None'),
    };
  }

  T unwrapOr(T defaultValue) {
    return switch (this) {
      Some(value: final v) => v,
      None() => defaultValue,
    };
  }

  T unwrapOrElse(T Function() orElse) {
    return switch (this) {
      Some(value: final v) => v,
      None() => orElse(),
    };
  }

  Option<U> map<U>(U Function(T value) transform) {
    return switch (this) {
      Some(value: final v) => Some(transform(v)),
      None() => const None(),
    };
  }

  Option<U> flatMap<U>(Option<U> Function(T value) transform) {
    return switch (this) {
      Some(value: final v) => transform(v),
      None() => const None(),
    };
  }

  T? toNullable() {
    return switch (this) {
      Some(value: final v) => v,
      None() => null,
    };
  }

  static Option<T> fromNullable<T>(T? value) {
    return value != null ? Some(value) : const None();
  }
}

/// Subclass of Option for values
final class const Some<T>(final T value) extends Option<T> {
  @override
  String toString() => 'Option<$T>.some($value)';
}

/// Subclass of Option for absence of values
final class const None<T>() extends Option<T> {
  @override
  String toString() => 'Option<$T>.none()';
}
