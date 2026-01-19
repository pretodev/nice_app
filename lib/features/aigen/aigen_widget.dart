import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nice/features/aigen/data/open_router_message.dart';
import 'package:nice/features/aigen/providers/providers.dart';
import 'package:odu_core/odu_core.dart';

class AigenWidget extends ConsumerStatefulWidget {
  const AigenWidget({super.key});

  @override
  ConsumerState<AigenWidget> createState() => _AigenWidgetState();
}

class _AigenWidgetState extends ConsumerState<AigenWidget> {
  final TextEditingController _controller = TextEditingController();

  String _content = '';

  bool _loading = false;

  Future<void> _sendMessage() async {
    final message = _controller.text;
    if (message.isNotEmpty) {
      setState(() => _loading = true);
      final result = await ref
          .read(openRouterProvider)
          .request(
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
            setState(() {
              _content = content;
              _loading = false;
            });
          }
        case Err(value: final error):
          debugPrint('OpenRouter Error: $error');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: $error')),
            );
            setState(() => _loading = false);
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
              onPressed: _loading ? null : _sendMessage,
              child: const Text('Send'),
            ),

            Text(_content),
          ],
        ),
      ),
    );
  }
}
