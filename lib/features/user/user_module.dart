import 'package:auto_injector/auto_injector.dart';
import 'package:nice/features/user/data/user_repository.dart';
import 'package:nice/features/user/state/commands/load_user_command.dart';
import 'package:nice/features/user/state/commands/set_profile_data_command.dart';
import 'package:nice/features/user/state/commands/sign_out_command.dart';
import 'package:nice/features/user/state/user_state.dart';
import 'package:nice/shared/state/command.dart';

final userModule = AutoInjector(
  tag: 'UserModule',
  on: (i) {
    // services
    i.addLazySingleton(UserRepository.new);

    // Commands
    i.addLazySingleton(LoadUser.new, config: commandConfig);
    i.addLazySingleton(SetProfileData.new, config: commandConfig);
    i.addLazySingleton(SignOut.new, config: commandConfig);

    // State
    i.addLazySingleton(UserStore.new);
  },
);
