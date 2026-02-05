// ================================================
// File: lib/shared/state/scope.dart
// ================================================
import 'package:auto_injector/auto_injector.dart';
import 'package:flutter/material.dart';

class AppScope extends StatefulWidget {
  const AppScope({
    super.key,
    required this.injector,
    required this.child,
  });

  final AutoInjector injector;
  final Widget child;

  static AppScopeState of(BuildContext context) {
    final state = context.findAncestorStateOfType<AppScopeState>();
    assert(state != null, 'AppScope not found in context');
    return state!;
  }

  @override
  State<StatefulWidget> createState() => AppScopeState();
}

class AppScopeState extends State<AppScope> {
  AutoInjector get injector => widget.injector;

  final _watchSubscriptions = <Element, Set<_WatchSubscription>>{};
  final _listenSubscriptions = <Element, Set<_ListenSubscription>>{};

  T get<T>() => injector.get<T>();

  T watch<T extends Listenable>(Element element) {
    final listenable = injector.get<T>();

    final subs = _watchSubscriptions.putIfAbsent(element, () => {});
    final alreadyWatching = subs.any((s) => s.listenable == listenable);

    if (!alreadyWatching) {
      void listener() {
        if (element.mounted) {
          element.markNeedsBuild();
        }
      }

      listenable.addListener(listener);
      subs.add(_WatchSubscription(listenable, listener));

      _scheduleCleanupCheck(element);
    }

    return listenable;
  }

  void listen<T extends Listenable>(
    Element element,
    void Function(T state) callback, {
    bool fireImmediately = false,
  }) {
    final listenable = injector.get<T>();

    final subs = _listenSubscriptions.putIfAbsent(element, () => {});

    final existing = subs.where((s) => s.listenable == listenable).firstOrNull;
    if (existing != null) {
      existing.updateCallback((state) => callback(state as T));
      return;
    }

    final subscription = _ListenSubscription(
      listenable: listenable,
      callback: (state) => callback(state as T),
    );

    listenable.addListener(subscription.notify);
    subs.add(subscription);

    if (fireImmediately) {
      callback(listenable);
    }

    _scheduleCleanupCheck(element);
  }

  void _scheduleCleanupCheck(Element element) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!element.mounted) {
        _cleanupElement(element);
      }
    });
  }

  void _cleanupElement(Element element) {
    final watchSubs = _watchSubscriptions.remove(element);
    if (watchSubs != null) {
      for (final sub in watchSubs) {
        sub.listenable.removeListener(sub.listener);
      }
    }

    final listenSubs = _listenSubscriptions.remove(element);
    if (listenSubs != null) {
      for (final sub in listenSubs) {
        sub.dispose();
      }
    }
  }

  @override
  void dispose() {
    for (final subs in _watchSubscriptions.values) {
      for (final sub in subs) {
        sub.listenable.removeListener(sub.listener);
      }
    }
    _watchSubscriptions.clear();

    for (final subs in _listenSubscriptions.values) {
      for (final sub in subs) {
        sub.dispose();
      }
    }
    _listenSubscriptions.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedInjector(
      state: this,
      child: widget.child,
    );
  }
}

class _WatchSubscription {
  final Listenable listenable;
  final VoidCallback listener;

  _WatchSubscription(this.listenable, this.listener);
}

class _ListenSubscription {
  final Listenable listenable;
  void Function(Listenable state) _callback;

  _ListenSubscription({
    required this.listenable,
    required void Function(Listenable state) callback,
  }) : _callback = callback;

  void updateCallback(void Function(Listenable state) callback) {
    _callback = callback;
  }

  void notify() {
    _callback(listenable);
  }

  void dispose() {
    listenable.removeListener(notify);
  }
}

class _InheritedInjector extends InheritedWidget {
  final AppScopeState state;

  const _InheritedInjector({
    required this.state,
    required super.child,
  });

  @override
  bool updateShouldNotify(_InheritedInjector oldWidget) {
    return state.injector != oldWidget.state.injector;
  }
}

// ============================================
// Extensions no BuildContext
// ============================================

extension InjectorContextExtension on BuildContext {
  /// Obtém uma instância sem observar mudanças
  T read<T>() {
    final inherited = getInheritedWidgetOfExactType<_InheritedInjector>();
    assert(inherited != null, 'AppScope not found in context');
    return inherited!.state.get<T>();
  }

  /// Obtém uma instância e observa mudanças (causa rebuild)
  T watch<T extends Listenable>() {
    final inherited = getInheritedWidgetOfExactType<_InheritedInjector>();
    assert(inherited != null, 'AppScope not found in context');
    final element = this as Element;
    return inherited!.state.watch<T>(element);
  }

  /// Escuta mudanças para side effects (não causa rebuild)
  void listen<T extends Listenable>(
    void Function(T state) callback, {
    bool fireImmediately = false,
  }) {
    final inherited = getInheritedWidgetOfExactType<_InheritedInjector>();
    assert(inherited != null, 'AppScope not found in context');
    final element = this as Element;
    inherited!.state.listen<T>(
      element,
      callback,
      fireImmediately: fireImmediately,
    );
  }
}
