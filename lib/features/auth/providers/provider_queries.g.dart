// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_queries.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authState)
final authStateProvider = AuthStateProvider._();

final class AuthStateProvider
    extends
        $FunctionalProvider<AsyncValue<AuthState>, AuthState, Stream<AuthState>>
    with $FutureModifier<AuthState>, $StreamProvider<AuthState> {
  AuthStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          sendOtpProvider,
          cancelOtpProvider,
          verifyOtpProvider,
          signOutProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          AuthStateProvider.$allTransitiveDependencies0,
          AuthStateProvider.$allTransitiveDependencies1,
          AuthStateProvider.$allTransitiveDependencies2,
          AuthStateProvider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = sendOtpProvider;
  static final $allTransitiveDependencies1 = cancelOtpProvider;
  static final $allTransitiveDependencies2 = verifyOtpProvider;
  static final $allTransitiveDependencies3 = signOutProvider;

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

String _$authStateHash() => r'825090889f699cd335746449008c06cbd1bdf7c2';
