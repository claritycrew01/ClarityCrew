import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'persistence/shared_preferences_adapter.dart';
import 'persistence/local_storage_repository.dart';
import 'persistence/tutor_storage.dart';
import 'persistence/video_progress_storage.dart';
import 'services/content/content_repository.dart';
import 'services/content/content_mode_selector.dart';
import 'services/content/session_analyzer.dart';
import 'services/content/recommendation_engine.dart';
import 'services/adaptive_ai_engine.dart';
import 'services/tutor/tutor_service.dart';
import 'services/tutor/focus_support_service.dart';
import 'state/learner_state.dart';
import 'state/session_state.dart';
import 'state/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final adapter = SharedPreferencesAdapter(prefs);
  final repository = LocalStorageRepository(adapter);
  final tutorStorage = TutorStorage(adapter);
  final videoProgressStorage = VideoProgressStorage(adapter);
  final contentRepository = ContentRepository();
  final sessionAnalyzer = SessionAnalyzer();
  final recommendationEngine = RecommendationEngine(contentRepository, repository);
  final adaptiveAIEngine = AdaptiveAIEngine(repository, sessionAnalyzer, recommendationEngine);
  final contentModeSelector = ContentModeSelector(contentRepository);
  final tutorService = TutorService(tutorStorage);
  final focusSupportService = FocusSupportService();

  final learnerState = LearnerState(repository);
  final sessionState = SessionState(repository, sessionAnalyzer);

  final appState = AppState(
    learnerState: learnerState,
    sessionState: sessionState,
    contentRepository: contentRepository,
    adaptiveAIEngine: adaptiveAIEngine,
    tutorService: tutorService,
    focusSupportService: focusSupportService,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appState),
        ChangeNotifierProvider.value(value: learnerState),
        ChangeNotifierProvider.value(value: sessionState),
        Provider.value(value: contentRepository),
        Provider.value(value: contentModeSelector),
        Provider.value(value: adaptiveAIEngine),
        Provider.value(value: recommendationEngine),
        Provider.value(value: tutorService),
        Provider.value(value: focusSupportService),
        Provider.value(value: videoProgressStorage),
        Provider.value(value: repository),
      ],
      child: const ClarityCrewApp(),
    ),
  );

  await appState.initialize();
}
