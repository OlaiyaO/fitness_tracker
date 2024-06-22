import 'package:flutter/material.dart';

class SliderSetter extends StatefulWidget {
  const SliderSetter({
    super.key,
    required this.currentSliderValue,
    required this.maxSliderValue,
    required this.sliderID, required this.onSliderChanged,

  });

  final Function(double) onSliderChanged;
  final String sliderID;
  final double currentSliderValue;
  final double maxSliderValue;

  @override
  State<SliderSetter> createState() => _SliderSetterState();
}

class _SliderSetterState extends State<SliderSetter> {
  late double _sliderValue;

  @override
  void initState() {
    super.initState();
    _sliderValue = widget.currentSliderValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(widget.sliderID),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 20,
              child: Slider(
                min: widget.maxSliderValue/10,
                value: _sliderValue,
                onChanged: (value) {
                  setState(() {
                    _sliderValue = value;
                    widget.onSliderChanged(value);
                  });
                },
                max: widget.maxSliderValue,
                divisions: 9,
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text(_sliderValue.toStringAsFixed(1))),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
