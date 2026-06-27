import '../../models/learner_profile.dart';
import '../../models/learning_recommendation.dart';
import '../../models/session_record.dart';
import 'content_repository.dart';
import '../../persistence/local_storage_repository.dart';

class RecommendationEngine {
  RecommendationEngine(
    this._contentRepository,
    this._repository,
  );

  final ContentRepository _contentRepository;
  final LocalStorageRepository _repository;

  List<LearningRecommendation> generateRecommendations(
      LearnerProfile profile) {
    final recommendations = <LearningRecommendation>[];
    final sessions = _repository.loadSessions();

    final weakestSubject = _findWeakestSubject(sessions);
    if (weakestSubject != null) {
      recommendations.add(
        LearningRecommendation(
          id: 'rec_focus_${DateTime.now().millisecondsSinceEpoch}',
          learnerId: profile.id,
          recommendedMode: _preferredMode(profile),
          title: 'Revise $weakestSubject',
          description: 'Spend some time strengthening this area.',
          confidence: 0.8,
          reason: 'Low recent comprehension in $weakestSubject',
          estimatedDuration: 600,
          difficulty: 'beginner',
          isUrgent: true,
        ),
      );
    }

    final sessionCount = sessions.length;
    if (sessionCount < 3) {
      recommendations.add(
        LearningRecommendation(
          id: 'rec_new_${DateTime.now().millisecondsSinceEpoch}',
          learnerId: profile.id,
          recommendedMode: LearningMode.microLesson,
          title: 'Getting Started',
          description: 'Complete a few short lessons to build momentum.',
          confidence: 0.9,
          reason: 'New learner',
          estimatedDuration: 180,
          difficulty: 'beginner',
          isUrgent: false,
        ),
      );
    }

    if (sessions.isNotEmpty && profile.engagementHistory.isNotEmpty) {
      final topTopic = profile.engagementHistory.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      recommendations.add(
        LearningRecommendation(
          id: 'rec_deep_${DateTime.now().millisecondsSinceEpoch}',
          learnerId: profile.id,
          recommendedMode: LearningMode.visualSummary,
          title: 'Deep Dive: $topTopic',
          description: 'You have been enjoying this topic. Explore further!',
          confidence: 0.7,
          reason: 'High engagement in $topTopic',
          estimatedDuration: 900,
          difficulty: 'intermediate',
          isUrgent: false,
        ),
      );
    }

    return recommendations;
  }

  String? _findWeakestSubject(List<SessionRecord> sessions) {
    if (sessions.isEmpty) return null;
    final scores = <String, List<double>>{};
    for (final session in sessions) {
      for (final tag in session.topicTags) {
        scores.putIfAbsent(tag, () => []).add(session.comprehensionScore);
      }
    }
    if (scores.isEmpty) return null;
    String? weakest;
    double minAvg = double.infinity;
    for (final entry in scores.entries) {
      final avg =
          entry.value.fold<double>(0, (a, b) => a + b) / entry.value.length;
      if (avg < minAvg) {
        minAvg = avg;
        weakest = entry.key;
      }
    }
    return weakest;
  }

  LearningMode _preferredMode(LearnerProfile profile) {
    if (profile.modeWeights.isEmpty) return LearningMode.microLesson;
    return profile.modeWeights.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
  }
}
