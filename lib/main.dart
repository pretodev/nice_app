import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/pocketbase/persistent_auth_store.dart';
import 'package:nice/features/auth/login_view.dart';
import 'package:nice/features/auth/otp_verification_view.dart';
import 'package:nice/features/auth/state/auth_store.dart';
import 'package:nice/features/auth/state/commands/load_credentials_command.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:nice/features/user/placeholder_view.dart';
import 'package:nice/features/user/state/commands/load_user_command.dart';
import 'package:nice/features/user/state/user_store.dart';
import 'package:nice/shared/data/shared_data_provider.dart';
import 'package:nice/shared/environment.dart';
import 'package:pocketbase/pocketbase.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize persistent auth store
  final authStore = PersistentAuthStore();
  await authStore.load();

  // Initialize PocketBase with the auth store
  final pb = PocketBase(Environment.pocketbaseUrl, authStore: authStore);

  runApp(
    ProviderScope(
      overrides: [
        pocketbaseClientProvider.overrideWithValue(pb),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends ConsumerStatefulWidget {
  const MainApp({super.key});

  @override
  ConsumerState<MainApp> createState() => _MainAppState();
}

class _MainAppState extends ConsumerState<MainApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(loadUserCommandProvider.notifier).call();
      ref.read(loadCredentialsCommandProvider.notifier).call();
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
