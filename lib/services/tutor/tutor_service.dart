import 'dart:math';
import '../../models/tutor_message.dart';
import '../../persistence/tutor_storage.dart';
import 'dart:convert';

class TutorService {
  TutorService(this._storage);

  final TutorStorage _storage;

  TutorConversation _conversation = const TutorConversation();
  final _random = Random();

  TutorConversation get conversation => _conversation;

  Future<void> loadConversation() async {
    _conversation = _storage.loadConversation();
  }

  Future<void> sendMessage(String text, {String? contentId}) async {
    final userMsg = TutorMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      role: 'user',
      text: text,
      contentId: contentId,
      timestamp: DateTime.now(),
    );

    _conversation = _conversation.copyWith(
      messages: [..._conversation.messages, userMsg],
      lastContentId: contentId ?? _conversation.lastContentId,
    );

    final response = _generateResponse(text);
    final tutorMsg = TutorMessage(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch + 1}',
      role: 'tutor',
      text: response,
      contentId: contentId,
      timestamp: DateTime.now(),
    );

    _conversation = _conversation.copyWith(
      messages: [..._conversation.messages, tutorMsg],
    );

    await _storage.saveConversation(_conversation);
  }

  String _generateResponse(String userInput) {
    final lower = userInput.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi') || lower.contains('hey')) {
      return _pickRandom([
        'Hello! Ready to learn something new today?',
        'Hi there! What would you like to study?',
        'Hey! Im here to help you learn at your own pace.',
      ]);
    }
    if (lower.contains('explain') || lower.contains('understand')) {
      return _pickRandom([
        'Let me break this down into smaller steps. First, think about what you already know about this topic.',
        'Great question! Imagine this as building blocks. We will start with the simplest idea and build up.',
        'This can be tricky, but let us take it one step at a time. What part is most confusing?',
      ]);
    }
    if (lower.contains('help') || lower.contains('stuck')) {
      return _pickRandom([
        'No worries! Would you like to try a different learning mode? We can switch to a video, quiz, or flashcards.',
        'Being stuck is part of learning. Would a visual summary help, or should we try a simpler explanation?',
        'Lets try a different approach. Sometimes hearing it explained differently makes all the difference.',
      ]);
    }
    if (lower.contains('hard') || lower.contains('difficult')) {
      return _pickRandom([
        'This is challenging material! Remember to take breaks when you need them. Would you like to try an easier topic first?',
        'It is okay if this feels hard. Learning takes time. Should we adjust the difficulty level?',
        'You are doing great by trying! Would a short focus session help you concentrate better?',
      ]);
    }
    return _pickRandom([
      'That is an interesting thought! Would you like to explore this topic further, or try a different subject?',
      'I see what you mean. Would you like to see some related content or practice with a quiz?',
      'Keep going! Would you like me to suggest some resources or explain a specific concept?',
    ]);
  }

  String _pickRandom(List<String> options) {
    return options[_random.nextInt(options.length)];
  }

  Future<void> clearConversation() async {
    _conversation = const TutorConversation();
    await _storage.clearConversation();
  }
}
