import 'package:flutter/material.dart';
import 'package:nice/core/injector/scope.dart';
import 'package:nice/features/training/ui/training_editor_view.dart';
import 'package:nice/features/user/state/user_view_model.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nice',
      navigatorKey: _navigatorKey,
      home: const TrainingEditorView(), //TODO: changes to splash screen
    );
  }
}
