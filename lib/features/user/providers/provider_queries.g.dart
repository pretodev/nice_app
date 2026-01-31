// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_queries.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(currentUser)
final currentUserProvider = CurrentUserProvider._();

final class CurrentUserProvider
    extends
        $FunctionalProvider<
          AsyncValue<UserEntity>,
          UserEntity,
          FutureOr<UserEntity>
        >
    with $FutureModifier<UserEntity>, $FutureProvider<UserEntity> {
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  $FutureProviderElement<UserEntity> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserEntity> create(Ref ref) {
    return currentUser(ref);
  }
}

String _$currentUserHash() => r'4e5304f155e38cb7df73aee7f942926a33ed2085';
