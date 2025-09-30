import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/dashboard/dashboard_screen.dart';
import '../screens/progress_screen.dart';
import '../screens/profile/profile_screen.dart';
import 'bad_habits_dashboard_screen.dart';

/// Main tab screen that hosts the CupertinoTabBar
class MainTabScreen extends ConsumerStatefulWidget {
  const MainTabScreen({super.key});

  @override
  ConsumerState<MainTabScreen> createState() => _MainTabScreenState();
}

class _MainTabScreenState extends ConsumerState<MainTabScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      resizeToAvoidBottomInset: true,
      tabBar: CupertinoTabBar(
        height: 60,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chart_bar),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.flame),
            label: 'Bad Habits',
          ),
        ],
      ),
      tabBuilder: (context, index) {
        switch (index) {
          case 0:
            return CupertinoTabView(
              builder: (context) => const DashboardScreen(),
            );
          case 1:
            return CupertinoTabView(
              builder: (context) => const ProgressScreen(),
            );
          case 2:
            return CupertinoTabView(
              builder: (context) => const ProfileScreen(),
            );
          case 3:
            return CupertinoTabView(
              builder: (context) => const BadHabitsDashboardScreen(),
            );
          default:
            return CupertinoTabView(
              builder: (context) => const DashboardScreen(),
            );
        }
      },
    );
  }
}
