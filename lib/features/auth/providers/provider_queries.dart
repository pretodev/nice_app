import 'package:nice/features/auth/providers/commands/cancel_otp_command.dart';
import 'package:nice/features/auth/providers/commands/send_otp_command.dart';
import 'package:nice/features/auth/providers/commands/sign_out_command.dart';
import 'package:nice/features/auth/providers/commands/verify_otp_command.dart';
import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_state.dart';
import 'provider_services.dart';

part 'provider_queries.g.dart';

@Riverpod(
  dependencies: [
    SendOtp,
    CancelOtp,
    VerifyOtp,
    SignOut,
  ],
)
Stream<AuthState> authState(Ref ref) {
  ref.watch(sendOtpProvider);
  ref.watch(cancelOtpProvider);

  return ref.watch(authServiceProvider).state.asyncMap((state) async {
    if (state is Unauthenticated) {
      final result = await ref.read(authRepositoryProvider).getOtpCredentials();
      switch (result) {
        case Some(:final value):
          return WaitingForOtpVerification(value.email);
        case None():
          return const Unauthenticated();
      }
    }
    ref.read(authRepositoryProvider).deleteCredentials();
    return const Authenticated();
  });
}
