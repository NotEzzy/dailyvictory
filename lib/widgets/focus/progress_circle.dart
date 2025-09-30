import 'package:dailyvictory/utils/colors.dart';
import 'package:flutter/material.dart';


/// A circular progress indicator with a child widget in the center
class ProgressCircle extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Widget child;
  final Color? color;

  const ProgressCircle({
    super.key,
    required this.progress,
    required this.size,
    required this.strokeWidth,
    required this.child,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background circle
          CircularProgressIndicator(
            value: 1.0,
            strokeWidth: strokeWidth,
            backgroundColor: Colors.grey[200],
          ),
          // Progress circle
          CircularProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            strokeWidth: strokeWidth,
            color: color ?? AppColors.primary,
          ),
          // Child widget (usually the timer display)
          child,
        ],
      ),
    );
  }
} 