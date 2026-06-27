import 'package:flutter/material.dart';
import '../models/user_progress.dart';
import '../models/recommendation.dart';
import '../services/progress_service.dart';
import '../services/recommendation_service.dart';

class ProgressProvider extends ChangeNotifier {
  final ProgressService _progressService = ProgressService();
  final RecommendationService _recommendationService = RecommendationService();

  List<UserProgress> _progressList = [];
  List<RecentActivity> _recentActivity = [];
  List<Recommendation> _recommendations = [];
  int _streak = 0;
  bool _isLoading = false;

  List<UserProgress> get progressList => _progressList;
  List<RecentActivity> get recentActivity => _recentActivity;
  List<Recommendation> get recommendations => _recommendations;
  int get streak => _streak;
  bool get isLoading => _isLoading;

  Future<void> loadProgress(String userId, String courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _progressList =
          await _progressService.getUserCourseProgress(userId, courseId);
      _recentActivity = await _progressService.getRecentActivity(userId);
      _streak = await _progressService.getUserStreak(userId);
      _recommendations =
          await _recommendationService.getUserRecommendations(userId);
    } catch (e) {
      _progressList = [];
      _recentActivity = [];
      _recommendations = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> recordLessonCompletion(
    String userId,
    String lessonId,
    String courseId, {
    String? subjectId,
    String? unitId,
    int timeSpent = 0,
  }) async {
    await _progressService.recordLessonCompletion(
      userId,
      lessonId,
      courseId,
      subjectId: subjectId,
      unitId: unitId,
      timeSpent: timeSpent,
    );
    await loadProgress(userId, courseId);
  }

  double getCourseProgress(String courseId) {
    final courseProgress =
        _progressList.where((p) => p.courseId == courseId).toList();
    if (courseProgress.isEmpty) return 0;
    final completed =
        courseProgress.where((p) => p.completed).length;
    return completed / courseProgress.length;
  }

  int getCompletedLessons() {
    return _progressList.where((p) => p.completed).length;
  }

  double getAverageScore() {
    final scored =
        _progressList.where((p) => p.score > 0).toList();
    if (scored.isEmpty) return 0;
    return scored.fold(0.0, (sum, p) => sum + p.score) / scored.length;
  }
}
