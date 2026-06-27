class Exercise {
  final String id;
  final String lessonId;
  final String title;
  final String description;
  final String instructions;
  final String solution;
  final String? starterCode;
  final String type;
  final String difficulty;
  final List<String> hints;
  final String? sourceId;
  final int order;
  final DateTime lastUpdated;
  final bool isPublished;

  Exercise({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.description,
    required this.instructions,
    this.solution = '',
    this.starterCode,
    this.type = 'practice',
    this.difficulty = 'medium',
    this.hints = const [],
    this.sourceId,
    this.order = 0,
    DateTime? lastUpdated,
    this.isPublished = true,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory Exercise.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return Exercise(
      id: docId,
      lessonId: data['lessonId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      instructions: data['instructions'] as String? ?? '',
      solution: data['solution'] as String? ?? '',
      starterCode: data['starterCode'] as String?,
      type: data['type'] as String? ?? 'practice',
      difficulty: data['difficulty'] as String? ?? 'medium',
      hints: List<String>.from(data['hints'] as List? ?? []),
      sourceId: data['sourceId'] as String?,
      order: data['order'] as int? ?? 0,
      lastUpdated: (data['lastUpdated'] as dynamic)?.toDate(),
      isPublished: data['isPublished'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'lessonId': lessonId,
      'title': title,
      'description': description,
      'instructions': instructions,
      'solution': solution,
      'starterCode': starterCode,
      'type': type,
      'difficulty': difficulty,
      'hints': hints,
      'sourceId': sourceId,
      'order': order,
      'lastUpdated': lastUpdated,
      'isPublished': isPublished,
    };
  }
}
