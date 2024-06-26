import 'package:fitness_tracker/blocs/slider_bloc/slider_bloc.dart';
import 'package:flutter/material.dart';
import 'package:fitness_tracker/presentation/widgets/slider_setter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/slider_bloc/slider_event.dart';
import '../../blocs/slider_bloc/slider_state.dart';
import '../../services/shared_preference_service.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  static const String kWalking = 'Walking';
  static const String kRunning = 'Running';
  static const String kCycling = 'Cycling';

  static const double kMaxWalking = 10;
  static const double kMaxRunning = 20;
  static const double kMaxCycling = 50;

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  late double _walkingValue;
  late double _runningValue;
  late double _cyclingValue;
  bool _isInitialized = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<SliderBloc>().add(LoadSliderValues());
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style = ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 20),
      padding: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<SliderBloc, SliderState>(
        builder: (context, state) {
          if (state is SliderLoaded) {

            if (!_isInitialized) {
              _walkingValue = state.walking;
              _runningValue = state.running;
              _cyclingValue = state.cycling;
              _isInitialized = true;
            }

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              margin: const EdgeInsets.only(bottom: 32.0),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        SliderSetter(
                          maxSliderValue: SettingsPage.kMaxWalking,
                          sliderID: SettingsPage.kWalking,
                          currentSliderValue: _walkingValue,
                          onSliderChanged: (value) {
                            setState(() {
                              _walkingValue = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        SliderSetter(
                            maxSliderValue: SettingsPage.kMaxRunning,
                            sliderID: SettingsPage.kRunning,
                            currentSliderValue: _runningValue,
                            onSliderChanged: (value) {
                              setState(() {
                                _runningValue = value;
                              });
                            }),
                        const SizedBox(height: 24),
                        SliderSetter(
                            maxSliderValue: SettingsPage.kMaxCycling,
                            sliderID: SettingsPage.kCycling,
                            currentSliderValue: _cyclingValue,
                            onSliderChanged: (value) {
                              setState(() {
                                _cyclingValue = value;
                              });
                            }),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: style,
                      onPressed: () {
                        final bloc = context.read<SliderBloc>();
                        bloc.add(UpdateSliderValues(
                          _walkingValue,
                          _runningValue,
                          _cyclingValue
                        ));
                        SharedPreferencesService.getSliderValues()
                            .then((values) {
                          print('Saved values: $values');
                        }).catchError((error) {
                          print('Error retrieving saved values: $error');
                        });
                      },
                      child: const Text('Save'),
                    ),
                  ),
                ],
              ),
            );
          } else if (state is SliderInitial) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return const Center(child: Text('Failed to load slider values'));
          }
        },
      ),
    );
  }
}
