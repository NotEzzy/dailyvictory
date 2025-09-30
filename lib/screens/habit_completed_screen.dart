import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';

class HabitCompletedScreen extends StatefulWidget {
  final dynamic habit;
  final int duration;
  final bool wasCompleted;

  const HabitCompletedScreen({
    super.key, 
    required this.habit, 
    required this.duration,
    this.wasCompleted = true,
  });
  
  @override
  State<HabitCompletedScreen> createState() => _HabitCompletedScreenState();
}

class _HabitCompletedScreenState extends State<HabitCompletedScreen> with SingleTickerProviderStateMixin {
  late AnimationController _confettiController;
  final List<Color> _confettiColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.pink,
  ];
  
  @override
  void initState() {
    super.initState();
    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    
    // Start the confetti animation if habit was completed
    if (widget.wasCompleted) {
      _confettiController.repeat();
      
      // Stop the animation after 3 seconds
      Timer(const Duration(seconds: 3), () {
        if (mounted) {
          _confettiController.stop();
        }
      });
    }
  }
  
  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Widget _buildConfetti() {
    return AnimatedBuilder(
      animation: _confettiController,
      builder: (context, child) {
        return Positioned.fill(
          child: IgnorePointer(
            child: CustomPaint(
              painter: ConfettiPainter(
                colors: _confettiColors,
                animation: _confettiController,
              ),
            ),
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final min = (widget.duration ~/ 60).toString();
    final emoji = widget.wasCompleted ? '🐔' : '🐥';
    final title = widget.wasCompleted
        ? 'Congratulations!'
        : 'Good effort!';
    final message = widget.wasCompleted
        ? 'You completed ${widget.habit.title} for $min minutes and earned a streak!'
        : 'You worked on ${widget.habit.title} but didn\'t complete the full session.';
    
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(widget.wasCompleted ? 'Habit Completed' : 'Session Ended'),
        backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
      ),
      backgroundColor: CupertinoColors.systemBackground,
      child: Stack(
        children: [
          // Confetti animation if completed
          if (widget.wasCompleted) _buildConfetti(),
          
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const Spacer(flex: 1),
                  
                  // Achievement card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: CupertinoColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.systemGrey.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Emoji with background
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: widget.wasCompleted 
                                ? const Color(0xFFE8F5E9) 
                                : const Color(0xFFFFF9C4),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              emoji, 
                              style: const TextStyle(fontSize: 60),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        // Status icon
                        Icon(
                          widget.wasCompleted 
                              ? CupertinoIcons.check_mark_circled_solid 
                              : CupertinoIcons.timer,
                          color: widget.wasCompleted 
                              ? CupertinoColors.activeGreen 
                              : CupertinoColors.systemYellow,
                          size: 40,
                        ),
                        const SizedBox(height: 16),
                        
                        // Title
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        
                        // Message
                        Text(
                          message,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16, 
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                        
                        // Stats
                        if (widget.wasCompleted) ...[  
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _buildStatItem('Duration', '$min min'),
                              _buildStatItem('Streak', '${widget.habit.currentStreak + 1}'),
                              _buildStatItem('Points', '+10'),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  const Spacer(flex: 1),
                  
                  // Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.wasCompleted) ...[  
                        CupertinoButton(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          color: CupertinoColors.systemGrey5,
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(CupertinoIcons.share),
                              SizedBox(width: 8),
                              Text(
                                'Share',
                                style: TextStyle(
                                  inherit: true,
                                  color: CupertinoColors.label,
                                ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            // Share functionality would go here
                          },
                        ),
                        const SizedBox(width: 16),
                      ],
                      
                      CupertinoButton.filled(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        child: const Text(
                          'Continue',
                          style: TextStyle(
                            inherit: true,
                            color: CupertinoColors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: CupertinoColors.systemGrey,
          ),
        ),
      ],
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final List<Color> colors;
  final Animation<double> animation;

  ConfettiPainter({required this.colors, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final random = math.Random();

    for (int i = 0; i < 100; i++) {
      paint.color = colors[random.nextInt(colors.length)];
      canvas.drawCircle(
        Offset(
          size.width * random.nextDouble(),
          size.height * random.nextDouble(),
        ),
        5 * animation.value,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}