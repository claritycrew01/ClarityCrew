class UserProgress {
  final String id;
  final String userId;
  final String courseId;
  final String? subjectId;
  final String? unitId;
  final String? lessonId;
  final String progressType;
  final bool completed;
  final double score;
  final int timeSpentMinutes;
  final int streak;
  final DateTime lastAccessed;
  final DateTime? completedAt;
  final Map<String, dynamic>? metadata;

  UserProgress({
    required this.id,
    required this.userId,
    required this.courseId,
    this.subjectId,
    this.unitId,
    this.lessonId,
    this.progressType = 'lesson',
    this.completed = false,
    this.score = 0.0,
    this.timeSpentMinutes = 0,
    this.streak = 0,
    DateTime? lastAccessed,
    this.completedAt,
    this.metadata,
  }) : lastAccessed = lastAccessed ?? DateTime.now();

  factory UserProgress.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return UserProgress(
      id: docId,
      userId: data['userId'] as String? ?? '',
      courseId: data['courseId'] as String? ?? '',
      subjectId: data['subjectId'] as String?,
      unitId: data['unitId'] as String?,
      lessonId: data['lessonId'] as String?,
      progressType: data['progressType'] as String? ?? 'lesson',
      completed: data['completed'] as bool? ?? false,
      score: (data['score'] as num?)?.toDouble() ?? 0.0,
      timeSpentMinutes: data['timeSpentMinutes'] as int? ?? 0,
      streak: data['streak'] as int? ?? 0,
      lastAccessed: (data['lastAccessed'] as dynamic)?.toDate(),
      completedAt: (data['completedAt'] as dynamic)?.toDate(),
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'courseId': courseId,
      'subjectId': subjectId,
      'unitId': unitId,
      'lessonId': lessonId,
      'progressType': progressType,
      'completed': completed,
      'score': score,
      'timeSpentMinutes': timeSpentMinutes,
      'streak': streak,
      'lastAccessed': lastAccessed,
      'completedAt': completedAt,
      'metadata': metadata,
    };
  }
}

class RecentActivity {
  final String id;
  final String userId;
  final String activityType;
  final String title;
  final String? courseId;
  final String? subjectId;
  final String? lessonId;
  final String? iconUrl;
  final DateTime timestamp;

  RecentActivity({
    required this.id,
    required this.userId,
    required this.activityType,
    required this.title,
    this.courseId,
    this.subjectId,
    this.lessonId,
    this.iconUrl,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory RecentActivity.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return RecentActivity(
      id: docId,
      userId: data['userId'] as String? ?? '',
      activityType: data['activityType'] as String? ?? '',
      title: data['title'] as String? ?? '',
      courseId: data['courseId'] as String?,
      subjectId: data['subjectId'] as String?,
      lessonId: data['lessonId'] as String?,
      iconUrl: data['iconUrl'] as String?,
      timestamp: (data['timestamp'] as dynamic)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'activityType': activityType,
      'title': title,
      'courseId': courseId,
      'subjectId': subjectId,
      'lessonId': lessonId,
      'iconUrl': iconUrl,
      'timestamp': timestamp,
    };
  }
}
