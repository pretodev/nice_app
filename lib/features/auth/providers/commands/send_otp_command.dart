import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../shared/mixins/command_provider_base_mixin.dart';
import '../../data/email_address.dart';
import '../provider_services.dart';

part 'send_otp_command.g.dart';

@riverpod
class SendOtp extends _$SendOtp with CommandMixin<Unit> {
  @override
  AsyncValue<Unit> build() => invalidState();

  Future<void> call(EmailAddress email) async {
    emitLoading();
    final authService = ref.read(authServiceProvider);
    final authRepo = ref.read(authRepositoryProvider);
    final sendResult = await authService.sendOtp(email);

    late Result<Unit> result;

    switch (sendResult) {
      case Ok(:final value):
        result = result = await authRepo.store(
          OtpCredentials(
            email: email,
            otpId: value,
          ),
        );
      case Err():
        result = sendResult as Result<Unit>;
    }

    emitResult(result);
  }
}
