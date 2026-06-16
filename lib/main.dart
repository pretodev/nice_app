import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nice/core/injector/module_injector.dart';
import 'package:nice/core/injector/scope.dart';
import 'package:nice/features/app/ui/application.dart';
import 'package:nice/features/training/training_module.dart';
import 'package:nice/features/user/user_module.dart';
import 'package:nice/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  EquatableConfig.stringify = true;

  final injector = createInjector([
    UserModule(),
    TrainingModule(),
  ]);

  runApp(
    AppScope(
      injector: injector,
      child: const Application(),
    ),
  );
}
