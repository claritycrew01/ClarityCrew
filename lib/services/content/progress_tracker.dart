import '../../models/learner_profile.dart';
import '../../models/session_record.dart';
import '../../persistence/local_storage_repository.dart';

class ProgressTracker {
  ProgressTracker(this._repository);

  final LocalStorageRepository _repository;

  double overallProgress(LearnerProfile profile) {
    final sessions = _repository.loadSessions();
    if (sessions.isEmpty) return 0.0;
    final completed = sessions.where((s) => s.completed).length;
    return completed / sessions.length;
  }

  double subjectProgress(String subject) {
    final sessions = _repository.loadSessions();
    final relevant =
        sessions.where((s) => s.topicTags.contains(subject)).toList();
    if (relevant.isEmpty) return 0.0;
    final completed = relevant.where((s) => s.completed).length;
    return completed / relevant.length;
  }

  int totalStudyMinutes() {
    final sessions = _repository.loadSessions();
    final totalSeconds =
        sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    return totalSeconds ~/ 60;
  }

  int sessionsCompleted() {
    return _repository.loadSessions().where((s) => s.completed).length;
  }

  int subjectsStarted() {
    final sessions = _repository.loadSessions();
    final subjects = <String>{};
    for (final session in sessions) {
      subjects.addAll(session.topicTags);
    }
    return subjects.length;
  }
}
