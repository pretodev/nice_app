import 'package:flutter/material.dart';
import 'package:nice/core/injector/scope.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/state/auth_view_model.dart';
import 'package:nice/features/auth/ui/login_view.dart';
import 'package:nice/features/auth/ui/otp_verification_view.dart';
import 'package:nice/features/user/data/user_status.dart';
import 'package:nice/features/user/state/user_view_model.dart';
import 'package:nice/features/user/ui/placeholder_view.dart';

class Application extends StatefulWidget {
  const Application({super.key});

  @override
  State<Application> createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<UserViewModel>().loadUser();
    });
  }

  void _handleRedirection() {
    final authState = context.read<AuthViewModel>().state;
    final userState = context.read<UserViewModel>().state;

    final Route<dynamic> route;
    if (userState.status == UserStatus.authenticated) {
      route = PlaceholderView.route();
    } else {
      switch (authState.credentials) {
        case EmailLinkCredentials(:final email):
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
    context.listen<AuthViewModel>((_) => _handleRedirection());
    context.listen<UserViewModel>((_) => _handleRedirection());

    return MaterialApp(
      title: 'Nice',
      navigatorKey: _navigatorKey,
      home: const Placeholder(), //TODO: changes to splash screen
    );
  }
}
