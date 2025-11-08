
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class CycleRing extends StatelessWidget {
  final double percent;
  final String label;

  const CycleRing({super.key, required this.percent, required this.label});

  @override
  Widget build(BuildContext context) {
    return CircularPercentIndicator(
      radius: 70,
      lineWidth: 10,
      percent: percent.clamp(0.0, 1.0),
      center: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      progressColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.pink.shade50,
    );
  }
}
