import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nice/features/aigen/data/open_router_message.dart';
import 'package:nice/features/aigen/providers/provider_services.dart';
import 'package:odu_core/odu_core.dart';

class AigenWidget extends ConsumerStatefulWidget {
  const AigenWidget({super.key});

  @override
  ConsumerState<AigenWidget> createState() => _AigenWidgetState();
}

class _AigenWidgetState extends ConsumerState<AigenWidget> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();

  String _content = '';
  bool _loading = false;
  File? _selectedImage;

  Future<void> _pickImage() async {
    try {
      final image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao selecionar imagem: $e')),
        );
      }
    }
  }

  Future<String> _imageToBase64(File image) async {
    final bytes = await image.readAsBytes();
    final base64String = base64Encode(bytes);
    return 'data:image/jpeg;base64,$base64String';
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  Future<void> _sendMessage() async {
    final message = _controller.text;
    if (message.isNotEmpty) {
      setState(() => _loading = true);

      final OpenRouterMessage userMessage;
      if (_selectedImage != null) {
        final base64Image = await _imageToBase64(_selectedImage!);
        userMessage = OpenRouterMessage.userWithImage(
          text: message,
          base64Image: base64Image,
        );
      } else {
        userMessage = OpenRouterMessage.user(message);
      }

      final result = await ref
          .read(openRouterProvider)
          .request(
            model: 'openai/gpt-5-image-mini',
            messages: [userMessage],
          );

      switch (result) {
        case Ok(value: final content):
          debugPrint('OpenRouter Response: $content');
          if (mounted) {
            setState(() {
              _content = content;
              _loading = false;
              _selectedImage = null;
            });
          }
        case Err(value: final error):
          debugPrint('OpenRouter Error: $error');
          if (mounted) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: $error')));
            setState(() => _loading = false);
          }
      }

      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aigen')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          spacing: 16.0,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Aigen Widget'),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Digite sua mensagem...',
                border: OutlineInputBorder(),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _loading ? null : _pickImage,
              icon: const Icon(Icons.image),
              label: const Text('Escolher Imagem da Galeria'),
            ),
            if (_selectedImage != null)
              Stack(
                alignment: Alignment.topRight,
                children: [
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _clearImage,
                    icon: const Icon(Icons.close),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ElevatedButton(
              onPressed: _loading ? null : _sendMessage,
              child: _loading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Enviar'),
            ),
            if (_content.isNotEmpty)
              Expanded(
                child: SingleChildScrollView(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(_content),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
