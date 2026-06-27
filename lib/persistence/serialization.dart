typedef JsonMap = Map<String, dynamic>;

T enumFromJson<T>(List<T> values, String? name, T defaultValue) {
  try {
    return values.firstWhere((e) => e.toString().split('.').last == name);
  } catch (_) {
    return defaultValue;
  }
}

String enumToJson<T>(T value) => value.toString().split('.').last;
