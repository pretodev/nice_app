// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_exercises_command.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(GetExercises)
final getExercisesProvider = GetExercisesProvider._();

final class GetExercisesProvider
    extends $NotifierProvider<GetExercises, AsyncValue<List<Exercise>>> {
  GetExercisesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getExercisesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getExercisesHash();

  @$internal
  @override
  GetExercises create() => GetExercises();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AsyncValue<List<Exercise>> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AsyncValue<List<Exercise>>>(value),
    );
  }
}

String _$getExercisesHash() => r'8e2c5bc292a39c1e2bd33b51ad97897a02ca4dfc';

abstract class _$GetExercises extends $Notifier<AsyncValue<List<Exercise>>> {
  AsyncValue<List<Exercise>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<Exercise>>, AsyncValue<List<Exercise>>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<Exercise>>,
                AsyncValue<List<Exercise>>
              >,
              AsyncValue<List<Exercise>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
