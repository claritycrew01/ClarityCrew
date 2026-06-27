import 'package:flutter/foundation.dart';
import '../models/session_record.dart';
import '../models/interaction_event.dart';
import '../persistence/local_storage_repository.dart';
import '../services/content/session_analyzer.dart';

class SessionState extends ChangeNotifier {
  SessionState(this._repository, this._analyzer);

  final LocalStorageRepository _repository;
  final SessionAnalyzer _analyzer;

  List<SessionRecord> _sessions = [];
  SessionRecord? _currentSession;
  List<InteractionEvent> _pendingInteractions = [];

  List<SessionRecord> get sessions => _sessions;
  SessionRecord? get currentSession => _currentSession;
  List<InteractionEvent> get pendingInteractions => _pendingInteractions;

  Future<void> loadSessions() async {
    _sessions = _repository.loadSessions();
    notifyListeners();
  }

  void startSession(String sessionType, List<String> topicTags) {
    _currentSession = SessionRecord(
      id: 'session_${DateTime.now().millisecondsSinceEpoch}',
      learnerId: 'user',
      startTime: DateTime.now(),
      sessionType: sessionType,
      topicTags: topicTags,
    );
    _pendingInteractions = [];
    notifyListeners();
  }

  void recordInteraction(InteractionEvent event) {
    _pendingInteractions.add(event);
    notifyListeners();
  }

  Future<void> endSession({bool completed = true}) async {
    if (_currentSession == null) return;

    final engagement = _analyzer.calculateEngagementScore(_pendingInteractions);
    final comprehension =
        _analyzer.calculateComprehensionScore(_pendingInteractions);
    final duration = DateTime.now().difference(_currentSession!.startTime);

    final finished = _currentSession!.copyWith(
      endTime: DateTime.now(),
      durationSeconds: duration.inSeconds,
      interactions: _pendingInteractions,
      engagementScore: engagement,
      comprehensionScore: comprehension,
      completed: completed,
    );

    _sessions.add(finished);
    await _repository.saveSession(finished);
    await _repository.saveInteractions(_pendingInteractions);

    _currentSession = null;
    _pendingInteractions = [];
    notifyListeners();
  }

  List<SessionRecord> getSessionsBySubject(String subject) {
    return _sessions.where((s) => s.topicTags.contains(subject)).toList();
  }
}
