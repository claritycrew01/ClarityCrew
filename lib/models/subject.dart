class Subject {
  final String id;
  final String title;
  final String description;
  final String courseId;
  final String? iconUrl;
  final String? colorHex;
  final List<String> unitIds;
  final int order;
  final String language;
  final DateTime lastUpdated;
  final bool isPublished;

  Subject({
    required this.id,
    required this.title,
    required this.description,
    required this.courseId,
    this.iconUrl,
    this.colorHex,
    this.unitIds = const [],
    this.order = 0,
    this.language = 'en',
    DateTime? lastUpdated,
    this.isPublished = true,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  factory Subject.fromFirestore(Map<String, dynamic> data, String docId) {
    return Subject(
      id: docId,
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      courseId: data['courseId'] as String? ?? '',
      iconUrl: data['iconUrl'] as String?,
      colorHex: data['colorHex'] as String?,
      unitIds: List<String>.from(data['unitIds'] as List? ?? []),
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
      'courseId': courseId,
      'iconUrl': iconUrl,
      'colorHex': colorHex,
      'unitIds': unitIds,
      'order': order,
      'language': language,
      'lastUpdated': lastUpdated,
      'isPublished': isPublished,
    };
  }
}
