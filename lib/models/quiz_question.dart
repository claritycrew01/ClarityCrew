class QuizQuestion {
  final String id;
  final String lessonId;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String? explanation;
  final String? hint;
  final String difficulty;
  final String type;
  final String? sourceId;
  final int order;

  QuizQuestion({
    required this.id,
    required this.lessonId,
    required this.question,
    required this.options,
    required this.correctIndex,
    this.explanation,
    this.hint,
    this.difficulty = 'medium',
    this.type = 'multiple_choice',
    this.sourceId,
    this.order = 0,
  });

  factory QuizQuestion.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return QuizQuestion(
      id: docId,
      lessonId: data['lessonId'] as String? ?? '',
      question: data['question'] as String? ?? '',
      options: List<String>.from(data['options'] as List? ?? []),
      correctIndex: data['correctIndex'] as int? ?? 0,
      explanation: data['explanation'] as String?,
      hint: data['hint'] as String?,
      difficulty: data['difficulty'] as String? ?? 'medium',
      type: data['type'] as String? ?? 'multiple_choice',
      sourceId: data['sourceId'] as String?,
      order: data['order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'lessonId': lessonId,
      'question': question,
      'options': options,
      'correctIndex': correctIndex,
      'explanation': explanation,
      'hint': hint,
      'difficulty': difficulty,
      'type': type,
      'sourceId': sourceId,
      'order': order,
    };
  }
}

class QuizAttempt {
  final String id;
  final String quizId;
  final String userId;
  final List<int> selectedAnswers;
  final int score;
  final int totalQuestions;
  final int timeSpentSeconds;
  final DateTime completedAt;

  QuizAttempt({
    required this.id,
    required this.quizId,
    required this.userId,
    required this.selectedAnswers,
    required this.score,
    required this.totalQuestions,
    this.timeSpentSeconds = 0,
    DateTime? completedAt,
  }) : completedAt = completedAt ?? DateTime.now();

  double get percentage =>
      totalQuestions > 0 ? score / totalQuestions * 100 : 0;

  factory QuizAttempt.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return QuizAttempt(
      id: docId,
      quizId: data['quizId'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      selectedAnswers:
          List<int>.from(data['selectedAnswers'] as List? ?? []),
      score: data['score'] as int? ?? 0,
      totalQuestions: data['totalQuestions'] as int? ?? 0,
      timeSpentSeconds: data['timeSpentSeconds'] as int? ?? 0,
      completedAt: (data['completedAt'] as dynamic)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'quizId': quizId,
      'userId': userId,
      'selectedAnswers': selectedAnswers,
      'score': score,
      'totalQuestions': totalQuestions,
      'timeSpentSeconds': timeSpentSeconds,
      'completedAt': completedAt,
    };
  }
}
