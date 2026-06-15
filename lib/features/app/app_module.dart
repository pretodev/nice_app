import 'package:auto_injector/auto_injector.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final appModule = AutoInjector(
  tag: 'AppModule',
  on: (i) {
    i.addLazySingleton(() => FirebaseAuth.instance);
    i.addLazySingleton(() => FirebaseFirestore.instance);
  },
);
