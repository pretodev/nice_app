// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cancel_otp_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(CancelOtp)
final cancelOtpProvider = CancelOtpProvider._();

final class CancelOtpProvider
    extends $NotifierProvider<CancelOtp, AsyncValue<Unit>> {
  CancelOtpProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cancelOtpProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cancelOtpHash();

  @$internal
  @override
  CancelOtp create() => CancelOtp();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$cancelOtpHash() => r'e6a097abfaaa4c0302842c54df3f87a4b35336a1';

abstract class _$CancelOtp extends $Notifier<AsyncValue<Unit>> {
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
