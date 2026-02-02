// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_otp_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SendOtp)
final sendOtpProvider = SendOtpProvider._();

final class SendOtpProvider
    extends $NotifierProvider<SendOtp, AsyncValue<Unit>> {
  SendOtpProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendOtpProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendOtpHash();

  @$internal
  @override
  SendOtp create() => SendOtp();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$sendOtpHash() => r'f5c3a7e1ab199a0494826bdf42583d98754b886a';

abstract class _$SendOtp extends $Notifier<AsyncValue<Unit>> {
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
