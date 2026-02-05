// ================================================
// File: lib/shared/state/store.dart
// ================================================
import 'package:auto_injector/auto_injector.dart';
import 'package:flutter/material.dart';

BindConfig<Store<T>> storeConfig<T>() => BindConfig<Store<T>>(
  onDispose: (store) => store.dispose(),
  notifier: (store) => store,
);

abstract class Store<T> extends ValueNotifier<T> {
  Store(super.value);

  T get state => value;

  void setState(T newValue, {String? key}) {
    value = newValue;
  }
}
