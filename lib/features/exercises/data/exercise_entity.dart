import 'package:odu_core/odu_core.dart';

class ExerciseEntity extends GuidEntity {
  ExerciseEntity({
    required super.id,
    required super.createdAt,
    required super.updatedAt,
    required this.name,
    this.imageUrl,
    required this.muscles,
  });

  final String name;
  final String? imageUrl;
  final List<String> muscles;
}
