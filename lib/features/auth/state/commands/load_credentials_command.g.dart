// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_credentials_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoadCredentialsCommand)
final loadCredentialsCommandProvider = LoadCredentialsCommandProvider._();

final class LoadCredentialsCommandProvider
    extends $NotifierProvider<LoadCredentialsCommand, AsyncValue<Unit>> {
  LoadCredentialsCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadCredentialsCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadCredentialsCommandHash();

  @$internal
  @override
  LoadCredentialsCommand create() => LoadCredentialsCommand();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$loadCredentialsCommandHash() =>
    r'51b9febfeb8bae59ea5d4ccd64ebfdaa6bab0422';

abstract class _$LoadCredentialsCommand extends $Notifier<AsyncValue<Unit>> {
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
