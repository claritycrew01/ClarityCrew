class Unit {
  final String id;
  final String title;
  final String description;
  final String subjectId;
  final String courseId;
  final List<String> lessonIds;
  final int order;
  final String language;
  final DateTime lastUpdated;
  final bool isPublished;

  Unit({
    required this.id,
    required this.title,
    required this.description,
    required this.subjectId,
    required this.courseId,
    this.lessonIds = const [],
    this.order = 0,
    this.language = 'en',
    DateTime? lastUpdated,
    this.isPublished = true,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory Unit.fromFirestore(Map<String, dynamic> data, String docId) {
    return Unit(
      id: docId,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      subjectId: data['subjectId'] as String? ?? '',
      courseId: data['courseId'] as String? ?? '',
      lessonIds: List<String>.from(data['lessonIds'] as List? ?? []),
      order: data['order'] as int? ?? 0,
      language: data['language'] as String? ?? 'en',
      lastUpdated: (data['lastUpdated'] as dynamic)?.toDate(),
      isPublished: data['isPublished'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'subjectId': subjectId,
      'courseId': courseId,
      'lessonIds': lessonIds,
      'order': order,
      'language': language,
      'lastUpdated': lastUpdated,
      'isPublished': isPublished,
    };
  }
}
