import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nice/features/auth/data/email_address.dart';

import 'features/auth/ui/auth_gate.dart';
import 'features/auth/ui/views/auth_callback_view.dart';
import 'features/auth/ui/views/awaiting_confirmation_view.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
    cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
  );
  runApp(const ProviderScope(child: MainApp()));
}

final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AuthGate(),
    ),
    GoRoute(
      path: '/awaiting-confirmation',
      builder: (context, state) {
        final email = state.extra as String?;
        return AwaitingConfirmationView(
          email: EmailAddress(email ?? ''),
        );
      },
    ),
    GoRoute(
      path: '/auth/callback',
      builder: (context, state) {
        final link = state.uri.queryParameters['link'] ?? state.uri.toString();
        return AuthCallbackView(link: link);
      },
    ),
  ],
);

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Nice',
      routerConfig: _router,
    );
  }
}
