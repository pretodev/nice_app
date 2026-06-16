import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/core/injector/module.dart';
import 'package:nice/features/app/app_module.dart';
import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/state/auth_view_model.dart';

class AuthModule extends Module {
  @override
  List<Module> get imports => [appModule];

  @override
  void registry(Registry r) {
    r.lazySingleton<AuthRepository>((i) => AuthRepository());
    r.lazySingleton<AuthService>((i) => AuthService(i.get<FirebaseAuth>()));
    r.export.lazySingleton<AuthViewModel>(
      (i) => AuthViewModel(i.get<AuthService>(), i.get<AuthRepository>()),
    );
  }
}

final authModule = AuthModule();
