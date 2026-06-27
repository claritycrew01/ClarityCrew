import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_progress.dart';
import '../utils/constants.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveProgress(UserProgress progress) async {
    await _firestore
        .collection(AppConstants.collectionProgress)
        .doc(progress.id)
        .set(progress.toFirestore());
  }

  Future<UserProgress?> getProgress(String progressId) async {
    final doc = await _firestore
        .collection(AppConstants.collectionProgress)
        .doc(progressId)
        .get();
    if (!doc.exists) return null;
    return UserProgress.fromFirestore(doc.data()! as Map<String, dynamic>, doc.id);
  }

  Future<List<UserProgress>> getUserCourseProgress(
      String userId, String courseId) async {
    final snapshot = await _firestore
        .collection(AppConstants.collectionProgress)
        .where('userId', isEqualTo: userId)
        .where('courseId', isEqualTo: courseId)
        .orderBy('lastAccessed', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => UserProgress.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<double> getCourseCompletion(
      String userId, String courseId) async {
    final snapshot = await _firestore
        .collection(AppConstants.collectionProgress)
        .where('userId', isEqualTo: userId)
        .where('courseId', isEqualTo: courseId)
        .where('completed', isEqualTo: true)
        .get();
    return snapshot.docs.length.toDouble();
  }

  Future<int> getUserStreak(String userId) async {
    final snapshot = await _firestore
        .collection(AppConstants.collectionProgress)
        .where('userId', isEqualTo: userId)
        .orderBy('lastAccessed', descending: true)
        .limit(30)
        .get();

    if (snapshot.docs.isEmpty) return 0;

    final streaks = snapshot.docs
        .map((doc) => UserProgress.fromFirestore(doc.data() as Map<String, dynamic>, doc.id).streak)
        .toList();
    return streaks.isNotEmpty ? streaks.first : 0;
  }

  Future<List<RecentActivity>> getRecentActivity(
      String userId, {int limit = 10}) async {
    final snapshot = await _firestore
        .collection(AppConstants.collectionActivity)
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs
        .map((doc) => RecentActivity.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> logActivity(RecentActivity activity) async {
    await _firestore
        .collection(AppConstants.collectionActivity)
        .doc(activity.id)
        .set(activity.toFirestore());
  }

  Future<void> recordLessonCompletion(
      String userId, String lessonId, String courseId,
      {String? subjectId, String? unitId, int timeSpent = 0}) async {
    final progressId = '${userId}_${lessonId}';
    final progress = UserProgress(
      id: progressId,
      userId: userId,
      courseId: courseId,
      subjectId: subjectId,
      unitId: unitId,
      lessonId: lessonId,
      progressType: 'lesson',
      completed: true,
      timeSpentMinutes: timeSpent,
      completedAt: DateTime.now(),
    );
    await saveProgress(progress);

    await logActivity(RecentActivity(
      id: '${progressId}_${DateTime.now().millisecondsSinceEpoch}',
      userId: userId,
      activityType: 'lesson_completed',
      title: 'Completed lesson',
      courseId: courseId,
      subjectId: subjectId,
      lessonId: lessonId,
    ));
  }
}
