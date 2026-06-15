import 'package:auto_injector/auto_injector.dart';
import 'package:nice/features/app/app_module.dart';
import 'package:nice/features/user/data/user_repository.dart';
import 'package:nice/features/user/state/user_view_model.dart';

final userModule = AutoInjector(
  tag: 'UserModule',
  on: (i) {
    i.addInjector(appModule);
    i.addLazySingleton(UserRepository.new);
    i.addLazySingleton(UserViewModel.new);
  },
);
