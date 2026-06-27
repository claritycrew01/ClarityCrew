import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'providers/accessibility_provider.dart';
import 'providers/auth_provider.dart';
import 'utils/theme.dart';
import 'utils/colors.dart';
import 'screens/splash_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/course_selection_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/subject_screen.dart';
import 'screens/lesson_screen.dart';
import 'screens/ai_assistant_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/accessibility_settings_screen.dart';

class ClarityCrewApp extends StatelessWidget {
  const ClarityCrewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final accessibility = context.watch<AccessibilityProvider>();

    return MaterialApp.router(
      title: 'ClarityCrew',
      debugShowCheckedModeBanner: false,
      theme: ClarityTheme.lightTheme(
        textScale: accessibility.textScale,
        contrastLevel: accessibility.contrastLevel,
        reducedMotion: accessibility.reducedMotion,
      ),
      routerConfig: _router,
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const LandingScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/courses',
      builder: (context, state) => const CourseSelectionScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/subjects/:courseId',
      builder: (context, state) => SubjectScreen(
            courseId: state.pathParameters['courseId']!,
          ),
    ),
    GoRoute(
      path: '/lesson/:lessonId',
      builder: (context, state) => LessonScreen(
            lessonId: state.pathParameters['lessonId']!,
          ),
    ),
    GoRoute(
      path: '/ai-assistant',
      builder: (context, state) => const AIAssistantScreen(),
    ),
    GoRoute(
      path: '/progress',
      builder: (context, state) => const ProgressScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) =>
          const AccessibilitySettingsScreen(),
    ),
  ],
);
