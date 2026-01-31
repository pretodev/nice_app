// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_with_email_link_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SignInWithEmailLink)
final signInWithEmailLinkProvider = SignInWithEmailLinkProvider._();

final class SignInWithEmailLinkProvider
    extends $NotifierProvider<SignInWithEmailLink, AsyncValue<Unit>> {
  SignInWithEmailLinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInWithEmailLinkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInWithEmailLinkHash();

  @$internal
  @override
  SignInWithEmailLink create() => SignInWithEmailLink();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$signInWithEmailLinkHash() =>
    r'040ca6334b0998166df2fc78d78bc7474432099e';

abstract class _$SignInWithEmailLink extends $Notifier<AsyncValue<Unit>> {
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
