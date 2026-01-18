import 'package:nice/features/aigen/data/models/ai_usage.dart';
import 'package:odu_core/odu_core.dart';

import '../llm_service.dart';
import '../models/ai_list_response.dart';
import '../models/ai_message_response.dart';
import '../models/llm_options.dart';

class DeepseekLlmService implements LlmService {
  @override
  FutureResult<AiMessageResponse> generate(
    String prompt, {
    LlmOptions? options,
  }) async {
    try {
      // Simulate network latency
      await Future<void>.delayed(const Duration(seconds: 1));

      final content = 'Deepseek response to: $prompt. (Simulated)';

      return Ok(
        AiMessageResponse(
          content: content,
          usage: AiUsage(
            promptTokens: prompt.length,
            completionTokens: content.length,
            totalTokens: prompt.length + content.length,
          ),
        ),
      );
    } catch (e, s) {
      return Err(e is Exception ? e : Exception('$e'), s);
    }
  }

  @override
  FutureResult<AiListResponse> generateList(
    String prompt, {
    LlmOptions? options,
  }) async {
    try {
      // Simulate network latency
      await Future<void>.delayed(const Duration(seconds: 1));

      final items = [
        'Deepseek Item 1 for: $prompt',
        'Deepseek Item 2',
        'Deepseek Item 3',
      ];

      return Ok(
        AiListResponse(
          items: items,
          usage: AiUsage(
            promptTokens: prompt.length,
            completionTokens: items.join().length,
            totalTokens: prompt.length + items.join().length,
          ),
        ),
      );
    } catch (e, s) {
      return Err(e is Exception ? e : Exception('$e'), s);
    }
  }
}
