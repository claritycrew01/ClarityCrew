import '../models/tutor_message.dart';
import 'shared_preferences_adapter.dart';

class TutorStorage {
  TutorStorage(this._adapter);

  final SharedPreferencesAdapter _adapter;

  Future<void> saveConversation(TutorConversation conversation) async {
    await _adapter.setString('tutor_conversation', conversation.toJsonString());
  }

  TutorConversation loadConversation() {
    final json = _adapter.getString('tutor_conversation');
    if (json == null) return const TutorConversation();
    return TutorConversation.fromJsonString(json);
  }

  Future<void> clearConversation() async {
    await _adapter.remove('tutor_conversation');
  }
}
