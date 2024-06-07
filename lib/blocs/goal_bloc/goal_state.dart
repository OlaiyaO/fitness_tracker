import 'package:equatable/equatable.dart';

class GoalState extends Equatable {
  final double walkingValue;
  final double runningValue;
  final double cyclingValue;
  final bool isLoading;
  final String? error;

  const GoalState({
    required this.walkingValue,
    required this.runningValue,
    required this.cyclingValue,
    this.isLoading = false,
    this.error,
  });

  factory GoalState.initial() {
    return const GoalState(
      walkingValue: 1,
      runningValue: 2,
      cyclingValue: 5,
    );
  }

  GoalState copyWith({
    double? walkingValue,
    double? runningValue,
    double? cyclingValue,
    bool? isLoading,
    String? error,
  }) {
    return GoalState(
      walkingValue: walkingValue ?? this.walkingValue,
      runningValue: runningValue ?? this.runningValue,
      cyclingValue: cyclingValue ?? this.cyclingValue,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [walkingValue, runningValue, cyclingValue, isLoading, error];
}