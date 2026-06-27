class AppConstants {
  AppConstants._();

  static const String appName = 'ClarityCrew';
  static const String appTagline = 'Learn at your pace';
  static const String appDescription =
      'A calm, accessible learning platform for everyone.';

  static const double maxContentWidth = 1200.0;
  static const double cardBorderRadius = 16.0;
  static const double smallBorderRadius = 10.0;
  static const double buttonBorderRadius = 12.0;
  static const double standardPadding = 24.0;
  static const double smallPadding = 16.0;

  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration shortAnimation = Duration(milliseconds: 150);

  static const List<String> difficultyLevels = [
    'beginner',
    'easy',
    'medium',
    'hard',
    'advanced',
  ];

  static const List<String> courseCategories = [
    'cbse',
    'icse',
    'competitive_exams',
    'skill_learning',
    'custom',
  ];

  static const List<String> lessonSections = [
    'overview',
    'notes',
    'video',
    'quiz',
    'exercises',
    'revision',
    'ai_help',
  ];

  static const List<String> accessibilityOptions = [
    'text_size',
    'contrast',
    'reduced_motion',
    'focus_mode',
    'font_family',
  ];

  static const String collectionCourses = 'courses';
  static const String collectionSubjects = 'subjects';
  static const String collectionUnits = 'units';
  static const String collectionLessons = 'lessons';
  static const String collectionQuizzes = 'quizzes';
  static const String collectionExercises = 'exercises';
  static const String collectionProgress = 'user_progress';
  static const String collectionActivity = 'recent_activity';
  static const String collectionRecommendations = 'recommendations';
  static const String collectionContentSources = 'content_sources';
  static const String collectionUsers = 'users';
}
