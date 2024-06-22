import 'package:flutter_bloc/flutter_bloc.dart';
import '../../services/shared_preference_service.dart';
import 'slider_event.dart';
import 'slider_state.dart';

class SliderBloc extends Bloc<SliderEvent, SliderState> {
  final SharedPreferencesService sharedPreferencesService;

  SliderBloc(this.sharedPreferencesService) : super(SliderInitial()) {
    on<LoadSliderValues>(_onLoadSliderValues);
    on<UpdateSliderValues>(_onUpdateSliderValues);
  }

  Future<void> _onLoadSliderValues(LoadSliderValues event,
      Emitter<SliderState> emit) async {
    try {
      final Map<String, double> values = await SharedPreferencesService.getSliderValues();
      print('Bloc: Loaded values: $values');
      emit(SliderLoaded(values['double_value_1']!, values['double_value_2']!,
          values['double_value_3']!));
    } catch (e) {
      emit(SliderError('Failed to load slider values: $e'));
    }
  }

  Future<void> _onUpdateSliderValues(UpdateSliderValues event,
      Emitter<SliderState> emit) async {
    try {
      print('Bloc: Updating values to: ${event.value1}, ${event.value2}, ${event.value3}');
      await SharedPreferencesService.setSliderValues(
          event.value1, event.value2, event.value3);
      final values = await SharedPreferencesService.getSliderValues();
      print('Bloc: Updated and loaded values: $values');
      emit(SliderLoaded(values['double_value_1']!, values['double_value_2']!,
          values['double_value_3']!));
    } catch (e) {
      emit(SliderError('Failed to update slider values: $e'));
    }
  }
}

