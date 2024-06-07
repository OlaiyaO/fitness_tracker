import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'goal_event.dart';
import 'goal_state.dart';

class GoalBloc extends Bloc<GoalEvent, GoalState> {
  GoalBloc() : super(GoalState.initial());

  Stream<GoalState> mapEventToState(GoalEvent event) async* {
    if (event is FetchGoalValues) {
      yield state.copyWith(isLoading: true);
      try {
        final firestore = FirebaseFirestore.instance;
        final snapshot = await firestore.collection('goals').doc('userGoals').get();
        final data = snapshot.data();
        if (data != null) {
          yield state.copyWith(
            walkingValue: data['walking'] ?? 1,
            runningValue: data['running'] ?? 1,
            cyclingValue: data['cycling'] ?? 1,
            isLoading: false,
          );
        } else {
          yield state.copyWith(isLoading: false);
        }
      } catch (error) {
        yield state.copyWith(isLoading: false, error: error.toString());
      }
    }
  }
}
