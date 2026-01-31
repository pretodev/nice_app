// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_profile_data_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SetProfileDataCommand)
final setProfileDataCommandProvider = SetProfileDataCommandProvider._();

final class SetProfileDataCommandProvider
    extends $NotifierProvider<SetProfileDataCommand, AsyncValue<Unit>> {
  SetProfileDataCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setProfileDataCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setProfileDataCommandHash();

  @$internal
  @override
  SetProfileDataCommand create() => SetProfileDataCommand();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$setProfileDataCommandHash() =>
    r'dcb32127e84086537b8e1e9bfd805be81f9144b0';

abstract class _$SetProfileDataCommand extends $Notifier<AsyncValue<Unit>> {
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
