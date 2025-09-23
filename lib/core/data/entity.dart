import 'dart:convert';

import 'package:uuid/uuid.dart';

abstract class Entity {
  final String id;

  Entity({String? id}) : id = id ?? const Uuid().v4();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Entity && other.id == id;
  }

  Map<String, dynamic> get asMap => {'id': id};

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => '$runtimeType ${jsonEncode(asMap)}';
}
