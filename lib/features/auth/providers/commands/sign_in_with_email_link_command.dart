import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/mixins/command_provider_base_mixin.dart';
import '../../data/auth_failures.dart';
import '../provider_services.dart';

part 'sign_in_with_email_link_command.g.dart';

@riverpod
class SignInWithEmailLink extends _$SignInWithEmailLink
    with CommandMixin<Unit> {
  @override
  AsyncValue<Unit> build() => invalidState();

  Future<void> call(String link) async {
    emitLoading();

    final authService = ref.read(authServiceProvider);
    final authRepo = ref.read(authRepositoryProvider);

    final result = await authRepo
        .getEmailLinkCredentials()
        .okOr(const UnknownAuthFailure('No email credentials found'))
        .flatMapAsync((credentials) {
          return authService.signInWithEmailLink(
            email: credentials.email.value,
            link: link,
          );
        })
        .flatMapAsync((_) => authRepo.deleteCredentials());

    emitResult(result);
  }
}
