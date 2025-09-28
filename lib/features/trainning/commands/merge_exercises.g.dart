// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'merge_exercises.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(MergeExercises)
const mergeExercisesProvider = MergeExercisesProvider._();

final class MergeExercisesProvider
    extends $NotifierProvider<MergeExercises, AsyncValue<Unit>> {
  const MergeExercisesProvider._()
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

String _$mergeExercisesHash() => r'9f44739ecd3a03fb5ce28312ce34f0e3f71e19e5';

abstract class _$MergeExercises extends $Notifier<AsyncValue<Unit>> {
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
