import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nice/core/injector/module.dart';

class AppModule extends Module {
  @override
  void registry(Registrar r) {
    r.export.lazySingleton<FirebaseAuth>((i) => FirebaseAuth.instance);
    r.export.lazySingleton<FirebaseFirestore>((i) => FirebaseFirestore.instance);
  }
}

final appModule = AppModule();
