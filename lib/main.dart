import 'package:auto_injector/auto_injector.dart';
import 'package:flutter/material.dart';
import 'package:nice/features/auth/auth_module.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/pocketbase/persistent_auth_store.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/features/auth/ui/login_view.dart';
import 'package:nice/features/auth/ui/otp_verification_view.dart';
import 'package:nice/features/training/training_module.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:nice/features/user/state/commands/load_user_command.dart';
import 'package:nice/features/user/state/user_state.dart';
import 'package:nice/features/user/ui/placeholder_view.dart';
import 'package:nice/features/user/user_module.dart';
import 'package:nice/shared/environment.dart';
import 'package:nice/shared/state/scope.dart';
import 'package:pocketbase/pocketbase.dart' hide AuthStore;

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
          i.addInjector(trainingModule);
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

  void _handleRedirection() {
    final authState = context.read<AuthStore>().state;
    final userState = context.read<UserStore>().state;

    final Route<dynamic> route;
    if (userState.status == UserStatus.authenticated) {
      route = PlaceholderView.route();
    } else {
      switch (authState.credentials) {
        case OtpCredentials(:final email):
          route = OtpVerificationView.route(email: email);
          break;
        default:
          route = LoginView.route();
      }
    }

    _navigatorKey.currentState?.pushReplacement(route);
  }

  @override
  Widget build(BuildContext context) {
    context.listen<AuthStore>((_) => _handleRedirection());
    context.listen<UserStore>((_) => _handleRedirection());

    return MaterialApp(
      title: 'Nice',
      navigatorKey: _navigatorKey,
      home: const Placeholder(), //TODO: changes to splash screen
    );
  }
}
