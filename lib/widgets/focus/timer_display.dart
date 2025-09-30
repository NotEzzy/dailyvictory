import 'package:dailyvictory/utils/colors.dart';
import 'package:flutter/material.dart';


/// A widget to display a timer
class TimerDisplay extends StatelessWidget {
  final int timeRemaining;
  final bool isActive;
  final bool isBreak;

  const TimerDisplay({
    super.key,
    required this.timeRemaining,
    required this.isActive,
    this.isBreak = false,
  });

  @override
  Widget build(BuildContext context) {
    final minutes = (timeRemaining / 60).floor();
    final seconds = timeRemaining % 60;
    final formattedTime = '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          formattedTime,
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
            color: isBreak ? AppColors.secondary : AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isActive ? 'Time Remaining' : 'Paused',
          style: TextStyle(
            fontSize: 16,
            color: isBreak ? AppColors.secondary : AppColors.primary,
          ),
        ),
      ],
    );
  }
} 