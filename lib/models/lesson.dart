import 'resource.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final String unitId;
  final String subjectId;
  final String courseId;
  final String overview;
  final String notes;
  final String revisionSummary;
  final List<Resource> resources;
  final List<String> quizIds;
  final List<String> exerciseIds;
  final List<String> prerequisiteLessonIds;
  final int estimatedMinutes;
  final int order;
  final String difficulty;
  final String language;
  final DateTime lastUpdated;
  final bool isPublished;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.unitId,
    required this.subjectId,
    required this.courseId,
    this.overview = '',
    this.notes = '',
    this.revisionSummary = '',
    this.resources = const [],
    this.quizIds = const [],
    this.exerciseIds = const [],
    this.prerequisiteLessonIds = const [],
    this.estimatedMinutes = 15,
    this.order = 0,
    this.difficulty = 'beginner',
    this.language = 'en',
    DateTime? lastUpdated,
    this.isPublished = true,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory Lesson.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return Lesson(
      id: docId,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      unitId: data['unitId'] as String? ?? '',
      subjectId: data['subjectId'] as String? ?? '',
      courseId: data['courseId'] as String? ?? '',
      overview: data['overview'] as String? ?? '',
      notes: data['notes'] as String? ?? '',
      revisionSummary: data['revisionSummary'] as String? ?? '',
      resources: (data['resources'] as List?)
              ?.map((r) => Resource.fromMap(r as Map<String, dynamic>))
              .toList() ??
          [],
      quizIds: List<String>.from(data['quizIds'] as List? ?? []),
      exerciseIds:
          List<String>.from(data['exerciseIds'] as List? ?? []),
      prerequisiteLessonIds: List<String>.from(
          data['prerequisiteLessonIds'] as List? ?? []),
      estimatedMinutes: data['estimatedMinutes'] as int? ?? 15,
      order: data['order'] as int? ?? 0,
      difficulty: data['difficulty'] as String? ?? 'beginner',
      language: data['language'] as String? ?? 'en',
      lastUpdated: (data['lastUpdated'] as dynamic)?.toDate(),
      isPublished: data['isPublished'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'unitId': unitId,
      'subjectId': subjectId,
      'courseId': courseId,
      'overview': overview,
      'notes': notes,
      'revisionSummary': revisionSummary,
      'resources': resources.map((r) => r.toMap()).toList(),
      'quizIds': quizIds,
      'exerciseIds': exerciseIds,
      'prerequisiteLessonIds': prerequisiteLessonIds,
      'estimatedMinutes': estimatedMinutes,
      'order': order,
      'difficulty': difficulty,
      'language': language,
      'lastUpdated': lastUpdated,
      'isPublished': isPublished,
    };
  }
}
