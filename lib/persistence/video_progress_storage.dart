import 'dart:convert';
import 'shared_preferences_adapter.dart';

class VideoProgressStorage {
  VideoProgressStorage(this._adapter);

  final SharedPreferencesAdapter _adapter;

  Future<void> saveProgress(String videoId, double position) async {
    final all = loadAllProgress();
    all[videoId] = position;
    await _adapter.setString('video_progress', jsonEncode(all));
  }

  double loadProgress(String videoId) {
    final all = loadAllProgress();
    return all[videoId] ?? 0.0;
  }

  Map<String, double> loadAllProgress() {
    final json = _adapter.getString('video_progress');
    if (json == null) return {};
    final decoded = jsonDecode(json) as Map<String, dynamic>;
    return decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
  }

  Future<void> clearProgress(String videoId) async {
    final all = loadAllProgress();
    all.remove(videoId);
    await _adapter.setString('video_progress', jsonEncode(all));
  }

  Future<void> clearAll() async {
    await _adapter.remove('video_progress');
  }
}
