import 'package:flutter/cupertino.dart';
import 'package:dailyvictory/screens/auth/login_screen.dart';
import 'package:dailyvictory/screens/auth/signup_screen.dart';
import 'package:dailyvictory/screens/dashboard/dashboard_screen.dart';
import 'package:dailyvictory/screens/profile/profile_screen.dart';
import 'package:dailyvictory/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String dashboard = '/dashboard';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String mainTab = '/main-tab';
  static const String forgotPassword = '/forgot-password';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return CupertinoPageRoute(builder: (_) => const SplashScreen());
      case login:
        return CupertinoPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return CupertinoPageRoute(builder: (_) => const SignupScreen());
      case dashboard:
        return CupertinoPageRoute(builder: (_) => const DashboardScreen());
      case profile:
        return CupertinoPageRoute(builder: (_) => const ProfileScreen());
      default:
        return CupertinoPageRoute(
          builder: (_) => const CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: Text('Not Found'),
            ),
            child: Center(
              child: Text('Route not found'),
            ),
          ),
        );
    }
  }
} 