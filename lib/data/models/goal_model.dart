import 'package:equatable/equatable.dart';

class Goal extends Equatable {
  final String activity;
  final List<int> distances;
  final int selectedDistance;

  const Goal({
    required this.activity,
    required this.distances,
    required this.selectedDistance,
  });

  Goal copyWith({int? selectedDistance}) {
    return Goal(
      activity: activity,
      distances: distances,
      selectedDistance: selectedDistance ?? this.selectedDistance,
    );
  }

  @override
  List<Object> get props => [activity, distances, selectedDistance];
}
