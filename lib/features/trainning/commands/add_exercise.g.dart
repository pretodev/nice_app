// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_exercise.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddExercise)
const addExerciseProvider = AddExerciseProvider._();

final class AddExerciseProvider
    extends $NotifierProvider<AddExercise, AsyncValue<Unit>> {
  const AddExerciseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addExerciseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addExerciseHash();

  @$internal
  @override
  AddExercise create() => AddExercise();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$addExerciseHash() => r'72a6be50090544e7492eefa2d4944ef4015b66fd';

abstract class _$AddExercise extends $Notifier<AsyncValue<Unit>> {
  AsyncValue<Unit> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Unit>, AsyncValue<Unit>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Unit>, AsyncValue<Unit>>,
              AsyncValue<Unit>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
