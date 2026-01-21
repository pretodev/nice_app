// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_queries.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(trainingFromId)
final trainingFromIdProvider = TrainingFromIdFamily._();

final class TrainingFromIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyTraining>,
          DailyTraining,
          Stream<DailyTraining>
        >
    with $FutureModifier<DailyTraining>, $StreamProvider<DailyTraining> {
  TrainingFromIdProvider._({
    required TrainingFromIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'trainingFromIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$trainingFromIdHash();

  @override
  String toString() {
    return r'trainingFromIdProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<DailyTraining> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DailyTraining> create(Ref ref) {
    final argument = this.argument as String;
    return trainingFromId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TrainingFromIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$trainingFromIdHash() => r'8c51d2b26517a89bc67586aa3afbeebf91d8242a';

final class TrainingFromIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<DailyTraining>, String> {
  TrainingFromIdFamily._()
    : super(
        retry: null,
        name: r'trainingFromIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TrainingFromIdProvider call(String id) =>
      TrainingFromIdProvider._(argument: id, from: this);

  @override
  String toString() => r'trainingFromIdProvider';
}

@ProviderFor(dailyTraining)
final dailyTrainingProvider = DailyTrainingProvider._();

final class DailyTrainingProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyTraining>,
          DailyTraining,
          Stream<DailyTraining>
        >
    with $FutureModifier<DailyTraining>, $StreamProvider<DailyTraining> {
  DailyTrainingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dailyTrainingProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dailyTrainingHash();

  @$internal
  @override
  $StreamProviderElement<DailyTraining> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DailyTraining> create(Ref ref) {
    return dailyTraining(ref);
  }
}

String _$dailyTrainingHash() => r'4b4e9bbd5382122ae033dee3f70115d1018e4aac';
