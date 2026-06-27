import 'dart:convert';
import '../models/learner_profile.dart';
import '../models/session_record.dart';
import '../models/interaction_event.dart';
import '../models/learning_recommendation.dart';
import 'shared_preferences_adapter.dart';

class LocalStorageRepository {
  LocalStorageRepository(this._adapter);

  final SharedPreferencesAdapter _adapter;

  Future<void> saveProfile(LearnerProfile profile) async {
    await _adapter.setString('profile', profile.toJsonString());
  }

  LearnerProfile? loadProfile() {
    final json = _adapter.getString('profile');
    if (json == null) return null;
    return LearnerProfile.fromJsonString(json);
  }

  Future<void> saveSession(SessionRecord session) async {
    final sessions = loadSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }
    await _saveSessionList(sessions);
  }

  Future<void> _saveSessionList(List<SessionRecord> sessions) async {
    final json = jsonEncode(sessions.map((s) => s.toJson()).toList());
    await _adapter.setString('sessions', json);
  }

  List<SessionRecord> loadSessions() {
    final json = _adapter.getString('sessions');
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => SessionRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> ensureProfile(LearnerProfile profile) async {
    final existing = loadProfile();
    if (existing == null) {
      await saveProfile(profile);
    }
  }

  Future<void> saveInteractions(List<InteractionEvent> events) async {
    final json = jsonEncode(events.map((e) => e.toJson()).toList());
    await _adapter.setString('interactions_cache', json);
  }

  List<InteractionEvent> loadInteractions() {
    final json = _adapter.getString('interactions_cache');
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => InteractionEvent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveRecommendations(
      List<LearningRecommendation> recommendations) async {
    final json =
        jsonEncode(recommendations.map((r) => r.toJson()).toList());
    await _adapter.setString('recommendations', json);
  }

  List<LearningRecommendation> loadRecommendations() {
    final json = _adapter.getString('recommendations');
    if (json == null) return [];
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map(
            (e) => LearningRecommendation.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> clearAll() async {
    final keys = [
      'profile',
      'sessions',
      'interactions_cache',
      'recommendations',
      'tutor_conversation',
      'video_progress',
    ];
    for (final key in keys) {
      await _adapter.remove(key);
    }
  }
}
