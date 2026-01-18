// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_exercise_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddExercise)
final addExerciseProvider = AddExerciseProvider._();

final class AddExerciseProvider
    extends $NotifierProvider<AddExercise, AsyncValue<Exercise>> {
  AddExerciseProvider._()
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
  Override overrideWithValue(AsyncValue<Exercise> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Exercise>>(value),
    );
  }
}

String _$addExerciseHash() => r'f4ff64f03581d0fdd2c8884b1c01f74599dac643';

abstract class _$AddExercise extends $Notifier<AsyncValue<Exercise>> {
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
