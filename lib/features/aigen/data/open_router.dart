import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:odu_core/odu_core.dart';

import 'open_router_message.dart';

class OpenRouter {
  final String _apiKey;
  final Dio _dio;
  static const _baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  OpenRouter(
    String apiKey, {
    Dio? dio,
  }) : _apiKey = apiKey,
       _dio = dio ?? Dio();

  /// Realiza uma requisição única para o OpenRouter.
  FutureResult<String> request({
    required String model,
    List<OpenRouterMessage>? messages,
    double? temperature,
    Map<String, dynamic>? responseFormat,
  }) async {
    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
            // Headers opcionais recomendados pelo OpenRouter
            'HTTP-Referer': 'https://nice.app', // Placeholder
            'X-Title': 'Nice App', // Placeholder
          },
        ),
        data: {
          'model': model,
          if (messages != null)
            'messages': messages.map((m) => m.toJson()).toList(),
          if (temperature != null) 'temperature': temperature,
          if (responseFormat != null) 'response_format': responseFormat,
        },
      );

      final data = response.data;
      if (data['choices'] != null && (data['choices'] as List).isNotEmpty) {
        final content = data['choices'][0]['message']['content'] as String?;
        return Ok(content ?? '');
      }

      return Err(Exception('No choices in response'));
    } catch (e, s) {
      return Err(e is Exception ? e : Exception('$e'), s);
    }
  }

  /// Realiza uma requisição em streaming para o OpenRouter.
  Stream<String> stream({
    required String model,
    List<OpenRouterMessage>? messages,
    double? temperature,
    Map<String, dynamic>? responseFormat,
  }) async* {
    try {
      final response = await _dio.post(
        _baseUrl,
        options: Options(
          responseType: ResponseType.stream,
          headers: {
            'Authorization': 'Bearer $_apiKey',
            'Content-Type': 'application/json',
            'HTTP-Referer': 'https://nice.app',
            'X-Title': 'Nice App',
          },
        ),
        data: {
          'model': model,
          if (messages != null)
            'messages': messages.map((m) => m.toJson()).toList(),
          if (temperature != null) 'temperature': temperature,
          if (responseFormat != null) 'response_format': responseFormat,
          'stream': true,
        },
      );

      final stream = response.data.stream as Stream<List<int>>;
      final lineStream = stream
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());

      await for (final line in lineStream) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();
          if (data == '[DONE]') break;

          try {
            final json = jsonDecode(data);
            if (json['choices'] != null &&
                (json['choices'] as List).isNotEmpty) {
              final delta = json['choices'][0]['delta'];
              if (delta['content'] != null) {
                yield delta['content'] as String;
              }
            }
          } catch (_) {
            // Ignorar erros de parse em chunks individuais
          }
        }
      }
    } catch (e) {
      // Em caso de erro no stream, podemos relançar ou yieldar uma mensagem de erro
      // Aqui opto por relançar para que o consumidor trate
      throw e is Exception ? e : Exception('$e');
    }
  }
}
