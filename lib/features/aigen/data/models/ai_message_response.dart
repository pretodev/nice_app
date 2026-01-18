import 'package:flutter/foundation.dart';

import 'ai_usage.dart';

@immutable
class AiMessageResponse {
  const AiMessageResponse({
    required this.content,
    this.usage,
  });

  final String content;
  final AiUsage? usage;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AiMessageResponse &&
        other.content == content &&
        other.usage == usage;
  }

  @override
  int get hashCode => content.hashCode ^ usage.hashCode;

  @override
  String toString() => 'AiMessageResponse(content: $content, usage: $usage)';
}
