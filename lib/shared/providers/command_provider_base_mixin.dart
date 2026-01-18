import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

AsyncValue<T> invalidState<T>() => AsyncError<T>(
  StateError('Not called yet'),
  StackTrace.current,
);

mixin CommandMixin<T> on $Notifier<AsyncValue<T>> {
  Result<T> emitError<E extends Exception>(E error, [StackTrace? stackTrace]) {
    if (ref.mounted) {
      state = AsyncError(error, stackTrace ?? StackTrace.current);
    }
    return Err(error, stackTrace ?? StackTrace.current);
  }

  Result<T> emitData(T data) {
    if (ref.mounted) {
      state = AsyncData(data);
    }
    return Ok(data);
  }

  void emitLoading() {
    if (ref.mounted) {
      state = const AsyncLoading();
    }
  }

  Result<T> emitResult(Result<T> result, [StackTrace? stackTrace]) {
    if (ref.mounted) {
      state = switch (result) {
        Ok<T>(value: final data) => AsyncData(data),
        Err<T>(value: final error) => AsyncError(
          error,
          stackTrace ?? StackTrace.current,
        ),
      };
    }
    return result;
  }
}
