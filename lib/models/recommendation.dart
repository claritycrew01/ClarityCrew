class Recommendation {
  final String id;
  final String userId;
  final String recommendedType;
  final String recommendedId;
  final String title;
  final String description;
  final String reason;
  final double relevanceScore;
  final bool seen;
  final DateTime createdAt;
  final String? courseId;
  final String? subjectId;

  Recommendation({
    required this.id,
    required this.userId,
    required this.recommendedType,
    required this.recommendedId,
    required this.title,
    required this.description,
    required this.reason,
    this.relevanceScore = 0.5,
    this.seen = false,
    DateTime? createdAt,
    this.courseId,
    this.subjectId,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Recommendation.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return Recommendation(
      id: docId,
      userId: data['userId'] as String? ?? '',
      recommendedType: data['recommendedType'] as String? ?? '',
      recommendedId: data['recommendedId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      reason: data['reason'] as String? ?? '',
      relevanceScore:
          (data['relevanceScore'] as num?)?.toDouble() ?? 0.5,
      seen: data['seen'] as bool? ?? false,
      createdAt: (data['createdAt'] as dynamic)?.toDate(),
      courseId: data['courseId'] as String?,
      subjectId: data['subjectId'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'recommendedType': recommendedType,
      'recommendedId': recommendedId,
      'title': title,
      'description': description,
      'reason': reason,
      'relevanceScore': relevanceScore,
      'seen': seen,
      'createdAt': createdAt,
      'courseId': courseId,
      'subjectId': subjectId,
    };
  }
}
