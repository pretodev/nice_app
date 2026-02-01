// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_services.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider para a instância singleton do PocketBase

@ProviderFor(pocketbaseClient)
final pocketbaseClientProvider = PocketbaseClientProvider._();

/// Provider para a instância singleton do PocketBase

final class PocketbaseClientProvider
    extends $FunctionalProvider<PocketBase, PocketBase, PocketBase>
    with $Provider<PocketBase> {
  /// Provider para a instância singleton do PocketBase
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

@ProviderFor(authService)
final authServiceProvider = AuthServiceProvider._();

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'cf8aa5c2b66e09e1270d98ad8e21350f8811c425';

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'19a3485653561ac2f781b997131430c5659286d1';
