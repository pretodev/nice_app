// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'delete_exercise_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(DeleteExercise)
final deleteExerciseProvider = DeleteExerciseProvider._();

final class DeleteExerciseProvider
    extends $NotifierProvider<DeleteExercise, AsyncValue<Unit>> {
  DeleteExerciseProvider._()
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
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$deleteExerciseHash() => r'4b1f336e12ac3dff4a4efd7dc366db3dcdf93700';

abstract class _$DeleteExercise extends $Notifier<AsyncValue<Unit>> {
  AsyncValue<Unit> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Unit>, AsyncValue<Unit>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Unit>, AsyncValue<Unit>>,
              AsyncValue<Unit>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
