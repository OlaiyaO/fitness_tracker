import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_activity_recognition/flutter_activity_recognition.dart';
import '../../blocs/goal_bloc/goal_bloc.dart';
import '../../blocs/goal_bloc/goal_event.dart';
import '../../blocs/goal_bloc/goal_state.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late FlutterActivityRecognition _activityRecognition;
  late Stream<Activity> _activityStream;
  late StreamSubscription<Activity> _activitySubscription;

  @override
  void initState() {
    super.initState();
    _activityRecognition = FlutterActivityRecognition.instance;
    _activityStream = _activityRecognition.activityStream;
    _activitySubscription = _activityStream.listen(_onActivityDetected);
  }

  void _onActivityDetected(Activity activity) {
    if (activity.type == ActivityType.WALKING) {
      context.read<GoalBloc>().add(const ActivityDetected('Walking'));
    } else if (activity.type == ActivityType.RUNNING) {
      context.read<GoalBloc>().add(const ActivityDetected('Running'));
    } else if (activity.type == ActivityType.ON_BICYCLE) {
      context.read<GoalBloc>().add(const ActivityDetected('Cycling'));
    }
  }

  @override
  void dispose() {
    _activitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GoalBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: Column(
          children: [
            const SizedBox(height: 16),
            _buildActivityDisplay(),
            const SizedBox(height: 16),
            _buildDistanceOptions(),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityDisplay() {
    return BlocBuilder<GoalBloc, GoalState>(
      builder: (context, state) {
        return Text('Detected Activity: ${state.detectedActivity ?? 'Waiting for activity...'}');
      },
    );
  }

  Widget _buildDistanceOptions() {
    return BlocBuilder<GoalBloc, GoalState>(
      builder: (context, state) {
        final goal = state.detectedActivity != null ? state.goals[state.detectedActivity] : null;
        return goal != null
            ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select distance for ${goal.activity}:'),
            Wrap(
              spacing: 8.0,
              children: goal.distances.map((distance) {
                return ChoiceChip(
                  label: Text('$distance km'),
                  selected: goal.selectedDistance == distance,
                  onSelected: (selected) {
                    context.read<GoalBloc>().add(SelectDistance(goal.activity, distance));
                  },
                );
              }).toList(),
            ),
          ],
        )
            : const Center(child: Text('No activity detected.'));
      },
    );
  }
}
