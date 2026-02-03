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
    extends $NotifierProvider<AddExercise, AsyncValue<Unit>> {
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
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$addExerciseHash() => r'add166a6137a8ce2a094d2f880418320ad10f761';

abstract class _$AddExercise extends $Notifier<AsyncValue<Unit>> {
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
