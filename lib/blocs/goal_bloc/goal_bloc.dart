import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/goal_model.dart';
import 'goal_event.dart';
import 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc() : super(GoalState(
    detectedActivity: 'Unknown',
    goals: {
      'Running': Goal(activity: 'Running', distances: const [1, 5, 10], selectedDistance: 1),
      'Walking': Goal(activity: 'Walking', distances: const [1, 5, 10], selectedDistance: 1),
      'Cycling': Goal(activity: 'Cycling', distances: const [5, 10, 20], selectedDistance: 5),
    },
  )) {
    on<SelectDistance>((event, emit) {
      final goals = Map<String, Goal>.from(state.goals);
      goals[event.activity] = goals[event.activity]!.copyWith(selectedDistance: event.distance);
      emit(state.copyWith(goals: goals));
    });

    on<ActivityDetected>((event, emit) {
      emit(state.copyWith(detectedActivity: event.activity));
    });
  }
}