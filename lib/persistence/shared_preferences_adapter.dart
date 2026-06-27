import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesAdapter {
  SharedPreferencesAdapter(this._prefs);

  final SharedPreferences _prefs;

  Future<void> setString(String key, String value) => _prefs.setString(key, value);
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);
  Future<void> setDouble(String key, double value) => _prefs.setDouble(key, value);
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);
  Future<void> setStringList(String key, List<String> value) =>
      _prefs.setStringList(key, value);

  String? getString(String key) => _prefs.getString(key);
  int? getInt(String key) => _prefs.getInt(key);
  double? getDouble(String key) => _prefs.getDouble(key);
  bool? getBool(String key) => _prefs.getBool(key);
  List<String>? getStringList(String key) => _prefs.getStringList(key);

  Future<void> remove(String key) => _prefs.remove(key);
  bool containsKey(String key) => _prefs.containsKey(key);
}
