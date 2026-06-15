import 'package:flutter_test/flutter_test.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/core/injector/module.dart';
import 'package:nice/core/injector/module_injector.dart';
import 'package:nice/core/state/view_model.dart';

// --- Serviços de apoio ---------------------------------------------------

class Engine {
  Engine(this.serial);

  final int serial;
}

/// Binding privado do [CoreModule] — não deve vazar para outros módulos.
class GearBox {}

class Car {
  Car(this.engine);

  final Engine engine;
}

// --- Módulos de apoio ----------------------------------------------------

/// Exporta [Engine]; mantém [GearBox] privado.
class CoreModule extends Module {
  @override
  void registry(Registrar r) {
    r.export.lazySingleton<Engine>((i) => Engine(1));
    r.lazySingleton<GearBox>((i) => GearBox());
  }
}

/// Importa um módulo e expõe um [Car] que depende de [Engine] exportado.
class CarModule extends Module {
  CarModule(this._dependency);

  final Module _dependency;

  @override
  List<Module> get imports => [_dependency];

  @override
  void registry(Registrar r) {
    r.export.lazySingleton<Car>((i) => Car(i.get<Engine>()));
  }
}

/// Importa o core e tenta alcançar um binding PRIVADO dele.
class IntrusiveModule extends Module {
  IntrusiveModule(this._core);

  final Module _core;

  @override
  List<Module> get imports => [_core];

  @override
  void registry(Registrar r) {
    // Resolve um tipo privado do core na hora de construir o Car.
    r.export.lazySingleton<Car>((i) {
      i.get<GearBox>();
      return Car(Engine(0));
    });
  }
}

/// Exporta um [GearBox] — usado para verificar isolamento entre irmãos.
class SiblingProducer extends Module {
  @override
  void registry(Registrar r) {
    r.export.lazySingleton<GearBox>((i) => GearBox());
  }
}

/// Irmão de [SiblingProducer] que NÃO o importa; tenta (e deve falhar)
/// resolver o [GearBox] exportado por ele.
class SiblingConsumer extends Module {
  @override
  void registry(Registrar r) {
    r.export.factory<Car>((i) {
      i.get<GearBox>();
      return Car(Engine(0));
    });
  }
}

/// Herança: o filho vê os exports do pai sem declarar imports.
class ChildModule extends Module {
  ChildModule(this._parent);

  final Module _parent;

  @override
  Module? get parent => _parent;

  @override
  void registry(Registrar r) {
    r.export.lazySingleton<Car>((i) => Car(i.get<Engine>()));
  }
}

// --- ViewModel/Command de apoio -----------------------------------------

class CounterState {
  const CounterState(this.count);

  final int count;
}

class CounterViewModel extends ViewModel<CounterState> {
  CounterViewModel() : super(const CounterState(0));

  late final increment = _increment.bind();

  FutureResult<Unit> _increment() async {
    emit(CounterState(state.count + 1));
    return ok;
  }
}

class CounterModule extends Module {
  @override
  void registry(Registrar r) {
    r.export.lazySingleton<CounterViewModel>((i) => CounterViewModel());
  }
}

void main() {
  group('visibilidade entre módulos', () {
    test('um import enxerga apenas os tipos exportados do módulo importado', () {
      final core = CoreModule();
      final injector = createInjector([CarModule(core)]);

      final car = injector.get<Car>();
      expect(car.engine.serial, 1);
    });

    test('binding privado não é alcançável por quem importa', () {
      final core = CoreModule();
      final injector = createInjector([IntrusiveModule(core)]);

      expect(
        () => injector.get<Car>(),
        throwsA(isA<DependencyNotFoundException>()),
      );
    });

    test('binding privado não é alcançável pela raiz', () {
      final injector = createInjector([CoreModule()]);

      expect(
        () => injector.get<GearBox>(),
        throwsA(isA<DependencyNotFoundException>()),
      );
    });

    test('um irmão não enxerga exports do outro sem declarar import', () {
      // SiblingConsumer NÃO importa SiblingProducer, então não alcança o
      // GearBox exportado por ele, mesmo compostos lado a lado.
      final injector = createInjector([SiblingProducer(), SiblingConsumer()]);

      expect(
        () => injector.get<Car>(),
        throwsA(isA<DependencyNotFoundException>()),
      );
    });
  });

  group('herança de parent', () {
    test('o filho resolve exports herdados do pai', () {
      final parent = CoreModule();
      final injector = createInjector([ChildModule(parent)]);

      expect(injector.get<Car>().engine.serial, 1);
    });
  });

  group('ciclo de vida das instâncias', () {
    test('lazySingleton compartilha a mesma instância entre importadores', () {
      final core = CoreModule();
      final injector = createInjector([CarModule(core)]);

      final a = injector.get<Engine>();
      final b = injector.get<Engine>();
      expect(identical(a, b), isTrue);
    });

    test('factory cria uma nova instância a cada resolução', () {
      final injector = createInjector([_FactoryModule()]);

      final a = injector.get<Engine>();
      final b = injector.get<Engine>();
      expect(identical(a, b), isFalse);
    });

    test('singleton eager é instanciado ao compor (antes de qualquer get)', () {
      var created = 0;
      createInjector([_EagerModule(() => created++)]);

      expect(created, 1);
    });
  });

  group('erros e overrides', () {
    test('tipo não registrado lança DependencyNotFoundException', () {
      final injector = createInjector([CoreModule()]);

      expect(
        () => injector.get<Car>(),
        throwsA(isA<DependencyNotFoundException>()),
      );
    });

    test('override substitui binding inclusive em dependência interna', () {
      final core = CoreModule();
      final injector = createInjector(
        [CarModule(core)],
        overrides: {Engine: Engine(99)},
      );

      expect(injector.get<Car>().engine.serial, 99);
    });

    test('export duplicado do mesmo tipo é rejeitado na composição', () {
      expect(
        () => createInjector([CoreModule(), CoreModule()]),
        throwsA(isA<StateError>()),
      );
    });
  });

  group('compatibilidade com ViewModel e Command', () {
    test('resolve um ViewModel e executa seu Command', () async {
      final injector = createInjector([CounterModule()]);

      final vm = injector.get<CounterViewModel>();
      expect(vm.increment.isIdle, isTrue);

      await vm.increment();

      expect(vm.increment.isDone, isTrue);
      expect(vm.state.count, 1);
    });
  });
}

class _FactoryModule extends Module {
  @override
  void registry(Registrar r) {
    var serial = 0;
    r.export.factory<Engine>((i) => Engine(serial++));
  }
}

class _EagerModule extends Module {
  _EagerModule(this._onCreate);

  final void Function() _onCreate;

  @override
  void registry(Registrar r) {
    r.export.singleton<Engine>((i) {
      _onCreate();
      return Engine(1);
    });
  }
}
