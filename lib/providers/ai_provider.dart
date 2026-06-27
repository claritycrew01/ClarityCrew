import 'package:flutter/material.dart';
import '../services/ai_service.dart';

class AIMessage {
  final String role;
  final String content;
  final DateTime timestamp;

  AIMessage({
    required this.role,
    required this.content,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

class AIProvider extends ChangeNotifier {
  final AIService _aiService = AIService();

  List<AIMessage> _messages = [];
  bool _isLoading = false;
  String? _error;

  List<AIMessage> get messages => _messages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isConfigured => _aiService.isConfigured;
  bool get useMock => _aiService.useMock;

  void configure({String? apiKey, bool? useMockData}) {
    _aiService.configure(apiKey: apiKey, useMockData: useMockData);
    notifyListeners();
  }

  Future<void> sendMessage(String message) async {
    if (message.trim().isEmpty) return;

    _messages.add(AIMessage(role: 'user', content: message));
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _aiService.chat(message);
      _messages.add(AIMessage(role: 'assistant', content: response));
    } catch (e) {
      _error = 'Unable to get a response. Please try again.';
      _messages.add(AIMessage(
        role: 'assistant',
        content: "I'm sorry, I had trouble responding. Could you try asking in a different way?",
      ));
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<String> generateExplanation(String topic,
      {String level = 'simple'}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _aiService.explain(topic, level: level);
      return response;
    } catch (e) {
      return 'Unable to generate explanation. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> generateQuiz(String topic,
      {int count = 5, String difficulty = 'medium'}) async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _aiService.generateQuiz(topic,
          questionCount: count, difficulty: difficulty);
    } catch (e) {
      return 'Unable to generate quiz. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> generateSummary(String content,
      {String style = 'concise'}) async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _aiService.generateSummary(content, style: style);
    } catch (e) {
      return 'Unable to generate summary. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> generateStudyPlan(
      String goals, String topics,
      {int days = 7}) async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _aiService.generateStudyPlan(goals, topics,
          days: days);
    } catch (e) {
      return 'Unable to generate study plan.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> simplifyContent(String content,
      {String level = 'simple'}) async {
    _isLoading = true;
    notifyListeners();

    try {
      return await _aiService.simplifyContent(content,
          readingLevel: level);
    } catch (e) {
      return 'Unable to simplify content. Please try again.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearMessages() {
    _messages = [];
    _error = null;
    notifyListeners();
  }
}
