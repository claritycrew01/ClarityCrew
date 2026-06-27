import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/recommendation.dart';
import '../models/user_progress.dart';
import '../utils/constants.dart';

class RecommendationService {
  FirebaseFirestore? _firestore;

  RecommendationService() {
    try {
      _firestore = FirebaseFirestore.instance;
    } catch (_) {}
  }

  Future<List<Recommendation>> getUserRecommendations(
      String userId,
      {int limit = 5}) async {
    if (_firestore == null) return [];
    final snapshot = await _firestore!
        .collection(AppConstants.collectionRecommendations)
        .where('userId', isEqualTo: userId)
        .where('seen', isEqualTo: false)
        .orderBy('relevanceScore', descending: true)
        .limit(limit)
        .get();
    return snapshot.docs
        .map((doc) => Recommendation.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> markRecommendationSeen(String recommendationId) async {
    if (_firestore == null) return;
    await _firestore!
        .collection(AppConstants.collectionRecommendations)
        .doc(recommendationId)
        .update({'seen': true});
  }

  Future<void> generateRecommendations(
      String userId, List<UserProgress> progress) async {
    if (_firestore == null) return;
    final completedLessons = progress.where((p) => p.completed).toList();
    if (completedLessons.isEmpty) return;

    completedLessons.sort(
        (a, b) => b.completedAt!.compareTo(a.completedAt!));
    final lastProgress = completedLessons.first;

    if (lastProgress.score < 50 && lastProgress.lessonId != null) {
      await _createRecommendation(
        userId: userId,
        type: 'lesson',
        id: lastProgress.lessonId!,
        title: 'Review lesson',
        description: 'You might benefit from revisiting this lesson.',
        reason: 'Score below 50%',
        relevanceScore: 0.9,
      );
    }
  }

  Future<void> _createRecommendation({
    required String userId,
    required String type,
    required String id,
    required String title,
    required String description,
    required String reason,
    required double relevanceScore,
    String? courseId,
    String? subjectId,
  }) async {
    if (_firestore == null) return;
    final recId = '${userId}_${type}_${id}_${DateTime.now().millisecondsSinceEpoch}';
    final recommendation = Recommendation(
      id: recId,
      userId: userId,
      recommendedType: type,
      recommendedId: id,
      title: title,
      description: description,
      reason: reason,
      relevanceScore: relevanceScore,
      courseId: courseId,
      subjectId: subjectId,
    );
    await _firestore!
        .collection(AppConstants.collectionRecommendations)
        .doc(recId)
        .set(recommendation.toFirestore());
  }
}
