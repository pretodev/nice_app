// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_sign_in_link_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SendSignInLink)
final sendSignInLinkProvider = SendSignInLinkProvider._();

final class SendSignInLinkProvider
    extends $NotifierProvider<SendSignInLink, AsyncValue<Unit>> {
  SendSignInLinkProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendSignInLinkProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendSignInLinkHash();

  @$internal
  @override
  SendSignInLink create() => SendSignInLink();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$sendSignInLinkHash() => r'fa9084989bdb774dd475fbf5f68e405bc2d49c60';

abstract class _$SendSignInLink extends $Notifier<AsyncValue<Unit>> {
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
