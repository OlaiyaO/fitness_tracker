import 'dart:async';
import 'package:pedometer/pedometer.dart';

class PedometerService {
  Stream<StepCount>? _stepCountStream;
  Stream<PedestrianStatus>? _pedestrianStatusStream;
  int _totalSteps = 0;
  String _pedestrianStatus = 'unknown';

  final StreamController<int> _stepsController = StreamController<int>.broadcast();
  final StreamController<String> _statusController = StreamController<String>.broadcast();

  Stream<int> get stepsStream => _stepsController.stream;
  Stream<String> get statusStream => _statusController.stream;

  /// Handle step count changes
  void _onStepCount(StepCount event) {
    _totalSteps = event.steps;
    _stepsController.add(_totalSteps);
  }

  /// Handle pedestrian status changes
  void _onPedestrianStatusChanged(PedestrianStatus event) {
    _pedestrianStatus = event.status;
    _statusController.add(_pedestrianStatus);
  }

  /// Handle errors
  void _onStepCountError(error) {
    print('Step Count Error: $error');
  }

  void _onPedestrianStatusError(error) {
    print('Pedestrian Status Error: $error');
  }

  Future<void> initPedometer() async {
    try {
      // Init streams
      _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
      _stepCountStream = Pedometer.stepCountStream;

      // Listen to streams and handle errors
      _stepCountStream?.listen(_onStepCount).onError(_onStepCountError);
      _pedestrianStatusStream?.listen(_onPedestrianStatusChanged).onError(_onPedestrianStatusError);
    } catch (e) {
      print('Failed to initialize pedometer: $e');
    }
  }

  void dispose() {
    _stepsController.close();
    _statusController.close();
  }
}
