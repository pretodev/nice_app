// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'generate_training_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GenerateTraining)
final generateTrainingProvider = GenerateTrainingProvider._();

final class GenerateTrainingProvider
    extends $NotifierProvider<GenerateTraining, AsyncValue<Unit>> {
  GenerateTrainingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'generateTrainingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$generateTrainingHash();

  @$internal
  @override
  GenerateTraining create() => GenerateTraining();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$generateTrainingHash() => r'f98a3242ac959abc866a2d490845e0f6a92977a8';

abstract class _$GenerateTraining extends $Notifier<AsyncValue<Unit>> {
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
