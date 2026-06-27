import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/subject.dart';
import '../models/unit.dart';
import '../models/lesson.dart';
import '../services/content_service.dart';

class CourseProvider extends ChangeNotifier {
  final ContentService _contentService = ContentService();

  List<Course> _courses = [];
  List<Subject> _subjects = [];
  List<Unit> _units = [];
  List<Lesson> _lessons = [];
  Course? _selectedCourse;
  Subject? _selectedSubject;
  Unit? _selectedUnit;
  Lesson? _selectedLesson;
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = '';

  List<Course> get courses => _courses;
  List<Subject> get subjects => _subjects;
  List<Unit> get units => _units;
  List<Lesson> get lessons => _lessons;
  Course? get selectedCourse => _selectedCourse;
  Subject? get selectedSubject => _selectedSubject;
  Unit? get selectedUnit => _selectedUnit;
  Lesson? get selectedLesson => _selectedLesson;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  Future<void> loadCourses({String? category}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _courses = await _contentService.getCourses(category: category);
      _selectedCategory = category ?? '';
    } catch (e) {
      _error = 'Unable to load courses. Please check your connection.';
      _courses = _getPlaceholderCourses(category);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectCourse(String courseId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedCourse = await _contentService.getCourse(courseId);
      if (_selectedCourse != null) {
        _subjects = await _contentService.getSubjects(courseId);
      }
    } catch (e) {
      _error = 'Unable to load course details.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectSubject(String subjectId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedSubject = await _contentService.getSubject(subjectId);
      if (_selectedSubject != null) {
        _units = await _contentService.getUnits(subjectId);
      }
    } catch (e) {
      _error = 'Unable to load subject details.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectUnit(String unitId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedUnit = await _contentService.getUnit(unitId);
      if (_selectedUnit != null) {
        _lessons = await _contentService.getLessons(unitId);
      }
    } catch (e) {
      _error = 'Unable to load unit details.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> selectLesson(String lessonId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedLesson = await _contentService.getLesson(lessonId);
    } catch (e) {
      _error = 'Unable to load lesson.';
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearSelection() {
    _selectedCourse = null;
    _selectedSubject = null;
    _selectedUnit = null;
    _selectedLesson = null;
    _subjects = [];
    _units = [];
    _lessons = [];
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    loadCourses(category: category);
  }

  List<Course> _getPlaceholderCourses(String? category) {
    return [
      Course(
        id: 'cbse_demo',
        title: 'CBSE Curriculum',
        description: 'Complete CBSE curriculum from Class 6 to 12 with interactive lessons and practice.',
        category: 'cbse',
        difficulty: 'beginner',
        colorHex: '#4F6DB4',
        order: 1,
      ),
      Course(
        id: 'icse_demo',
        title: 'ICSE Curriculum',
        description: 'Comprehensive ICSE curriculum with step-by-step learning paths.',
        category: 'icse',
        difficulty: 'beginner',
        colorHex: '#6BBF8A',
        order: 2,
      ),
      Course(
        id: 'competitive_demo',
        title: 'Competitive Exams',
        description: 'Prepare for JEE, NEET, and other competitive exams with targeted practice.',
        category: 'competitive_exams',
        difficulty: 'medium',
        colorHex: '#E8A87C',
        order: 3,
      ),
      Course(
        id: 'skills_demo',
        title: 'Skill Learning',
        description: 'Learn programming, creative arts, and life skills at your own pace.',
        category: 'skill_learning',
        difficulty: 'beginner',
        colorHex: '#7B93D0',
        order: 4,
      ),
    ].where((c) => category == null || c.category == category).toList();
  }
}
