import 'package:nice/core/injector/module.dart';
import 'package:nice/features/app/app_module.dart';
import 'package:nice/features/user/data/auth_service.dart';
import 'package:nice/features/user/state/user_view_model.dart';

class UserModule extends Module {
  @override
  List<Module> get imports => [appModule];

  @override
  void registry(Registry r) {
    r.lazySingleton<AuthService>(
      (i) => AuthService(auth: i.get()),
    );
    r.export.lazySingleton<UserViewModel>(
      (i) => UserViewModel(userRepository: i.get()),
    );
  }
}
