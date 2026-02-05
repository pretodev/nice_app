import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:nice/features/training/data/training.dart';
import 'package:nice/features/training/data/training_status.dart';
import 'package:nice/shared/state/store.dart';

class TrainingStore extends Store<TrainingState> {
  TrainingStore() : super(const TrainingState());

  void load(DailyTraining training) {
    setState(
      state.copyWith(
        training: () => training,
        status: TrainingStatus.loaded,
      ),
    );
  }

  void update(DailyTraining training) {
    setState(
      state.copyWith(
        training: () => training,
      ),
    );
  }

  void clear() {
    setState(
      state.copyWith(
        training: () => null,
        status: TrainingStatus.idle,
      ),
    );
  }

  void loading() {
    setState(
      state.copyWith(
        status: TrainingStatus.loading,
      ),
    );
  }

  void error() {
    setState(
      state.copyWith(
        status: TrainingStatus.error,
      ),
    );
  }
}

@immutable
class TrainingState extends Equatable {
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
  List<Object?> get props => [training, status];

  @override
  bool get stringify => true;
}
