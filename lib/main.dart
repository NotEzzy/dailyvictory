import 'package:dailyvictory/services/theme_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dailyvictory/providers/auth_provider.dart';
import 'package:dailyvictory/providers/theme_provider.dart';
import 'package:dailyvictory/services/logging_service.dart';
import 'package:dailyvictory/services/analytics_service.dart';
import 'package:dailyvictory/utils/constants.dart';
import 'package:dailyvictory/screens/splash_screen.dart';
import 'package:dailyvictory/screens/auth/login_screen.dart';
import 'package:dailyvictory/screens/main_tab_screen.dart';
import 'package:dailyvictory/widgets/auth/auth_wrapper.dart';
import 'package:dailyvictory/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  // Initialize services
  final loggingService = LoggingService();
  // Initialize analytics service
  AnalyticsService();
  
  loggingService.info('App initialized');
  
  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isDarkMode = ref.watch(themeModeProvider);
    final themeService = ref.watch(themeServiceProvider);
    
    return CupertinoApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: CupertinoThemeData(
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: ThemeService.primaryColor,
        scaffoldBackgroundColor: themeService.backgroundColor,
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(inherit: true, color: themeService.textColor),
          navTitleTextStyle: TextStyle(inherit: true, color: themeService.textColor),
        ),
      ),
      home: _buildInitialScreen(authState),
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }

  Widget _buildInitialScreen(AuthState authState) {
    if (authState.isLoading) {
      return const SplashScreen();
    }

    if (authState.user != null) {
      return const AuthWrapper(
        requireAuth: true,
        child: MainTabScreen(),
      );
    }

    return const AuthWrapper(
      requireAuth: false,
      child: LoginScreen(),
    );
  }
}
