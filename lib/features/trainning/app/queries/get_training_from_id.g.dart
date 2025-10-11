// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_training_from_id.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getTrainingFromId)
const getTrainingFromIdProvider = GetTrainingFromIdFamily._();

final class GetTrainingFromIdProvider
    extends
        $FunctionalProvider<AsyncValue<Training>, Training, Stream<Training>>
    with $FutureModifier<Training>, $StreamProvider<Training> {
  const GetTrainingFromIdProvider._({
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
  $StreamProviderElement<Training> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Training> create(Ref ref) {
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

String _$getTrainingFromIdHash() => r'a21989ae613da1748b030fd5ec0ab59c407c86f3';

final class GetTrainingFromIdFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Training>, String> {
  const GetTrainingFromIdFamily._()
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
