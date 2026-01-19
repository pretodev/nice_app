// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_services.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(openRouter)
final openRouterProvider = OpenRouterProvider._();

final class OpenRouterProvider
    extends $FunctionalProvider<OpenRouter, OpenRouter, OpenRouter>
    with $Provider<OpenRouter> {
  OpenRouterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openRouterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openRouterHash();

  @$internal
  @override
  $ProviderElement<OpenRouter> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  OpenRouter create(Ref ref) {
    return openRouter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OpenRouter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OpenRouter>(value),
    );
  }
}

String _$openRouterHash() => r'4e8ed71d6c97faf1b56362855b8daa037543726b';
