// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_exercise.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UpdateExercise)
const updateExerciseProvider = UpdateExerciseProvider._();

final class UpdateExerciseProvider
    extends $NotifierProvider<UpdateExercise, AsyncValue<Exercise>> {
  const UpdateExerciseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'updateExerciseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$updateExerciseHash();

  @$internal
  @override
  UpdateExercise create() => UpdateExercise();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Exercise> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Exercise>>(value),
    );
  }
}

String _$updateExerciseHash() => r'64b2e5c61b8f38efac30237a6d9cf2179688916b';

abstract class _$UpdateExercise extends $Notifier<AsyncValue<Exercise>> {
  AsyncValue<Exercise> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Exercise>, AsyncValue<Exercise>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Exercise>, AsyncValue<Exercise>>,
              AsyncValue<Exercise>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
