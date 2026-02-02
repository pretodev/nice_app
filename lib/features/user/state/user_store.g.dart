// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_store.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserStore)
final userStoreProvider = UserStoreProvider._();

final class UserStoreProvider extends $NotifierProvider<UserStore, UserState> {
  UserStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userStoreHash();

  @$internal
  @override
  UserStore create() => UserStore();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UserState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UserState>(value),
    );
  }
}

String _$userStoreHash() => r'dd3215c34dd2d572e6f0c96aeebe59088afe5232';

abstract class _$UserStore extends $Notifier<UserState> {
  UserState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<UserState, UserState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<UserState, UserState>,
              UserState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
