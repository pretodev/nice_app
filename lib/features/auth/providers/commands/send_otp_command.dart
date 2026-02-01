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

    // 1. Enviar OTP (obtém otpId)
    final sendResult = await authService.sendOtp(email);

    // 2. Se sucesso, armazenar otpId e email
    late Result<Unit> result;

    switch (sendResult) {
      case Ok(:final value):
        // value é o otpId
        final storeOtpResult = await authRepo.storeOtpId(value);

        if (storeOtpResult case Err()) {
          result = storeOtpResult;
        } else {
          // Armazenar email também
          result = await authRepo.store(OtpCredentials(email));
        }

      case Err():
        // Casting para Result<Unit> (error é AuthFailure, não precisa mudar)
        result = sendResult as Result<Unit>;
    }

    emitResult(result);
  }
}
