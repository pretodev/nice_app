import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'training_store.g.dart';

@riverpod
class TrainingStore extends _$TrainingStore {
  @override
  TrainingState build() {
    return const TrainingState();
  }

  void emit(TrainingEvent event) {
    state = switch (event) {
      TrainingLoaded(:final training) => state.copyWith(
        training: () => training,
        status: TrainingStatus.loaded,
      ),
      TrainingUpdated(:final training) => state.copyWith(
        training: () => training,
      ),
      TrainingCleared() => state.copyWith(
        training: () => null,
        status: TrainingStatus.idle,
      ),
      TrainingLoading() => state.copyWith(
        status: TrainingStatus.loading,
      ),
      TrainingError() => state.copyWith(
        status: TrainingStatus.error,
      ),
    };
  }
}

@immutable
class TrainingState {
  final DailyTraining? training;
  final TrainingStatus status;

  const TrainingState({
    this.training,
    this.status = TrainingStatus.idle,
  });

  TrainingState copyWith({
    ValueGetter<DailyTraining?>? training,
    TrainingStatus? status,
  }) {
    return TrainingState(
      training: training != null ? training() : this.training,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TrainingState &&
        other.training == training &&
        other.status == status;
  }

  @override
  int get hashCode => training.hashCode ^ status.hashCode;
}

sealed class TrainingEvent {
  const TrainingEvent();
}

class TrainingLoaded extends TrainingEvent {
  const TrainingLoaded(this.training);

  final DailyTraining training;
}

class TrainingUpdated extends TrainingEvent {
  const TrainingUpdated(this.training);

  final DailyTraining training;
}

class TrainingCleared extends TrainingEvent {
  const TrainingCleared();
}

class TrainingLoading extends TrainingEvent {
  const TrainingLoading();
}

class TrainingError extends TrainingEvent {
  const TrainingError();
}
