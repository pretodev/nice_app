/// Resolvedor de dependências escopado a um módulo.
///
/// É entregue às closures de fábrica em [Registry] e também é o tipo exposto
/// pela raiz da composição (consumido por `AppScope`/`context.read`).
abstract interface class Injector {
  /// Resolve uma instância de [T] respeitando as regras de visibilidade do
  /// escopo (bindings próprios, exports de imports e exports da cadeia de pais).
  ///
  /// Lança [DependencyNotFoundException] se [T] não estiver acessível.
  T get<T extends Object>();
}

/// Assinatura das fábricas de binding. Recebe o [Injector] do módulo dono do
/// binding, permitindo resolver dependências sem acoplar ao container.
typedef Create<T extends Object> = T Function(Injector i);

/// Registrador de bindings entregue a [Module.registry].
///
/// Por padrão os bindings são **privados** (visíveis apenas dentro do próprio
/// módulo). Use [export] para também expô-los a módulos que importam ou herdam
/// deste.
abstract interface class Registry {
  /// Registra uma fábrica: uma nova instância é criada a cada resolução.
  void factory<T extends Object>(Create<T> create);

  /// Registra um singleton instanciado imediatamente ao compor o injector.
  void singleton<T extends Object>(Create<T> create);

  /// Registra um singleton instanciado de forma preguiçosa (na primeira
  /// resolução) e reutilizado depois.
  void lazySingleton<T extends Object>(Create<T> create);

  /// Mesma API de registro, porém marcando os bindings como **exportados**.
  ///
  /// ```dart
  /// r.lazySingleton((i) => AuthService(i.get())); // privado
  /// r.export.lazySingleton((i) => AuthViewModel(i.get(), i.get())); // exportado
  /// ```
  Registry get export;
}

/// Configuração de um escopo de injeção de dependências.
///
/// Um [Module] é apenas configuração: não guarda estado de runtime — o
/// container concreto é criado por `createInjector`, permitindo recompor o
/// mesmo módulo várias vezes (essencial para testes).
///
/// Regras de visibilidade:
/// - bindings são privados por padrão; só [Registry.export] os expõe;
/// - [imports] dá acesso aos exports dos módulos listados (não transitivo);
/// - [parent] dá acesso aos exports do pai e de toda a cadeia de pais
///   (transitivo).
abstract class Module {
  const Module();

  /// Módulos cujos exports este módulo pode resolver. Não transitivo.
  List<Module> get imports => const [];

  /// Módulo pai do qual este herda os exports. Transitivo pela cadeia de pais.
  Module? get parent => null;

  /// Declara os bindings do módulo.
  void registry(Registry r);
}

/// Lançada quando um tipo não está registrado ou não está acessível no escopo
/// a partir do qual foi solicitado.
class DependencyNotFoundException implements Exception {
  const DependencyNotFoundException(this.type, [this.scope]);

  final Type type;
  final String? scope;

  @override
  String toString() {
    final where = scope == null ? '' : ' a partir do escopo "$scope"';
    return 'DependencyNotFoundException: $type não foi registrado ou não está '
        'acessível$where. Verifique se o tipo foi exportado pelo módulo que o '
        'provê e importado por quem o consome.';
  }
}
