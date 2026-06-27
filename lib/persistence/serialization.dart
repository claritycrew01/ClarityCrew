import 'dart:convert';
import '../models/learner_profile.dart';
import '../models/session_record.dart';

typedef JsonMap = Map<String, dynamic>;

T enumFromJson<T>(List<T> values, String? name, T defaultValue) {
  try {
    return values.firstWhere((e) => e.toString().split('.').last == name);
  } catch (_) {
    return defaultValue;
  }
}

String enumToJson<T>(T value) => value.toString().split('.').last;

class Serialization {
  Serialization._();

  static String learnerProfileToJson(LearnerProfile profile) =>
      profile.toJsonString();

  static LearnerProfile learnerProfileFromJson(String json) =>
      LearnerProfile.fromJsonString(json);

  static String sessionListToJson(List<SessionRecord> records) =>
      jsonEncode(records.map((r) => r.toJson()).toList());

  static List<SessionRecord> sessionListFromJson(String json) {
    final list = jsonDecode(json) as List<dynamic>;
    return list
        .map((e) => SessionRecord.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
