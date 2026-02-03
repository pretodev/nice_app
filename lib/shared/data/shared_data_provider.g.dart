// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shared_data_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(pocketbaseClient)
final pocketbaseClientProvider = PocketbaseClientProvider._();

final class PocketbaseClientProvider
    extends $FunctionalProvider<PocketBase, PocketBase, PocketBase>
    with $Provider<PocketBase> {
  PocketbaseClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pocketbaseClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pocketbaseClientHash();

  @$internal
  @override
  $ProviderElement<PocketBase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PocketBase create(Ref ref) {
    return pocketbaseClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PocketBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PocketBase>(value),
    );
  }
}

String _$pocketbaseClientHash() => r'b278869539faf91a86219f9736e5d15b5a0041da';
