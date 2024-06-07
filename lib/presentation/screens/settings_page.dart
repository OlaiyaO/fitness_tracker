import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fitness_tracker/presentation/widgets/goal_setter.dart';
import '../../blocs/goal_bloc/goal_bloc.dart';
import '../../blocs/goal_bloc/goal_event.dart';
import '../../blocs/goal_bloc/goal_state.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const String kWalking = 'Walking';
  static const String kRunning = 'Running';
  static const String kCycling = 'Cycling';

  static const double kMaxWalking = 10;
  static const double kMaxRunning = 20;
  static const double kMaxCycling = 50;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => GoalBloc()..add(FetchGoalValues()),
      child: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: BlocBuilder<GoalBloc, GoalState>(
            builder: (context, state) {
              if (state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null) {
                return Center(child: Text('Error: ${state.error}'));
              }
              return Column(
                children: [
                  GoalSetter(
                    currentValue: state.walkingValue,
                    activity: kWalking,
                    maxSliderValue: kMaxWalking,
                  ),
                  GoalSetter(
                    currentValue: state.runningValue,
                    activity: kRunning,
                    maxSliderValue: kMaxRunning,
                  ),
                  GoalSetter(
                    currentValue: state.cyclingValue,
                    activity: kCycling,
                    maxSliderValue: kMaxCycling,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
