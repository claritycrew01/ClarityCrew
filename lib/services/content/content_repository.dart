import 'dart:convert';
import 'package:flutter/services.dart';
import '../../models/content_item.dart';
import '../../models/video_content.dart';

class ContentRepository {
  List<ContentItem> _lessons = [];
  List<VideoContent> _videos = [];
  List<Map<String, dynamic>> _subjects = [];
  List<Map<String, dynamic>> _chapters = [];

  List<ContentItem> get lessons => _lessons;
  List<VideoContent> get videos => _videos;
  List<Map<String, dynamic>> get subjects => _subjects;
  List<Map<String, dynamic>> get chapters => _chapters;

  Future<void> loadAll() async {
    await Future.wait([
      loadLessons(),
      loadVideos(),
      loadSubjects(),
      loadChapters(),
    ]);
  }

  Future<void> loadLessons() async {
    final json = await rootBundle.loadString('assets/content/lessons.json');
    final list = jsonDecode(json) as List<dynamic>;
    _lessons = list
        .map((e) => ContentItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> loadVideos() async {
    final json = await rootBundle.loadString('assets/content/videos.json');
    final list = jsonDecode(json) as List<dynamic>;
    _videos = list
        .map((e) => VideoContent.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> loadSubjects() async {
    final json = await rootBundle.loadString('assets/content/subjects.json');
    final list = jsonDecode(json) as List<dynamic>;
    _subjects = list.cast<Map<String, dynamic>>();
  }

  Future<void> loadChapters() async {
    final json = await rootBundle.loadString('assets/content/chapters.json');
    final list = jsonDecode(json) as List<dynamic>;
    _chapters = list.cast<Map<String, dynamic>>();
  }

  List<ContentItem> getLessonsBySubject(String subject) {
    return _lessons.where((l) => l.subject == subject).toList();
  }

  List<ContentItem> getLessonsByChapter(String chapterId) {
    return _lessons.where((l) => l.chapterId == chapterId).toList();
  }

  List<VideoContent> getVideosBySubject(String subject) {
    return _videos.where((v) => v.subject == subject).toList();
  }

  ContentItem? getLessonById(String id) {
    try {
      return _lessons.firstWhere((l) => l.id == id);
    } catch (_) {
      return null;
    }
  }

  VideoContent? getVideoById(String id) {
    try {
      return _videos.firstWhere((v) => v.id == id);
    } catch (_) {
      return null;
    }
  }

  ContentItem? getLessonByVideoId(String videoId) {
    final video = getVideoById(videoId);
    if (video == null) return null;
    return getLessonById(video.linkedLessonId);
  }
}
