// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_training_from_id.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getTrainingFromId)
final getTrainingFromIdProvider = GetTrainingFromIdFamily._();

final class GetTrainingFromIdProvider
    extends
        $FunctionalProvider<
          AsyncValue<DailyTraining>,
          DailyTraining,
          Stream<DailyTraining>
        >
    with $FutureModifier<DailyTraining>, $StreamProvider<DailyTraining> {
  GetTrainingFromIdProvider._({
    required GetTrainingFromIdFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'getTrainingFromIdProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getTrainingFromIdHash();

  @override
  String toString() {
    return r'getTrainingFromIdProvider'
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
    return getTrainingFromId(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is GetTrainingFromIdProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getTrainingFromIdHash() => r'5383c23c92f9095eb8d555eee774c3ea08b637dc';

final class GetTrainingFromIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<DailyTraining>, String> {
  GetTrainingFromIdFamily._()
    : super(
        retry: null,
        name: r'getTrainingFromIdProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetTrainingFromIdProvider call(String id) =>
      GetTrainingFromIdProvider._(argument: id, from: this);

  @override
  String toString() => r'getTrainingFromIdProvider';
}
