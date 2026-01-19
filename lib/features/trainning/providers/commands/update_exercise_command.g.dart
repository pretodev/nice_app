// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_exercise_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UpdateExercise)
final updateExerciseProvider = UpdateExerciseProvider._();

final class UpdateExerciseProvider
    extends $NotifierProvider<UpdateExercise, AsyncValue<Exercise>> {
  UpdateExerciseProvider._()
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

String _$updateExerciseHash() => r'45fe3b08295d425ffd5e562e504e7ae826ea1e23';

abstract class _$UpdateExercise extends $Notifier<AsyncValue<Exercise>> {
  AsyncValue<Exercise> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Exercise>, AsyncValue<Exercise>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Exercise>, AsyncValue<Exercise>>,
              AsyncValue<Exercise>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
