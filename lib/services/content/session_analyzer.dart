import '../../models/session_record.dart';
import '../../models/interaction_event.dart';

class SessionAnalyzer {
  double calculateEngagementScore(List<InteractionEvent> interactions) {
    if (interactions.isEmpty) return 0.0;
    double score = 0;
    for (final event in interactions) {
      if (event.interactionType == 'completed') score += 1.0;
      if (event.interactionType == 'struggled') score -= 0.3;
      if (event.interactionType == 'replayed') score += 0.5;
      if (event.interactionType == 'lingered') score += 0.2;
      if (event.interactionType == 'timedOut') score -= 0.5;
      if (event.interactionType == 'gaveFeedback') score += 0.4;
      if (event.interactionType == 'requestedDeeper') score += 0.6;
    }
    return (score / interactions.length).clamp(0, 1);
  }

  double calculateComprehensionScore(List<InteractionEvent> interactions) {
    if (interactions.isEmpty) return 0.0;
    int correct = 0;
    int total = 0;
    for (final event in interactions) {
      if (event.interactionType == 'completed' && event.score != null) {
        total++;
        if (event.score! >= 70) correct++;
      }
    }
    return total > 0 ? correct / total : 0.0;
  }

  List<String> extractTopicTags(SessionRecord session) {
    final tags = <String>{};
    for (final interaction in session.interactions) {
      if (interaction.metadata.containsKey('tags')) {
        final rawTags = interaction.metadata['tags'] as List<dynamic>;
        tags.addAll(rawTags.cast<String>());
      }
    }
    tags.addAll(session.topicTags);
    return tags.toList();
  }
}
