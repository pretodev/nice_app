import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/mixins/command_provider_base_mixin.dart';
import '../provider_services.dart';

part 'sign_out_command.g.dart';

@riverpod
class SignOut extends _$SignOut with CommandMixin<Unit> {
  @override
  AsyncValue<Unit> build() => invalidState();

  Future<void> call() async {
    emitLoading();
    final authService = ref.read(authServiceProvider);
    final authRepository = ref.read(authRepositoryProvider);
    final result = await authService.signOut().flatMapAsync(
      (_) => authRepository.deleteCredentials(),
    );
    emitResult(result);
  }
}
