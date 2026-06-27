import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/content_item.dart';
import '../../models/subject_data.dart';
import '../../models/video_content.dart';
import 'subject_icon_registry.dart';

class ContentRepository {
  ContentRepository._();

  static List<ContentItem> _allContent = [];
  static List<VideoContent> _allVideos = [];
  static List<_SubjectRecord> _subjects = [];
  static List<_ChapterRecord> _chapters = [];
  static bool _initialized = false;

  static bool get isInitialized => _initialized;

  static Future<void> initialize() async {
    if (_initialized) return;
    await Future.wait([
      _loadLessons(),
      _loadVideos(),
      _loadSubjects(),
      _loadChapters(),
    ]);
    _initialized = true;
  }

  static Future<void> _loadLessons() async {
    final json = await rootBundle.loadString('assets/content/lessons.json');
    final list = jsonDecode(json) as List<dynamic>;
    _allContent = list
        .map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _loadVideos() async {
    final json = await rootBundle.loadString('assets/content/videos.json');
    final list = jsonDecode(json) as List<dynamic>;
    _allVideos = list
        .map((e) => VideoContent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _loadSubjects() async {
    final json = await rootBundle.loadString('assets/content/subjects.json');
    final list = jsonDecode(json) as List<dynamic>;
    _subjects = list
        .map((e) => _SubjectRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Future<void> _loadChapters() async {
    final json = await rootBundle.loadString('assets/content/chapters.json');
    final list = jsonDecode(json) as List<dynamic>;
    _chapters = list
        .map((e) => _ChapterRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static List<ContentItem> getAll() => List.unmodifiable(_allContent);

  static ContentItem getById(String id) => _allContent.firstWhere(
        (l) => l.id == id,
        orElse: () => _allContent.first,
      );

  static ContentItem? findById(String id) {
    for (final lesson in _allContent) {
      if (lesson.id == id) return lesson;
    }
    return null;
  }

  static List<ContentItem> getByTags(List<String> tags) => _allContent
      .where((l) => l.tags.any((t) => tags.contains(t)))
      .toList();

  static List<ContentItem> getByDifficulty(String difficulty) =>
      _allContent.where((l) => l.difficulty == difficulty).toList();

  static List<ContentItem> getByType(String contentType) {
    if (contentType == 'lesson') {
      return _allContent
          .where((l) =>
              l.contentType != 'quiz' &&
              l.contentType != 'flashcard' &&
              l.contentType != 'video')
          .toList();
    }
    return _allContent.where((l) => l.contentType == contentType).toList();
  }

  static List<ContentItem> getBySubject(String subject) =>
      _allContent.where((l) => l.subject == subject).toList();

  static List<String> getAllSubjectNames() =>
      _allContent.map((l) => l.subject).toSet().toList()..sort();

  static List<String> getChaptersForSubject(String subject) => _chapters
      .where((c) {
        final subjectRecord =
            _subjects.where((s) => s.name == subject).firstOrNull;
        return subjectRecord != null && c.subjectId == subjectRecord.id;
      })
      .map((c) => c.title)
      .toList();

  static VideoContent? getVideoById(String id) {
    for (final video in _allVideos) {
      if (video.id == id) return video;
    }
    return null;
  }

  static VideoContent? getVideoForLesson(String lessonId) {
    final lesson = findById(lessonId);
    if (lesson?.videoId != null && lesson!.videoId!.isNotEmpty) {
      return getVideoById(lesson.videoId!);
    }
    for (final video in _allVideos) {
      if (video.linkedLessonId == lessonId) return video;
    }
    return null;
  }

  static List<VideoContent> getVideosForSubject(String subject) =>
      _allVideos.where((v) => v.subject == subject).toList();

  static List<VideoContent> getAllVideos() => List.unmodifiable(_allVideos);

  static List<SubjectData> getSubjects() {
    return _subjects.map((subject) {
      final subjectLessons =
          _allContent.where((l) => l.subject == subject.name).toList();
      final subjectVideos =
          _allVideos.where((v) => v.subject == subject.name).toList();
      final chapterTitles = _chapters
          .where((c) => c.subjectId == subject.id)
          .toList()
        ..sort((a, b) => a.order.compareTo(b.order));

      return SubjectData(
        id: subject.id,
        name: subject.name,
        icon: SubjectIconRegistry.iconFor(subject.iconKey),
        color: SubjectIconRegistry.colorFromHex(subject.color),
        chapters: chapterTitles.map((c) => c.title).toList(),
        lessonCount: subjectLessons.length,
        videoCount: subjectVideos.length,
      );
    }).toList();
  }
}

class _SubjectRecord {
  final String id;
  final String name;
  final String iconKey;
  final String color;

  const _SubjectRecord({
    required this.id,
    required this.name,
    required this.iconKey,
    required this.color,
  });

  factory _SubjectRecord.fromJson(Map<String, dynamic> json) {
    return _SubjectRecord(
      id: json['id'] as String,
      name: json['name'] as String,
      iconKey: json['iconKey'] as String,
      color: json['color'] as String,
    );
  }
}

class _ChapterRecord {
  final String id;
  final String subjectId;
  final String title;
  final int order;

  const _ChapterRecord({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.order,
  });

  factory _ChapterRecord.fromJson(Map<String, dynamic> json) {
    return _ChapterRecord(
      id: json['id'] as String,
      subjectId: json['subjectId'] as String,
      title: json['title'] as String,
      order: json['order'] as int? ?? 0,
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
