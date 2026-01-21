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
    extends $NotifierProvider<GenerateTraining, AsyncValue<DailyTraining>> {
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
  Override overrideWithValue(AsyncValue<DailyTraining> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<DailyTraining>>(value),
    );
  }
}

String _$generateTrainingHash() => r'2e57929d17c7ef3e8ebcb9e9252e7efb711668c5';

abstract class _$GenerateTraining extends $Notifier<AsyncValue<DailyTraining>> {
  AsyncValue<DailyTraining> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<DailyTraining>, AsyncValue<DailyTraining>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DailyTraining>, AsyncValue<DailyTraining>>,
              AsyncValue<DailyTraining>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
