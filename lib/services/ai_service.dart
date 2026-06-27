import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {
  String? _apiKey;
  String _model = 'gpt-4';
  bool _useMockData = true;

  static final AIService _instance = AIService._();
  factory AIService() => _instance;
  AIService._();

  void configure({String? apiKey, String? model, bool? useMockData}) {
    _apiKey = apiKey;
    if (model != null) _model = model;
    if (useMockData != null) _useMockData = useMockData;
  }

  bool get isConfigured => _apiKey != null && _apiKey!.isNotEmpty;
  bool get useMock => _useMockData;

  Future<String> chat(String message, {List<Map<String, String>>? context}) async {
    if (_useMockData) {
      return _mockChatResponse(message);
    }
    return _callAIAPI([
      ...context ?? [],
      {'role': 'user', 'content': message},
    ]);
  }

  Future<String> explain(String topic, {String level = 'simple'}) async {
    if (_useMockData) {
      return _mockExplainResponse(topic, level);
    }
    return _callAIAPI([
      {
        'role': 'system',
        'content':
            'Explain the following topic in a $level, easy-to-understand way. Use simple language, short sentences, and relatable examples. Break it down step by step.',
      },
      {'role': 'user', 'content': topic},
    ]);
  }

  Future<String> generateQuiz(String topic,
      {int questionCount = 5, String difficulty = 'medium'}) async {
    if (_useMockData) {
      return _mockQuizResponse(topic, questionCount);
    }
    return _callAIAPI([
      {
        'role': 'system',
        'content':
            'Generate $questionCount $difficulty multiple-choice quiz questions about "$topic". Return as JSON array with fields: question, options (list of 4), correctIndex, explanation.',
      },
      {'role': 'user', 'content': topic},
    ]);
  }

  Future<String> generateSummary(String content,
      {String style = 'concise'}) async {
    if (_useMockData) {
      return _mockSummaryResponse(content);
    }
    return _callAIAPI([
      {
        'role': 'system',
        'content':
            'Summarize the following content in a $style, clear way. Use bullet points for key ideas. Keep it friendly and easy to understand.',
      },
      {'role': 'user', 'content': content},
    ]);
  }

  Future<String> generateStudyPlan(
      String goals, String availableTopics,
      {int days = 7}) async {
    if (_useMockData) {
      return _mockStudyPlanResponse(goals, days);
    }
    return _callAIAPI([
      {
        'role': 'system',
        'content':
            'Create a $days-day study plan for a student with the following goals: $goals. Available topics: $availableTopics. Make the plan manageable, with breaks and review sessions. Return as a friendly, structured plan.',
      },
    ]);
  }

  Future<String> simplifyContent(String content,
      {String readingLevel = 'simple'}) async {
    if (_useMockData) {
      return _mockSimplifyResponse(content);
    }
    return _callAIAPI([
      {
        'role': 'system',
        'content':
            'Rewrite the following content at a $readingLevel reading level. Use short sentences, simple words, and clear structure. Break down complex ideas. Keep the key information intact.',
      },
      {'role': 'user', 'content': content},
    ]);
  }

  Future<String> _callAIAPI(List<Map<String, String>> messages) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return 'AI is not configured. Please set up an API key.';
    }

    try {
      final response = await http.post(
        Uri.parse('https://api.openai.com/v1/chat/completions'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $_apiKey',
        },
        body: json.encode({
          'model': _model,
          'messages': [
            {
              'role': 'system',
              'content':
                  'You are ClarityBuddy, a friendly, patient AI tutor for neurodivergent students. Be encouraging, clear, and supportive. Use simple language and break down complex ideas.',
            },
            ...messages,
          ],
          'max_tokens': 1000,
          'temperature': 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['choices'][0]['message']['content'] as String;
      }
      return 'I had trouble thinking about that. Could you try again?';
    } catch (e) {
      return "I'm here to help! Could you rephrase your question?";
    }
  }

  String _mockChatResponse(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('hello') || lower.contains('hi')) {
      return 'Hi there! I\'m ClarityBuddy, your learning companion. What would you like to explore today?';
    }
    if (lower.contains('math') || lower.contains('maths') || lower.contains('mathematics')) {
      return 'Math can be fun when we break it down! What topic are you working on? Fractions, algebra, geometry, or something else? I can help explain it step by step.';
    }
    if (lower.contains('science')) {
      return 'Science is all about curiosity! Which branch are you studying? I can help with physics, chemistry, biology, or any science topic you\'re curious about.';
    }
    if (lower.contains('help') || lower.contains('stuck')) {
      return 'Don\'t worry at all! Getting stuck is just part of learning. Let\'s figure this out together. Can you tell me what you\'re working on right now?';
    }
    if (lower.contains('thanks') || lower.contains('thank')) {
      return 'You\'re very welcome! That\'s what I\'m here for. Keep up the great work — you\'re doing amazing! 😊';
    }
    return 'That\'s a great question! Let me think about the best way to explain this. Could you tell me a bit more about what you\'re studying so I can give you the most helpful answer?';
  }

  String _mockExplainResponse(String topic, String level) {
    return 'Here\'s an explanation of "$topic" in a simple way:\n\n'
        'Let\'s break it down into small pieces:\n\n'
        '1. **What is it?**\n'
        '$topic is a concept that helps us understand how things work. Think of it like building with blocks — each piece connects to the next.\n\n'
        '2. **Key ideas**\n'
        '• Start with the basics — what you already know\n'
        '• Build up slowly — one step at a time\n'
        '• Practice helps make it stick\n\n'
        '3. **Remember**\n'
        'Everyone learns at their own pace, and that\'s perfectly okay! Take your time and feel free to ask questions.\n\n'
        'Would you like me to explain a specific part in more detail?';
  }

  String _mockQuizResponse(String topic, int count) {
    final questions = [
      {
        'question': 'What is the main idea of $topic?',
        'options': [
          'A key concept in the subject',
          'An unrelated topic',
          'A difficult problem',
          'A random idea',
        ],
        'correctIndex': 0,
        'explanation': '$topic is a key concept that helps us understand the subject better.',
      },
      {
        'question': 'How can $topic be applied in real life?',
        'options': [
          'It has no real use',
          'Only in theory',
          'In many practical situations',
          'It cannot be applied',
        ],
        'correctIndex': 2,
        'explanation': '$topic has many practical applications in everyday situations.',
      },
      {
        'question': 'What is the best way to learn $topic?',
        'options': [
          'Memorize everything',
          'Practice step by step',
          'Skip the basics',
          'Only watch videos',
        ],
        'correctIndex': 1,
        'explanation': 'Practicing step by step helps build a strong understanding of $topic.',
      },
      {
        'question': 'Why is understanding $topic important?',
        'options': [
          'It is not important',
          'It builds foundational knowledge',
          'Only for exams',
          'It is optional',
        ],
        'correctIndex': 1,
        'explanation': 'Understanding $topic builds foundational knowledge for advanced learning.',
      },
      {
        'question': 'What should you do if you find $topic difficult?',
        'options': [
          'Give up',
          'Ask for help and practice more',
          'Skip it entirely',
          'Worry about it',
        ],
        'correctIndex': 1,
        'explanation': 'Asking for help and practicing more are great strategies for difficult topics!',
      },
    ];

    final selected = questions.take(count).toList();
    return json.encode(selected);
  }

  String _mockSummaryResponse(String content) {
    return 'Here\'s a friendly summary of what you\'ve been learning:\n\n'
        '**Key points to remember:**\n'
        '• Focus on the main ideas first\n'
        '• Connect new information to what you already know\n'
        '• Take breaks to let your brain process\n\n'
        '**Quick review:**\n'
        'This content covers important concepts that build on each other. Try explaining it to someone else — that\'s a great way to check your understanding!\n\n'
        '**Next steps:**\n'
        'Would you like to quiz yourself on this or explore more? I\'m here to help!';
  }

  String _mockStudyPlanResponse(String goals, int days) {
    final plan = StringBuffer();
    plan.writeln('Here\'s your personalized study plan for the next $days days!\n');
    plan.writeln('**Goal:** $goals\n');
    plan.writeln('Remember: Take breaks, stay hydrated, and go at your own pace. You\'ve got this!\n');

    for (int i = 1; i <= days; i++) {
      plan.writeln('**Day $i:**');
      plan.writeln('• Session 1: Focus on core concepts (25 minutes)');
      plan.writeln('• Take a 5-minute break');
      plan.writeln('• Session 2: Practice and review (25 minutes)');
      plan.writeln('• Session 3: Quick quiz or summary (15 minutes)');
      plan.writeln('• End with a review of what you learned');
      plan.writeln('');
    }

    plan.writeln('**Tips for success:**');
    plan.writeln('• Study at the same time each day to build a routine');
    plan.writeln('• Use the AI tutor whenever you get stuck');
    plan.writeln('• Celebrate small wins — every step counts!');

    return plan.toString();
  }

  String _mockSimplifyResponse(String content) {
    final preview = content.length > 100 ? '${content.substring(0, 100)}...' : content;
    return 'Here\'s a simpler version of the content:\n\n'
        '**What this means:**\n'
        '$preview\n\n'
        '**In simpler words:**\n'
        'Let\'s break this down into smaller ideas:\n'
        '• Idea 1: Start with what you know\n'
        '• Idea 2: Add new information one step at a time\n'
        '• Idea 3: Practice to make it stick\n\n'
        '**Example to help:**\n'
        'Think of it like learning a new game. First, you learn the rules. Then you practice each move. Soon, it becomes natural!\n\n'
        'Does this help? Let me know if you\'d like me to explain any part differently!';
  }
}
