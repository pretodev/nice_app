import 'package:odu_core/odu_core.dart';

import 'models/ai_list_response.dart';
import 'models/ai_message_response.dart';
import 'models/llm_options.dart';

abstract interface class LlmService {
  FutureResult<AiMessageResponse> generate(
    String prompt, {
    LlmOptions? options,
  });

  FutureResult<AiListResponse> generateList(
    String prompt, {
    LlmOptions? options,
  });
}
