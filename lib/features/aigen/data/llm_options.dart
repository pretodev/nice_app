import 'package:flutter/foundation.dart';

@immutable
class LlmOptions {
  const LlmOptions({
    this.model,
    this.temperature,
    this.maxTokens,
    this.topP,
    this.additionalOptions,
  });

  final String? model;
  final double? temperature;
  final int? maxTokens;
  final double? topP;
  final Map<String, dynamic>? additionalOptions;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is LlmOptions &&
        other.model == model &&
        other.temperature == temperature &&
        other.maxTokens == maxTokens &&
        other.topP == topP &&
        mapEquals(other.additionalOptions, additionalOptions);
  }

  @override
  int get hashCode {
    return model.hashCode ^
        temperature.hashCode ^
        maxTokens.hashCode ^
        topP.hashCode ^
        additionalOptions.hashCode;
  }

  @override
  String toString() {
    return 'LlmOptions(model: $model, temperature: $temperature, maxTokens: $maxTokens, topP: $topP, additionalOptions: $additionalOptions)';
  }
}
