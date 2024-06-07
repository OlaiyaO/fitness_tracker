import 'package:flutter/material.dart';

class GoalSetter extends StatelessWidget {
  const GoalSetter(
      {super.key,
      required this.currentValue,
      required this.activity,
      required this.maxSliderValue});

  final double currentValue;
  final String activity;
  final double maxSliderValue;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(activity),
        const SizedBox(
          height: 12,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                flex: 16,
                child: Slider(
                  value: currentValue,
                  onChanged: (value) {},
                  max: maxSliderValue,
                  divisions: 10,
                )),
            const Spacer(
              flex: 2,
            ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(child: Text('$currentValue')),
              ),
            )
          ],
        ),
      ],
    );
  }
}
