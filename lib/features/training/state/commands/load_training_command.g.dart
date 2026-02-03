// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_training_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoadTraining)
final loadTrainingProvider = LoadTrainingProvider._();

final class LoadTrainingProvider
    extends $NotifierProvider<LoadTraining, AsyncValue<Unit>> {
  LoadTrainingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadTrainingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadTrainingHash();

  @$internal
  @override
  LoadTraining create() => LoadTraining();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$loadTrainingHash() => r'18da65bbf4c1d8aa98143c308b0b696444cdd3ce';

abstract class _$LoadTraining extends $Notifier<AsyncValue<Unit>> {
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
