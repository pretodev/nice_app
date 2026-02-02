import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

AsyncValue<T> invalidState<T>() =>
    AsyncError<T>(StateError('Not called yet'), StackTrace.current);

mixin CommandMixin on $Notifier<AsyncValue<Unit>> {
  void emitError<E extends Exception>(E error, [StackTrace? stackTrace]) {
    if (ref.mounted) {
      state = AsyncError(error, stackTrace ?? StackTrace.current);
    }
  }

  void emitOk({
    List<ProviderOrFamily> invalidateProviders = const [],
  }) {
    if (ref.mounted) {
      for (final provider in invalidateProviders) {
        ref.invalidate(provider, asReload: true);
      }
      state = const AsyncData(unit);
    }
  }

  void emitLoading() {
    if (ref.mounted) {
      state = const AsyncLoading();
    }
  }

  void emitResult<T>(
    Result<T> result, {
    List<ProviderOrFamily> invalidateProviders = const [],
    StackTrace? stackTrace,
  }) {
    switch (result) {
      case Ok():
        emitOk(invalidateProviders: invalidateProviders);
        break;
      case Err(value: final error):
        emitError(error, stackTrace);
        break;
    }
  }
}
