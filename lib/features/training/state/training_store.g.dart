// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TrainingStore)
final trainingStoreProvider = TrainingStoreProvider._();

final class TrainingStoreProvider
    extends $NotifierProvider<TrainingStore, TrainingState> {
  TrainingStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'trainingStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$trainingStoreHash();

  @$internal
  @override
  TrainingStore create() => TrainingStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TrainingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TrainingState>(value),
    );
  }
}

String _$trainingStoreHash() => r'82e8b64f6b510322ab398257c435a067ae3bd909';

abstract class _$TrainingStore extends $Notifier<TrainingState> {
  TrainingState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TrainingState, TrainingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TrainingState, TrainingState>,
              TrainingState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
