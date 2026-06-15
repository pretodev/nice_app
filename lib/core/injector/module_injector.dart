import 'package:get_it/get_it.dart';
import 'package:nice/core/injector/module.dart';

/// Compõe uma árvore de [modules] num [Injector] raiz pronto para uso.
///
/// Cada módulo (e, recursivamente, seus [Module.imports] e [Module.parent]) é
/// inicializado uma única vez por identidade — então um módulo compartilhado,
/// como o `appModule`, importado por várias features, vira um único container e
/// seus singletons são compartilhados.
///
/// [overrides] substitui bindings por instâncias específicas (por tipo),
/// com prioridade sobre qualquer registro. Útil para injetar dublês em testes.
Injector createInjector(
  List<Module> modules, {
  Map<Type, Object> overrides = const {},
}) {
  final contexts = <Module, _ModuleContext>{};
  final order = <_ModuleContext>[];

  void init(Module module) {
    if (contexts.containsKey(module)) return;
    final context = _ModuleContext(module);
    contexts[module] = context;
    order.add(context);

    for (final imported in module.imports) {
      init(imported);
    }
    final parent = module.parent;
    if (parent != null) {
      init(parent);
    }

    module.registry(_RegistrarImpl(context, false));
  }

  for (final module in modules) {
    init(module);
  }

  final root = RootInjector._(contexts, order, Map.unmodifiable(overrides));
  for (final context in order) {
    context.injector = _ModuleInjector(root, context);
  }

  root._checkDuplicateExports();
  root._startEagerSingletons();
  return root;
}

/// Estado de runtime de um único [Module] dentro de uma composição.
class _ModuleContext {
  _ModuleContext(this.module);

  final Module module;
  final GetIt getIt = GetIt.asNewInstance();
  final Set<Type> exportedTypes = <Type>{};
  final List<void Function()> eagerStarters = <void Function()>[];

  late final _ModuleInjector injector;
}

/// Implementação do [Registrar]. Privados e exports vão ambos para o [GetIt] do
/// módulo; o flag [exporting] apenas decide se o tipo entra em
/// [_ModuleContext.exportedTypes].
class _RegistrarImpl implements Registrar {
  _RegistrarImpl(this._context, this._exporting);

  final _ModuleContext _context;
  final bool _exporting;

  @override
  Registrar get export =>
      _exporting ? this : _RegistrarImpl(_context, true);

  void _mark<T extends Object>() {
    if (_exporting) _context.exportedTypes.add(T);
  }

  @override
  void factory<T extends Object>(Create<T> create) {
    _context.getIt.registerFactory<T>(() => create(_context.injector));
    _mark<T>();
  }

  @override
  void lazySingleton<T extends Object>(Create<T> create) {
    _context.getIt.registerLazySingleton<T>(() => create(_context.injector));
    _mark<T>();
  }

  @override
  void singleton<T extends Object>(Create<T> create) {
    _context.getIt.registerLazySingleton<T>(() => create(_context.injector));
    _mark<T>();
    _context.eagerStarters.add(() => _context.getIt.get<T>());
  }
}

/// [Injector] escopado a um módulo: resolve com visibilidade completa do próprio
/// módulo (privados + exports), mais os exports de imports e da cadeia de pais.
class _ModuleInjector implements Injector {
  _ModuleInjector(this._root, this._context);

  final RootInjector _root;
  final _ModuleContext _context;

  @override
  T get<T extends Object>() => _root._resolveOwn<T>(_context);
}

/// Raiz da composição. Resolve qualquer tipo **exportado** por algum módulo
/// inicializado; tipos privados nunca são alcançáveis por aqui (isolamento).
class RootInjector implements Injector {
  RootInjector._(this._contexts, this._order, this._overrides);

  final Map<Module, _ModuleContext> _contexts;
  final List<_ModuleContext> _order;
  final Map<Type, Object> _overrides;

  @override
  T get<T extends Object>() {
    final override = _overrides[T];
    if (override != null) return override as T;

    for (final context in _order) {
      if (context.exportedTypes.contains(T)) {
        return context.getIt.get<T>();
      }
    }
    throw DependencyNotFoundException(T, 'root');
  }

  /// Resolução com visibilidade total a partir de [context] (usada por
  /// `_ModuleInjector.get` e, portanto, por dentro das closures do módulo).
  T _resolveOwn<T extends Object>(_ModuleContext context) {
    final override = _overrides[T];
    if (override != null) return override as T;

    if (context.getIt.isRegistered<T>()) {
      return context.getIt.get<T>();
    }

    for (final imported in context.module.imports) {
      final exported = _resolveExported<T>(_contexts[imported]!);
      if (exported != null) return exported;
    }

    final parent = context.module.parent;
    if (parent != null) {
      final inherited = _resolveExported<T>(_contexts[parent]!);
      if (inherited != null) return inherited;
    }

    throw DependencyNotFoundException(T, context.module.runtimeType.toString());
  }

  /// Resolução de [context] visto de fora: só tipos exportados, subindo pela
  /// cadeia de pais (transitiva). Retorna `null` quando não encontrado para que
  /// o chamador tente a próxima alternativa.
  T? _resolveExported<T extends Object>(_ModuleContext context) {
    if (context.exportedTypes.contains(T)) {
      return context.getIt.get<T>();
    }
    final parent = context.module.parent;
    if (parent != null) {
      return _resolveExported<T>(_contexts[parent]!);
    }
    return null;
  }

  void _checkDuplicateExports() {
    final owners = <Type, Module>{};
    for (final context in _order) {
      for (final type in context.exportedTypes) {
        final previous = owners[type];
        if (previous != null) {
          throw StateError(
            'Export duplicado: $type é exportado por '
            '${previous.runtimeType} e ${context.module.runtimeType}. '
            'Cada tipo exportado deve ter um único módulo provedor.',
          );
        }
        owners[type] = context.module;
      }
    }
  }

  void _startEagerSingletons() {
    for (final context in _order) {
      for (final start in context.eagerStarters) {
        start();
      }
    }
  }

  /// Libera todos os containers. Use em `tearDown` de testes.
  void dispose() {
    for (final context in _order) {
      context.getIt.reset();
    }
  }
}
