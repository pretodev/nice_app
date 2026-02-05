import 'package:auto_injector/auto_injector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/auth/auth_module.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/pocketbase/persistent_auth_store.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/features/auth/state/commands/load_credentials_command.dart';
import 'package:nice/features/auth/ui/login_view.dart';
import 'package:nice/features/auth/ui/otp_verification_view.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:nice/features/user/state/commands/load_user_command.dart';
import 'package:nice/features/user/state/user_store.dart';
import 'package:nice/features/user/ui/placeholder_view.dart';
import 'package:nice/features/user/user_module.dart';
import 'package:nice/shared/data/shared_data_provider.dart';
import 'package:nice/shared/environment.dart';
import 'package:nice/shared/state/scope.dart';
import 'package:pocketbase/pocketbase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent auth store
  final authStore = PersistentAuthStore();
  await authStore.load();

  // Initialize PocketBase with the auth store
  final pb = PocketBase(Environment.pocketbaseUrl, authStore: authStore);

  runApp(
    AppScope(
      injector: AutoInjector(
        on: (i) {
          i.addLazySingleton(() => pb);
          i.addInjector(userModule);
          i.addInjector(authModule);
        },
      ),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<LoadUser>().call();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authRedirectProvider, (previous, next) {
      _navigatorKey.currentState?.pushReplacement(next);
    });
    return MaterialApp(
      title: 'Nice',
      navigatorKey: _navigatorKey,
      home: const Placeholder(), //TODO: changes to splash screen
    );
  }
}

final authRedirectProvider = Provider((ref) {
  final authState = ref.watch(authStoreProvider);
  final userState = ref.watch(userStoreProvider);

  if (userState.status == UserStatus.authenticated) {
    return PlaceholderView.route();
  }

  switch (authState.credentials) {
    case OtpCredentials(:final email):
      return OtpVerificationView.route(email: email);
    default:
      return LoginView.route();
  }
});
