import 'dart:math';
import '../models/learner_profile.dart';
import '../models/learning_recommendation.dart';
import '../models/tutor_message.dart';

class TutorService {
  final Random _random = Random();

  TutorMessage respond({
    required String userMessage,
    required LearnerProfile profile,
    String? contentId,
    LearningRecommendation? activeRecommendation,
  }) {
    final text = _generateResponse(userMessage, profile, activeRecommendation);

    return TutorMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'tutor',
      text: text,
      contentId: contentId,
      timestamp: DateTime.now(),
    );
  }

  String _generateResponse(
    String userInput,
    LearnerProfile profile,
    LearningRecommendation? activeRecommendation,
  ) {
    final lower = userInput.toLowerCase();

    if (lower.contains('recommend') ||
        lower.contains('what should') ||
        lower.contains('what to study') ||
        lower.contains('next')) {
      if (activeRecommendation != null) {
        return _recommendationResponse(activeRecommendation, profile);
      }
      return _pickRandom([
        'Based on your history, I think a short lesson would be a great start. How about we try something new?',
        'Let us pick a topic you have not explored yet. What sounds interesting right now?',
        'I have a few ideas! Would you prefer a quiz to test your knowledge or a video to learn something new?',
      ]);
    }

    if (lower.contains('simplif') ||
        lower.contains('easier') ||
        lower.contains('too hard')) {
      return _pickRandom([
        'Of course! Let me break this down into smaller pieces. What part is most challenging?',
        'No problem! Would you like me to explain it differently? Sometimes a visual approach helps.',
        'Let us try a simpler version. Tell me what you do understand and we will build from there.',
      ]);
    }

    if (lower.contains('deeper') ||
        lower.contains('more detail') ||
        lower.contains('advanced') ||
        lower.contains('tell me more')) {
      return _pickRandom([
        'Great curiosity! Here is a deeper look... This concept connects to several advanced topics. Which direction interests you most?',
        'I love that you want to go deeper! Let me share some additional context that builds on what you already know.',
        'Going deeper is a great way to solidify understanding. Here are some advanced aspects to consider.',
      ]);
    }

    if (lower.contains('hello') ||
        lower.contains('hi') ||
        lower.contains('hey') ||
        lower.contains('start')) {
      final name = profile.name.isNotEmpty ? ', ${profile.name}' : '';
      return _pickRandom([
        'Hello$name! Ready to learn something new today? I have been tracking your progress and have some suggestions.',
        'Hi there$name! I am your AI tutor. Ask me to explain something, recommend content, or guide your study session.',
        'Hey$name! Great to see you. What would you like to explore today?',
      ]);
    }

    if (lower.contains('how are you') ||
        lower.contains('what can you') ||
        lower.contains('help me')) {
      return _pickRandom([
        'I am here to help! I can explain concepts, recommend lessons, create quizzes, guide focus sessions, or just chat about what you are learning.',
        'I can help you learn in the way that works best for you. Ask me to explain a topic, suggest what to study next, or simplify something tricky.',
      ]);
    }

    if (lower.contains('thanks') || lower.contains('thank')) {
      return _pickRandom([
        'You are welcome! Keep up the great work.',
        'Happy to help! Let me know if you need anything else.',
        'My pleasure! Learning is a journey, and I am here for every step.',
      ]);
    }

    return _pickRandom([
      'That is interesting! Would you like me to recommend some related content or explain a specific topic?',
      'I see what you mean. Can I help you explore this further or suggest a learning activity?',
      'Tell me more! I can adapt my responses to how you learn best.',
    ]);
  }

  String _recommendationResponse(
      LearningRecommendation rec, LearnerProfile profile) {
    return 'I recommend: ${rec.title}. ${rec.description} '
        'It is a ${rec.difficulty}-level activity that should take about ${rec.estimatedDuration ~/ 60} minutes. '
        '${rec.reason.isEmpty ? "" : rec.reason} '
        'Shall I start this for you?';
  }

  String _pickRandom(List<String> options) {
    return options[_random.nextInt(options.length)];
  }
}
