import 'package:nice/core/fp/fp.dart';

sealed class TrainingFailure extends Failure {
  const TrainingFailure(super.message);
}

class TrainingNotFoundFailure extends TrainingFailure {
  const TrainingNotFoundFailure() : super('Training not found');
}

class TrainingStorageFailure extends TrainingFailure {
  const TrainingStorageFailure([String? reason])
    : super(reason ?? 'Failed to save training');
}

class TrainingGenerationFailure extends TrainingFailure {
  const TrainingGenerationFailure([String? reason])
    : super(reason ?? 'Failed to generate training');
}
