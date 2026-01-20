import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class TrainingPromptModal extends StatelessWidget {
  static Future<String?> show(
    BuildContext context,
  ) async {
    return showModalBottomSheet<String>(
      context: context,
      builder: (context) => const TrainingPromptModal(),
    );
  }

  const TrainingPromptModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 48.0,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: SafeArea(
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
                padding: const .symmetric(vertical: 8.0),
                child: TextField(
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
                    icon: const Icon(Symbols.upload_2_rounded),
                    onPressed: () => Navigator.pop(context),
                    label: const Text('Adicionar uma imagem'),
                  ),

                  FilledButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Criar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
