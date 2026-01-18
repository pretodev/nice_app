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
      );

      switch (result) {
        case Ok(value: final content):
          debugPrint('OpenRouter Response: $content');
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Response: $content')),
            );
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
      body: Column(
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
        ],
      ),
    );
  }
}
