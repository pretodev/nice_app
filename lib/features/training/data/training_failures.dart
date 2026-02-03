sealed class TrainingFailure implements Exception {
  const TrainingFailure();

  String get message;
}

class TrainingNotFoundFailure extends TrainingFailure {
  const TrainingNotFoundFailure();

  @override
  String get message => 'Training not found';
}

class TrainingStorageFailure extends TrainingFailure {
  const TrainingStorageFailure([this.reason]);

  final String? reason;

  @override
  String get message => reason ?? 'Failed to save training';
}

class TrainingGenerationFailure extends TrainingFailure {
  const TrainingGenerationFailure([this.reason]);

  final String? reason;

  @override
  String get message => reason ?? 'Failed to generate training';
}
