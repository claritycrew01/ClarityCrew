class Course {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final String? iconUrl;
  final String? colorHex;
  final List<String> subjectIds;
  final int order;
  final String language;
  final DateTime lastUpdated;
  final bool isPublished;
  final Map<String, dynamic>? metadata;

  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    this.difficulty = 'beginner',
    this.iconUrl,
    this.colorHex,
    this.subjectIds = const [],
    this.order = 0,
    this.language = 'en',
    DateTime? lastUpdated,
    this.isPublished = true,
    this.metadata,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory Course.fromFirestore(Map<String, dynamic> data, String docId) {
    return Course(
      id: docId,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      category: data['category'] as String? ?? 'general',
      difficulty: data['difficulty'] as String? ?? 'beginner',
      iconUrl: data['iconUrl'] as String?,
      colorHex: data['colorHex'] as String?,
      subjectIds: List<String>.from(data['subjectIds'] as List? ?? []),
      order: data['order'] as int? ?? 0,
      language: data['language'] as String? ?? 'en',
      lastUpdated: (data['lastUpdated'] as dynamic)?.toDate(),
      isPublished: data['isPublished'] as bool? ?? true,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'difficulty': difficulty,
      'iconUrl': iconUrl,
      'colorHex': colorHex,
      'subjectIds': subjectIds,
      'order': order,
      'language': language,
      'lastUpdated': lastUpdated,
      'isPublished': isPublished,
      'metadata': metadata,
    };
  }
}
