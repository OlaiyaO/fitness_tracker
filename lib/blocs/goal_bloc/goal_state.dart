import 'package:equatable/equatable.dart';
import '../../data/models/goal_model.dart';

class GoalState extends Equatable {
  final String detectedActivity;
  final Map<String, Goal> goals;

  const GoalState({
    required this.detectedActivity,
    required this.goals,
  });

  GoalState copyWith({
    String? detectedActivity,
    Map<String, Goal>? goals,
  }) {
    return GoalState(
      detectedActivity: detectedActivity ?? this.detectedActivity,
      goals: goals ?? this.goals,
    );
  }

  @override
  List<Object> get props => [detectedActivity, goals];
}