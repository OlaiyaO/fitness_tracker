import 'dart:async';
import 'package:pedometer/pedometer.dart';

class PedometerService {
  Stream<StepCount>? _stepCountStream;
  int _totalSteps = 0;

  final StreamController<int> _stepsController = StreamController<int>.broadcast();

  Stream<int> get stepsStream => _stepsController.stream;

  int get totalSteps => _totalSteps;

  /// Handle step count changes
  void _onStepCount(StepCount event) {
    _totalSteps = event.steps;
    _stepsController.add(_totalSteps);
  }

  /// Handle errors
  void _onStepCountError(error) {
    print('Step Count Error: $error');
  }

  Future<void> initPedometer() async {
    try {
      // Init streams
      _stepCountStream = Pedometer.stepCountStream;

      // Listen to step count stream and handle errors
      _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);
    } catch (e) {
      print('Failed to initialize pedometer: $e');
    }
  }

  void dispose() {
    _stepsController.close();
  }
}
