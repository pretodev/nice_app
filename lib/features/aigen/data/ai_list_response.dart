import 'package:flutter/foundation.dart';

import 'ai_usage.dart';

@immutable
class AiListResponse {
  const AiListResponse({
    required this.items,
    this.usage,
  });

  final List<String> items;
  final AiUsage? usage;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AiListResponse &&
        listEquals(other.items, items) &&
        other.usage == usage;
  }

  @override
  int get hashCode => Object.hashAll(items) ^ usage.hashCode;

  @override
  String toString() => 'AiListResponse(items: $items, usage: $usage)';
}
