import 'package:auto_injector/auto_injector.dart';
import 'package:nice/features/app/app_module.dart';
import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/state/auth_view_model.dart';

final authModule = AutoInjector(
  tag: 'AuthModule',
  on: (i) {
    i.addInjector(appModule);
    i.addLazySingleton(AuthRepository.new);
    i.addLazySingleton(AuthService.new);
    i.addLazySingleton(AuthViewModel.new);
  },
);
