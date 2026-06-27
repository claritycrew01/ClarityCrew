import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course.dart';
import '../models/subject.dart';
import '../models/unit.dart';
import '../models/lesson.dart';
import '../models/quiz_question.dart';
import '../models/exercise.dart';
import '../utils/constants.dart';

class ContentService {
  FirebaseFirestore? _firestore;

  ContentService() {
    try {
      _firestore = FirebaseFirestore.instance;
    } catch (_) {}
  }

  Future<List<Course>> getCourses({String? category}) async {
    if (_firestore == null) return [];
    Query query = _firestore!
        .collection(AppConstants.collectionCourses)
        .where('isPublished', isEqualTo: true)
        .orderBy('order');

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Course.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Course?> getCourse(String courseId) async {
    if (_firestore == null) return null;
    final doc =
        await _firestore!.collection(AppConstants.collectionCourses).doc(courseId).get();
    if (!doc.exists) return null;
    return Course.fromFirestore(doc.data()! as Map<String, dynamic>, doc.id);
  }

  Future<List<Subject>> getSubjects(String courseId) async {
    if (_firestore == null) return [];
    final snapshot = await _firestore!
        .collection(AppConstants.collectionSubjects)
        .where('courseId', isEqualTo: courseId)
        .where('isPublished', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => Subject.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Subject?> getSubject(String subjectId) async {
    if (_firestore == null) return null;
    final doc = await _firestore!
        .collection(AppConstants.collectionSubjects)
        .doc(subjectId)
        .get();
    if (!doc.exists) return null;
    return Subject.fromFirestore(doc.data()! as Map<String, dynamic>, doc.id);
  }

  Future<List<Unit>> getUnits(String subjectId) async {
    if (_firestore == null) return [];
    final snapshot = await _firestore!
        .collection(AppConstants.collectionUnits)
        .where('subjectId', isEqualTo: subjectId)
        .where('isPublished', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => Unit.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Unit?> getUnit(String unitId) async {
    if (_firestore == null) return null;
    final doc = await _firestore!
        .collection(AppConstants.collectionUnits)
        .doc(unitId)
        .get();
    if (!doc.exists) return null;
    return Unit.fromFirestore(doc.data()! as Map<String, dynamic>, doc.id);
  }

  Future<List<Lesson>> getLessons(String unitId) async {
    if (_firestore == null) return [];
    final snapshot = await _firestore!
        .collection(AppConstants.collectionLessons)
        .where('unitId', isEqualTo: unitId)
        .where('isPublished', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => Lesson.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<Lesson?> getLesson(String lessonId) async {
    if (_firestore == null) return null;
    final doc = await _firestore!
        .collection(AppConstants.collectionLessons)
        .doc(lessonId)
        .get();
    if (!doc.exists) return null;
    return Lesson.fromFirestore(doc.data()! as Map<String, dynamic>, doc.id);
  }

  Future<List<QuizQuestion>> getQuizQuestions(String quizId) async {
    if (_firestore == null) return [];
    final snapshot = await _firestore!
        .collection(AppConstants.collectionQuizzes)
        .doc(quizId)
        .collection('questions')
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => QuizQuestion.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<Exercise>> getExercises(String lessonId) async {
    if (_firestore == null) return [];
    final snapshot = await _firestore!
        .collection(AppConstants.collectionExercises)
        .where('lessonId', isEqualTo: lessonId)
        .where('isPublished', isEqualTo: true)
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => Exercise.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<List<Course>> searchContent(String query) async {
    if (_firestore == null) return [];
    final snapshot = await _firestore!
        .collection(AppConstants.collectionCourses)
        .where('isPublished', isEqualTo: true)
        .get();

    final results = <Course>[];
    final lowerQuery = query.toLowerCase();
    for (final doc in snapshot.docs) {
      final course = Course.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
      if (course.title.toLowerCase().contains(lowerQuery) ||
          course.description.toLowerCase().contains(lowerQuery)) {
        results.add(course);
      }
      if (results.length >= 10) break;
    }
    return results;
  }

  Future<void> importKolibriContent(Map<String, dynamic> kolibriData) async {
    if (_firestore == null) return;
    final batch = _firestore!.batch();

    if (kolibriData.containsKey('courses')) {
      for (final courseData in kolibriData['courses'] as List) {
        final docRef = _firestore!
            .collection(AppConstants.collectionCourses)
            .doc(courseData['id'] as String);
        batch.set(docRef, {
          ...courseData as Map<String, dynamic>,
          'isPublished': true,
          'lastUpdated': FieldValue.serverTimestamp(),
          'source': 'kolibri',
        });
      }
    }

    await batch.commit();
  }

  Map<String, dynamic> parseKolibriContent(String rawJson) {
    try {
      return json.decode(rawJson) as Map<String, dynamic>;
    } catch (e) {
      throw FormatException('Invalid Kolibri content format: $e');
    }
  }
}
