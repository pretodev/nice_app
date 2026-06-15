import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'planner_state.dart';

class PlannerCubit(super.initialState) extends Cubit<PlannerState> {
  Future<void> addExercice() async {
    emit(state);
  }
}
