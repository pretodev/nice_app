import 'package:flutter/material.dart';
import 'package:nice/features/aigen/data/open_router.dart';
import 'package:nice/features/aigen/data/open_router_message.dart';
import 'package:odu_core/odu_core.dart';

class AigenWidget extends StatefulWidget {
  const AigenWidget({super.key});

  @override
  State<AigenWidget> createState() => _AigenWidgetState();
}

class _AigenWidgetState extends State<AigenWidget> {
  final TextEditingController _controller = TextEditingController();

  String _content = '';

  Future<void> _sendMessage() async {
    final message = _controller.text;
    if (message.isNotEmpty) {
      // TODO: Replace with your actual OpenRouter API key
      final openRouter = OpenRouter(
        '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',
      );

      final result = await openRouter.request(
        model: 'deepseek/deepseek-v3.2', // Example model from requirements
        messages: [
          OpenRouterMessage.user(message),
        ],
        responseFormat: {
          'type': 'json_schema',
          'json_schema': {
            'name': 'minha_resposta_estruturada',
            'strict': true,
            'schema': {
              'type': 'object',
              'properties': {
                'titulo': {'type': 'string'},
                'itens': {
                  'type': 'array',
                  'items': {'type': 'string'},
                },
              },
              'required': ['titulo', 'itens'],
              'additionalProperties': false,
            },
          },
        },
      );

      switch (result) {
        case Ok(value: final content):
          debugPrint('OpenRouter Response: $content');
          if (mounted) {
            setState(() => _content = content);
          }
        case Err(value: final error):
          debugPrint('OpenRouter Error: $error');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
          }
      }

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aigen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),

        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Aigen Widget'),
            TextField(
              controller: _controller,
            ),
            ElevatedButton(
              onPressed: _sendMessage,
              child: const Text('Send'),
            ),

            Text(_content),
          ],
        ),
      ),
    );
  }
}
