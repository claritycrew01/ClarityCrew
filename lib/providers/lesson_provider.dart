import 'package:flutter/material.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/exercise.dart';
import '../services/content_service.dart';

class LessonProvider extends ChangeNotifier {
  final ContentService _contentService = ContentService();

  Lesson? _currentLesson;
  List<QuizQuestion> _quizQuestions = [];
  List<Exercise> _exercises = [];
  String _activeSection = 'overview';
  bool _isLoading = false;
  String? _error;

  Lesson? get currentLesson => _currentLesson;
  List<QuizQuestion> get quizQuestions => _quizQuestions;
  List<Exercise> get exercises => _exercises;
  String get activeSection => _activeSection;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadLesson(String lessonId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentLesson = await _contentService.getLesson(lessonId);
    } catch (e) {
      _error = 'Unable to load lesson content.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadQuizQuestions(String quizId) async {
    try {
      _quizQuestions = await _contentService.getQuizQuestions(quizId);
      notifyListeners();
    } catch (e) {
      _error = 'Unable to load quiz questions.';
      notifyListeners();
    }
  }

  Future<void> loadExercises(String lessonId) async {
    try {
      _exercises = await _contentService.getExercises(lessonId);
      notifyListeners();
    } catch (e) {
      _error = 'Unable to load exercises.';
      notifyListeners();
    }
  }

  void setActiveSection(String section) {
    _activeSection = section;
    notifyListeners();
  }

  void clear() {
    _currentLesson = null;
    _quizQuestions = [];
    _exercises = [];
    _activeSection = 'overview';
    _error = null;
    notifyListeners();
  }
}
