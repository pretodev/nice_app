import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:nice/features/trainning/data/training.dart';
import 'package:nice/features/trainning/providers/commands/generate_training_command.dart';

class TrainingPromptModal extends ConsumerStatefulWidget {
  static Future<void> show(
    BuildContext context, {
    required DailyTraining training,
  }) async {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) => TrainingPromptModal(training: training),
    );
  }

  final DailyTraining training;

  const TrainingPromptModal({super.key, required this.training});

  @override
  ConsumerState<TrainingPromptModal> createState() =>
      _TrainingPromptModalState();
}

class _TrainingPromptModalState extends ConsumerState<TrainingPromptModal> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final image = await _imagePicker.pickImage(
        source: source,
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

  void _showImageSourceOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Symbols.photo_camera_rounded),
              title: const Text('Tirar foto'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Symbols.photo_library_rounded),
              title: const Text('Escolher da galeria'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
    });
  }

  void _onCreate() {
    final message = _controller.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Digite uma mensagem para o treino')),
      );
      return;
    }

    ref
        .read(generateTrainingProvider.notifier)
        .call(widget.training, userMessage: message, fileImage: _selectedImage);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 48.0,
          bottom: bottomPadding + 24.0,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              spacing: 8.0,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Me ajude com o treino de hoje',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'Descreva o treino que você deseja fazer hoje, incluindo grupos musculares, exercícios e seu nível de experiência.',
                  style: TextStyle(
                    fontSize: 12.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextField(
                    controller: _controller,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Treino de perna para iniciante',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton.icon(
                      icon: Icon(
                        _selectedImage == null
                            ? Symbols.upload_2_rounded
                            : Icons.close,
                      ),
                      onPressed: _selectedImage == null
                          ? _showImageSourceOptions
                          : _clearImage,
                      label: Text(
                        _selectedImage == null
                            ? 'Adicionar uma imagem'
                            : 'Remover imagem',
                      ),
                    ),
                    FilledButton(
                      onPressed: _onCreate,
                      child: const Text('Criar'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
