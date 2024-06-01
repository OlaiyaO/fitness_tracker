import 'package:equatable/equatable.dart';

abstract class GoalEvent extends Equatable {
  const GoalEvent();

  @override
  List<Object> get props => [];
}

class SelectDistance extends GoalEvent {
  final String activity;
  final int distance;

  const SelectDistance(this.activity, this.distance);

  @override
  List<Object> get props => [activity, distance];
}

class ActivityDetected extends GoalEvent {
  final String activity;

  const ActivityDetected(this.activity);

  @override
  List<Object> get props => [activity];
}