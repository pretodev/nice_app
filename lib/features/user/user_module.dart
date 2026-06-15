import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/core/injector/module.dart';
import 'package:nice/features/app/app_module.dart';
import 'package:nice/features/user/data/user_repository.dart';
import 'package:nice/features/user/state/user_view_model.dart';

class UserModule extends Module {
  @override
  List<Module> get imports => [appModule];

  @override
  void registry(Registrar r) {
    r.lazySingleton<UserRepository>(
      (i) => UserRepository(i.get<FirebaseAuth>(), i.get<FirebaseFirestore>()),
    );
    r.export.lazySingleton<UserViewModel>(
      (i) => UserViewModel(i.get<UserRepository>()),
    );
  }
}

final userModule = UserModule();
