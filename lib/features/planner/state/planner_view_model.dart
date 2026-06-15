import 'package:equatable/equatable.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/core/state/view_model.dart';
import 'package:nice/features/training/data/exercise.dart';

class PlannerViewModel extends ViewModel<PlannerState> {
  PlannerViewModel() : super(PlannerLoaded());

  late final load = _load.bind();
  late final addExercice = _addExercice.bind();

  FutureResult<Unit> _load() async {
    emit(PlannerLoaded());
    return ok;
  }

  FutureResult<Unit> _addExercice(Exercise exercice) async {
    emit(PlannerUpdated());
    return ok;
  }
}

sealed class PlannerState extends Equatable {
  const PlannerState();
}

final class PlannerLoaded extends PlannerState {
  @override
  List<Object?> get props => [];
}

final class PlannerUpdated extends PlannerState {
  @override
  List<Object?> get props => [];
}
