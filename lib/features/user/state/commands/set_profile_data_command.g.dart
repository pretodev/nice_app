// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'set_profile_data_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SetProfileData)
final setProfileDataProvider = SetProfileDataProvider._();

final class SetProfileDataProvider
    extends $NotifierProvider<SetProfileData, AsyncValue<Unit>> {
  SetProfileDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setProfileDataProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setProfileDataHash();

  @$internal
  @override
  SetProfileData create() => SetProfileData();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$setProfileDataHash() => r'7888d617f59b9daec16d78311b9e7c27927ae7ad';

abstract class _$SetProfileData extends $Notifier<AsyncValue<Unit>> {
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
