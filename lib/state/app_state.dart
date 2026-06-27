import 'package:flutter/material.dart';
import 'learner_state.dart';
import 'session_state.dart';
import '../services/content/content_repository.dart';
import '../services/adaptive_ai_engine.dart';
import '../services/tutor/tutor_service.dart';
import '../services/tutor/focus_support_service.dart';

class AppState extends ChangeNotifier {
  AppState({
    required this.learnerState,
    required this.sessionState,
    required this.contentRepository,
    required this.adaptiveAIEngine,
    required this.tutorService,
    required this.focusSupportService,
  });

  final LearnerState learnerState;
  final SessionState sessionState;
  final ContentRepository contentRepository;
  final AdaptiveAIEngine adaptiveAIEngine;
  final TutorService tutorService;
  final FocusSupportService focusSupportService;

  bool _isLoading = true;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await contentRepository.loadAll();
      await learnerState.loadProfile();
      await sessionState.loadSessions();
      await tutorService.loadConversation();
      _isLoading = false;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }
}
