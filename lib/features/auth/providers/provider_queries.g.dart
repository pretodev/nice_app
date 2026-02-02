// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_queries.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides the current authentication state.
///
/// This Stream provider listens to PocketBase auth changes and checks
/// SharedPreferences for OTP credentials to determine the correct state.
///
/// Commands (SendOtp, CancelOtp, etc.) explicitly call `ref.invalidate(authStateProvider)`
/// after modifying local state, which forces this provider to rebuild and re-emit.

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

/// Provides the current authentication state.
///
/// This Stream provider listens to PocketBase auth changes and checks
/// SharedPreferences for OTP credentials to determine the correct state.
///
/// Commands (SendOtp, CancelOtp, etc.) explicitly call `ref.invalidate(authStateProvider)`
/// after modifying local state, which forces this provider to rebuild and re-emit.

final class AuthStateProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  /// Provides the current authentication state.
  ///
  /// This Stream provider listens to PocketBase auth changes and checks
  /// SharedPreferences for OTP credentials to determine the correct state.
  ///
  /// Commands (SendOtp, CancelOtp, etc.) explicitly call `ref.invalidate(authStateProvider)`
  /// after modifying local state, which forces this provider to rebuild and re-emit.
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateHash();

  @$internal
  @override
  $StreamProviderElement<AuthState> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<AuthState> create(Ref ref) {
    return authState(ref);
  }
}

String _$authStateHash() => r'695f9e21aefabdc7adb6762fd7919d99948b1ca0';
