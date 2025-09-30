import 'package:dailyvictory/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../screens/splash_screen.dart';
import 'dart:developer' as developer;


/// Auth wrapper widget
class AuthWrapper extends ConsumerWidget {
  final Widget child;
  final bool requireAuth;

  const AuthWrapper({
    super.key,
    required this.child,
    this.requireAuth = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    developer.log('AuthWrapper: Building with auth state - isLoading: ${authState.isLoading}, user: ${authState.user?.uid ?? 'null'}');
    
    // Show loading indicator while checking auth state
    if (authState.isLoading) {
      developer.log('AuthWrapper: Showing loading screen');
      return const SplashScreen();
    }
    
    // If auth is required and user is not authenticated, redirect to login
    if (requireAuth && authState.user == null) {
      developer.log('AuthWrapper: User not authenticated, redirecting to login');
      return MaterialApp(
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                developer.log('AuthWrapper: Navigating to login');
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            });
            return const SplashScreen();
          },
        ),
      );
    }
    
    // If auth is not required and user is authenticated, redirect to dashboard
    if (!requireAuth && authState.user != null) {
      developer.log('AuthWrapper: User already authenticated, redirecting to dashboard');
      return MaterialApp(
        onGenerateRoute: AppRoutes.generateRoute,
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                developer.log('AuthWrapper: Navigating to dashboard');
                Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              }
            });
            return const SplashScreen();
          },
        ),
      );
    }
    
    developer.log('AuthWrapper: Showing child widget');
    // Show the child widget if auth requirements are met
    return child;
  }
}

/// Auth route wrapper
class AuthRouteWrapper extends ConsumerWidget {
  final String routeName;
  final bool requireAuth;

  const AuthRouteWrapper({
    super.key,
    required this.routeName,
    this.requireAuth = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    
    developer.log('AuthRouteWrapper: Building with auth state - isLoading: ${authState.isLoading}, user: ${authState.user?.uid ?? 'null'}');
    
    // Show loading indicator while checking auth state
    if (authState.isLoading) {
      developer.log('AuthRouteWrapper: Showing loading screen');
      return const SplashScreen();
    }
    
    // If auth is required and user is not authenticated, redirect to login
    if (requireAuth && authState.user == null) {
      developer.log('AuthRouteWrapper: User not authenticated, redirecting to login');
      return MaterialApp(
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                developer.log('AuthRouteWrapper: Navigating to login');
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              }
            });
            return const SplashScreen();
          },
        ),
      );
    }
    
    // If auth is not required and user is authenticated, redirect to dashboard
    if (!requireAuth && authState.user != null) {
      developer.log('AuthRouteWrapper: User already authenticated, redirecting to dashboard');
      return MaterialApp(
        home: Builder(
          builder: (context) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (context.mounted) {
                developer.log('AuthRouteWrapper: Navigating to dashboard');
                Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
              }
            });
            return const SplashScreen();
          },
        ),
      );
    }
    
    // Navigate to the route
    return MaterialApp(
      home: Builder(
        builder: (context) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) {
              developer.log('AuthRouteWrapper: Navigating to $routeName');
              Navigator.pushReplacementNamed(context, routeName);
            }
          });
          return const SplashScreen();
        },
      ),
    );
  }
} 