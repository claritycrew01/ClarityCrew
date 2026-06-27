import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/auth_provider.dart';
import 'providers/course_provider.dart';
import 'providers/lesson_provider.dart';
import 'providers/progress_provider.dart';
import 'providers/accessibility_provider.dart';
import 'providers/ai_provider.dart';
import 'services/firebase_service.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await FirebaseService().initialize().timeout(
      const Duration(seconds: 5),
    );
  } catch (e) {
    // Firebase init timed out or failed; app runs in offline/mock mode
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CourseProvider()),
        ChangeNotifierProvider(create: (_) => LessonProvider()),
        ChangeNotifierProvider(create: (_) => ProgressProvider()),
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
        ChangeNotifierProvider(create: (_) => AIProvider()),
      ],
      child: const ClarityCrewApp(),
    ),
  );
}
