// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_exercise.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteExercise)
const deleteExerciseProvider = DeleteExerciseProvider._();

final class DeleteExerciseProvider
    extends $NotifierProvider<DeleteExercise, AsyncValue<Exercise>> {
  const DeleteExerciseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deleteExerciseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deleteExerciseHash();

  @$internal
  @override
  DeleteExercise create() => DeleteExercise();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Exercise> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Exercise>>(value),
    );
  }
}

String _$deleteExerciseHash() => r'5f5912b83783b4eb804ca68204501f3b59f705f9';

abstract class _$DeleteExercise extends $Notifier<AsyncValue<Exercise>> {
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
