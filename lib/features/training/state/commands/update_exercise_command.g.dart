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
    extends $NotifierProvider<UpdateExercise, AsyncValue<Unit>> {
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
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$updateExerciseHash() => r'2df6b49c65be3ce5410f64f7890824079a010810';

abstract class _$UpdateExercise extends $Notifier<AsyncValue<Unit>> {
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
