import 'package:auto_injector/auto_injector.dart';
import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/features/auth/state/commands/cancel_otp_command.dart';
import 'package:nice/features/auth/state/commands/load_credentials_command.dart';
import 'package:nice/features/auth/state/commands/send_otp_command.dart';
import 'package:nice/features/auth/state/commands/verify_otp_command.dart';
import 'package:nice/shared/state/command.dart';

final authModule = AutoInjector(
  tag: 'UserModule',
  on: (i) {
    // services
    i.addLazySingleton(AuthRepository.new);
    i.addLazySingleton(AuthService.new);

    // State
    i.addLazySingleton(AuthStore.new);

    // Commands
    i.addLazySingleton(SendOtp.new, config: commandConfig);
    i.addLazySingleton(VerifyOtp.new, config: commandConfig);
    i.addLazySingleton(CancelOtp.new, config: commandConfig);
    i.addLazySingleton(LoadCredentials.new, config: commandConfig);
  },
);
