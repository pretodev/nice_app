import 'package:odu_core/odu_core.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/auth_state.dart';
import 'provider_services.dart';

part 'provider_queries.g.dart';

/// Provides the current authentication state.
///
/// This Stream provider listens to PocketBase auth changes and checks
/// SharedPreferences for OTP credentials to determine the correct state.
///
/// Commands (SendOtp, CancelOtp, etc.) explicitly call `ref.invalidate(authStateProvider)`
/// after modifying local state, which forces this provider to rebuild and re-emit.
@riverpod
Stream<AuthState> authState(Ref ref) {
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
