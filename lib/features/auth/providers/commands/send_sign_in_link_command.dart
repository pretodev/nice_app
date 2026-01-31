import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/mixins/command_provider_base_mixin.dart';
import '../../data/email_address.dart';
import '../provider_services.dart';

part 'send_sign_in_link_command.g.dart';

@riverpod
class SendSignInLink extends _$SendSignInLink with CommandMixin<Unit> {
  @override
  AsyncValue<Unit> build() => invalidState();

  Future<void> call(EmailAddress email) async {
    emitLoading();
    final authService = ref.read(authServiceProvider);
    final authRepo = ref.read(authRepositoryProvider);
    final result = await authService
        .sendSignInLink(email)
        .flatMapAsync((_) => authRepo.store(EmailLinkCredentials(email)));
    emitResult(result);
  }
}
