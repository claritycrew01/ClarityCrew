import 'dart:math';
import '../../models/learner_profile.dart';
import '../../models/content_item.dart';
import 'content_repository.dart';

class ContentModeSelector {
  ContentModeSelector(this._contentRepository);

  final ContentRepository _contentRepository;

  String selectOptimalMode(LearnerProfile profile, String subject) {
    final weights = profile.modeWeights;
    if (weights.isEmpty) return 'lesson';
    final total = weights.values.fold<double>(0, (a, b) => a + b);
    if (total <= 0) return 'lesson';
    final random = Random();
    double roll = random.nextDouble() * total;
    for (final entry in weights.entries) {
      roll -= entry.value;
      if (roll <= 0) return entry.key.name;
    }
    return 'lesson';
  }

  List<ContentItem> getContentForMode(
      String mode, String subject, int limit) {
    final lessons = _contentRepository.getLessonsBySubject(subject);
    final filtered = lessons.where((l) {
      if (mode == 'quiz' && l.quizOptions.isEmpty) return false;
      if (mode == 'flashcard' && l.flashcards.isEmpty) {
        return false;
      }
      return true;
    }).toList();
    filtered.shuffle();
    return filtered.take(limit).toList();
  }

  double getModeConfidence(String mode, LearnerProfile profile) {
    return profile.modeWeights.entries
        .where((e) => e.key.name == mode)
        .fold<double>(0.0, (sum, e) => sum + e.value);
  }
}
