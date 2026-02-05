import 'package:auto_injector/auto_injector.dart';
import 'package:flutter/material.dart';

final commandConfig = BindConfig<Command>(
  onDispose: (command) => command.dispose(),
  notifier: (command) => command,
);

abstract class Command extends ChangeNotifier {
  CommandState _state = const CommandNone();

  CommandState get state => _state;

  @protected
  void done() {
    _state = const CommandDone();
    notifyListeners();
  }

  bool get isDone => _state is CommandDone;

  @protected
  void loading() {
    _state = const CommandLoading();
    notifyListeners();
  }

  bool get isLoading => _state is CommandLoading;

  @protected
  void setError(Exception error) {
    _state = CommandError(error);
    notifyListeners();
  }

  bool get hasError => _state is CommandError;

  Exception? get error =>
      _state is CommandError ? (_state as CommandError).error : null;
}

sealed class CommandState {
  const CommandState();
}

final class CommandNone extends CommandState {
  const CommandNone();
}

final class CommandLoading extends CommandState {
  const CommandLoading();
}

final class CommandError extends CommandState {
  const CommandError(this.error);

  final Exception error;
}

final class CommandDone extends CommandState {
  const CommandDone();
}
