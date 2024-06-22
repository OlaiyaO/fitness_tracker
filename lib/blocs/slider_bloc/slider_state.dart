abstract class SliderState {}

class SliderInitial extends SliderState {}

class SliderLoaded extends SliderState {
  late final double walking;
  late final double running;
  late final double cycling;

  SliderLoaded(this.walking, this.running, this.cycling);
}

class SliderError extends SliderState {
  final String message;

  SliderError(this.message);
}