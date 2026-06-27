import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'state/app_state.dart';
import 'core/theme/app_theme.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/home/home_screen.dart';
import 'features/ai_tutor/ai_tutor_screen.dart';
import 'features/progress/progress_screen.dart';
import 'features/focus/focus_screen.dart';
import 'features/settings/settings_screen.dart';
import 'features/accessibility_settings/accessibility_settings_screen.dart';
import 'features/video/video_screen.dart';
import 'features/learning_session/learning_session_screen.dart';
import 'services/tutor/study_navigation.dart';

class ClarityCrewApp extends StatelessWidget {
  const ClarityCrewApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();

    return MaterialApp(
      title: 'ClarityCrew',
      debugShowCheckedModeBanner: false,
      navigatorKey: StudyNavigation.navigatorKey,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light,
      home: appState.isLoading
          ? const _SplashScreen()
          : appState.learnerState.isNewUser
              ? const OnboardingScreen()
              : const HomeScreen(),
      routes: {
        '/home': (_) => const HomeScreen(),
        '/onboarding': (_) => const OnboardingScreen(),
        '/ai_tutor': (_) => const AITutorScreen(),
        '/progress': (_) => const ProgressScreen(),
        '/focus': (_) => const FocusScreen(),
        '/settings': (_) => const SettingsScreen(),
        '/accessibility_settings': (_) =>
            const AccessibilitySettingsScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/video') {
          final video = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => VideoScreen(video: video),
          );
        }
        if (settings.name == '/lesson') {
          final lesson = settings.arguments;
          return MaterialPageRoute(
            builder: (_) => LearningSessionScreen(lesson: lesson),
          );
        }
        if (settings.name == '/subject') {
          return MaterialPageRoute(
            builder: (_) => const _SubjectScreen(),
          );
        }
        return null;
      },
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_awesome,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'ClarityCrew',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _SubjectScreen extends StatelessWidget {
  const _SubjectScreen();

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final subjectId = args?['id'] as String? ?? '';
    final appState = context.watch<AppState>();
    final lessons = appState.contentRepository.getLessonsBySubject(subjectId);
    final videos = appState.contentRepository.getVideosBySubject(subjectId);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(args?['name'] as String? ?? 'Subject'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (lessons.isNotEmpty) ...[
            Text('Lessons', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            ...lessons.map(
              (lesson) => Card(
                child: ListTile(
                  leading: const Icon(Icons.menu_book),
                  title: Text(lesson.title),
                  subtitle: Text(
                    '${lesson.difficulty} · ${lesson.estimatedDurationSeconds ~/ 60} min',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/lesson',
                    arguments: lesson,
                  ),
                ),
              ),
            ),
          ],
          if (videos.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text('Videos', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            ...videos.map(
              (video) => Card(
                child: ListTile(
                  leading: const Icon(Icons.play_circle_fill),
                  title: Text(video.title),
                  subtitle: Text(video.duration),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/video',
                    arguments: video,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
