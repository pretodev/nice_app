// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merge_exercises.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MergeExercises)
final mergeExercisesProvider = MergeExercisesProvider._();

final class MergeExercisesProvider
    extends $NotifierProvider<MergeExercises, AsyncValue<Unit>> {
  MergeExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mergeExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mergeExercisesHash();

  @$internal
  @override
  MergeExercises create() => MergeExercises();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$mergeExercisesHash() => r'd9ac6411fe9aa0a3e08612993f13cccbb9b0f911';

abstract class _$MergeExercises extends $Notifier<AsyncValue<Unit>> {
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
