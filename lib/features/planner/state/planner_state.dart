part of 'planner_cubit.dart';

sealed class PlannerState extends Equatable {
  const PlannerState();
}

final class PlannerLoaded extends PlannerState {
  @override
  List<Object?> get props => throw UnimplementedError();
}

final class PlannerUpdated extends PlannerState {
  @override
  List<Object?> get props => throw UnimplementedError();
}
