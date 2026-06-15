import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nice/core/injector/module_injector.dart';
import 'package:nice/core/injector/scope.dart';
import 'package:nice/features/app/ui/application.dart';
import 'package:nice/features/auth/auth_module.dart';
import 'package:nice/features/training/training_module.dart';
import 'package:nice/features/user/user_module.dart';
import 'package:nice/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final injector = createInjector([
    userModule,
    authModule,
    trainingModule,
  ]);

  runApp(
    AppScope(
      injector: injector,
      child: const Application(),
    ),
  );
}
