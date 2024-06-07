import 'package:equatable/equatable.dart';

abstract class GoalEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchGoalValues extends GoalEvent {}
