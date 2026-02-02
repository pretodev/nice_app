// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'load_user_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(LoadUserCommand)
final loadUserCommandProvider = LoadUserCommandProvider._();

final class LoadUserCommandProvider
    extends $NotifierProvider<LoadUserCommand, AsyncValue<Unit>> {
  LoadUserCommandProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'loadUserCommandProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$loadUserCommandHash();

  @$internal
  @override
  LoadUserCommand create() => LoadUserCommand();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<Unit> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<Unit>>(value),
    );
  }
}

String _$loadUserCommandHash() => r'f9966ce793910b3bd550b73a702e209deb02cd08';

abstract class _$LoadUserCommand extends $Notifier<AsyncValue<Unit>> {
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
