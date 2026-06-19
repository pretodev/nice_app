import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nice/core/data/entity.dart';
import 'package:uuid/uuid.dart';

/// Identificador de entidade baseado em UUID (RFC 4122).
extension type const GuidId._(String value) implements String {
  factory GuidId([String value = '']) {
    if (value.isEmpty) {
      return GuidId._(const Uuid().v4());
    }
    if (!Uuid.isValidUUID(fromString: value)) {
      throw ArgumentError.value(
        value,
        'value',
        'GuidId deve ser um UUID válido',
      );
    }
    return GuidId._(value);
  }
}

/// Base imutável para entidades de domínio identificadas por [GuidId].
///
/// Em DDD, uma entidade é definida pela sua identidade, não pelos seus
/// atributos: duas entidades com o mesmo [id] e mesmo tipo são iguais,
/// independentemente do estado atual.
@immutable
abstract class const GuidEntity({
  @override required final GuidId id,
}) extends Equatable implements Entity<GuidId> {
  @override
  List<Object?> get props => [id];
}
