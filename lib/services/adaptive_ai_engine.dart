import '../models/learner_profile.dart';
import '../models/session_record.dart';
import '../models/interaction_event.dart';
import '../models/learning_recommendation.dart';
import '../persistence/local_storage_repository.dart';
import 'content/session_analyzer.dart';
import 'content/recommendation_engine.dart';

class AdaptiveAIEngine {
  AdaptiveAIEngine(
    this._repository,
    this._analyzer,
    this._recommendationEngine,
  );

  final LocalStorageRepository _repository;
  final SessionAnalyzer _analyzer;
  final RecommendationEngine _recommendationEngine;

  LearnerProfile updateProfileFromSession(SessionRecord session) {
    final profile = _repository.loadProfile();
    if (profile == null) return _defaultProfile();

    final engagement = _analyzer.calculateEngagementScore(session.interactions);
    final comprehension =
        _analyzer.calculateComprehensionScore(session.interactions);

    final updatedHistory =
        Map<String, double>.from(profile.engagementHistory);
    for (final tag in session.topicTags) {
      updatedHistory[tag] =
          (updatedHistory[tag] ?? 0.0) + engagement * 0.1;
    }

    final updatedModeWeights =
        Map<LearningMode, double>.from(profile.modeWeights);
    final mode = _inferMode(session.interactions);
    updatedModeWeights[mode] =
        (updatedModeWeights[mode] ?? 0.5) + comprehension * 0.1;

    final updated = profile.copyWith(
      engagementHistory: updatedHistory,
      modeWeights: updatedModeWeights,
      depthPreference:
          (profile.depthPreference + comprehension * 0.1).clamp(0, 1),
      focusThreshold:
          (profile.focusThreshold + engagement * 0.05).clamp(0, 1),
      lastUpdated: DateTime.now(),
    );

    _repository.saveProfile(updated);
    return updated;
  }

  LearningMode _inferMode(List<InteractionEvent> interactions) {
    final modeCounts = <String, int>{};
    for (final event in interactions) {
      final type = event.interactionType;
      modeCounts[type] = (modeCounts[type] ?? 0) + 1;
    }
    if (modeCounts.isEmpty) return LearningMode.microLesson;
    final best = modeCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    switch (best) {
      case 'completed':
        return LearningMode.quiz;
      case 'struggled':
        return LearningMode.guidedPractice;
      default:
        return LearningMode.microLesson;
    }
  }

  LearnerProfile _defaultProfile() {
    final profile = LearnerProfile(
      id: 'default_user',
      name: 'Learner',
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
    _repository.saveProfile(profile);
    return profile;
  }

  List<LearningRecommendation> getRecommendations(LearnerProfile profile) {
    return _recommendationEngine.generateRecommendations(profile);
  }
}
