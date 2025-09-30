import 'package:flutter/cupertino.dart';
import 'dart:async';
import 'habit_completed_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/habit_provider.dart';
import 'package:flutter/material.dart' show CircularProgressIndicator;

class HabitTimerScreen extends StatefulWidget {
  final dynamic habit;
  const HabitTimerScreen({super.key, required this.habit});

  @override
  State<HabitTimerScreen> createState() => _HabitTimerScreenState();
}

class _HabitTimerScreenState extends State<HabitTimerScreen> with WidgetsBindingObserver {
  late int totalSeconds;
  late int remainingSeconds;
  Timer? _timer;
  bool _isRunning = true;
  bool _isCompleted = false;
  DateTime? _pausedTime;
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    totalSeconds = (widget.habit.duration ?? 10) * 60;
    remainingSeconds = totalSeconds;
    _startTimer();
  }
  
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _pauseTimer();
    } else if (state == AppLifecycleState.resumed && _pausedTime != null) {
      _resumeTimer();
    }
  }
  
  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _completeTimer();
        }
      });
    });
  }
  
  void _pauseTimer() {
    _timer?.cancel();
    _pausedTime = DateTime.now();
    setState(() {
      _isRunning = false;
    });
  }
  
  void _resumeTimer() {
    _pausedTime = null;
    _startTimer();
    setState(() {
      _isRunning = true;
    });
  }
  
  void _completeTimer() {
    _timer?.cancel();
    setState(() {
      _isCompleted = true;
      _isRunning = false;
    });
  }

  void _onTimerComplete(BuildContext context, WidgetRef ref) async {
    // Only update streak if timer was fully completed
    if (_isCompleted) {
      try {
        // Update the streak in Firestore
        await ref.read(habitProvider.notifier).toggleHabitCompletion(widget.habit.id);
        
        // Force refresh the habits data
        await ref.read(habitProvider.notifier).loadHabits();
        
        // Get the updated habit data
        final updatedHabits = await ref.read(habitStreamProvider.future);
        final updatedHabit = updatedHabits.firstWhere((h) => h.id == widget.habit.id);
        
        if (mounted) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (_) => HabitCompletedScreen(
                habit: updatedHabit, 
                duration: totalSeconds,
                wasCompleted: true,
              ),
            ),
          );
        }
      } catch (e) {
        print('Error updating habit streak: $e');
        if (mounted) {
          Navigator.of(context).pushReplacement(
            CupertinoPageRoute(
              builder: (_) => HabitCompletedScreen(
                habit: widget.habit, 
                duration: totalSeconds,
                wasCompleted: true,
              ),
            ),
          );
        }
      }
    } else {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          CupertinoPageRoute(
            builder: (_) => HabitCompletedScreen(
              habit: widget.habit, 
              duration: totalSeconds,
              wasCompleted: false,
            ),
          ),
        );
      }
    }
  }
  
  void _cancelTimer(BuildContext context) {
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      parent: ProviderScope.containerOf(context),
      child: Consumer(
        builder: (context, ref, _) {
          final progress = 1 - (remainingSeconds / totalSeconds);
          final min = (remainingSeconds ~/ 60).toString().padLeft(2, '0');
          final sec = (remainingSeconds % 60).toString().padLeft(2, '0');
          
          // Determine which emoji to show based on progress
          String emoji = '🥚';
          if (progress > 0.33) emoji = '🐣';
          if (progress > 0.66) emoji = '🐥';
          if (progress >= 1) emoji = '🐔';
          
          return CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text(widget.habit.title),
              backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
            ),
            backgroundColor: CupertinoColors.systemBackground,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    // Progress indicator
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Circular progress background
                          Container(
                            width: 250,
                            height: 250,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: CupertinoColors.systemGrey6,
                            ),
                          ),
                          // Progress circle
                          SizedBox(
                            width: 230,
                            height: 230,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 15,
                              backgroundColor: CupertinoColors.systemGrey5,
                              color: _isCompleted 
                                ? CupertinoColors.activeGreen 
                                : CupertinoColors.activeBlue,
                            ),
                          ),
                          // Emoji and timer
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(emoji, style: const TextStyle(fontSize: 60)),
                              const SizedBox(height: 8),
                              Text(
                                '$min:$sec',
                                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Status text
                    Text(
                      _isCompleted 
                        ? 'Great job! You completed your habit!' 
                        : '${widget.habit.title} in progress...',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: _isCompleted ? CupertinoColors.activeGreen : CupertinoColors.systemGrey,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    Text(
                      _isCompleted 
                        ? 'Your streak has been updated!' 
                        : 'Keep going to increase your streak',
                      style: const TextStyle(fontSize: 14, color: CupertinoColors.systemGrey),
                    ),
                    
                    const Spacer(),
                    
                    // Control buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _isCompleted 
                        ? [
                            // Continue button when completed
                            CupertinoButton.filled(
                              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                              child: const Text('Continue'),
                              onPressed: () => _onTimerComplete(context, ref),
                            ),
                          ]
                        : [
                            // Cancel button
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              color: CupertinoColors.systemGrey5,
                              child: const Text('Cancel'),
                              onPressed: () => _cancelTimer(context),
                            ),
                            const SizedBox(width: 16),
                            // Pause/Resume button
                            CupertinoButton(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              color: _isRunning ? CupertinoColors.systemGrey4 : CupertinoColors.activeBlue,
                              child: Icon(_isRunning ? CupertinoIcons.pause : CupertinoIcons.play),
                              onPressed: () {
                                if (_isRunning) {
                                  _pauseTimer();
                                } else {
                                  _resumeTimer();
                                }
                              },
                            ),
                          ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 