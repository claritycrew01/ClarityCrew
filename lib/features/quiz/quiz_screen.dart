import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/content_item.dart';
import '../../models/interaction_event.dart';

class QuizScreen extends StatefulWidget {
  final ContentItem lesson;

  const QuizScreen({super.key, required this.lesson});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int? _selectedOption;
  int _score = 0;
  bool _showResult = false;

  List<ContentItem> get _questions {
    if (widget.lesson.quizOptions.isNotEmpty) {
      return [widget.lesson];
    }
    return widget.lesson.flashcards;
  }

  ContentItem get _currentQuestionItem => _questions[_currentQuestion];

  void _selectOption(int index) {
    if (_selectedOption != null) return;
    setState(() => _selectedOption = index);
  }

  void _next() {
    if (_selectedOption == null) return;

    final isCorrect =
        _selectedOption == _currentQuestionItem.correctOptionIndex;
    if (isCorrect) _score++;

    final appState = context.read<AppState>();
    appState.sessionState.recordInteraction(
      InteractionEvent(
        id: 'int_${DateTime.now().millisecondsSinceEpoch}',
        sessionId: appState.sessionState.currentSession?.id ?? '',
        learnerId: appState.learnerState.profile?.id ?? '',
        contentType: 'quiz',
        contentId: _currentQuestionItem.id,
        interactionType: 'completed',
        wasSuccessful: isCorrect,
        score: isCorrect ? 100 : 0,
        timestamp: DateTime.now(),
      ),
    );

    if (_currentQuestion < _questions.length - 1) {
      setState(() {
        _currentQuestion++;
        _selectedOption = null;
      });
    } else {
      setState(() => _showResult = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz Complete')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _score == _questions.length
                    ? Icons.celebration
                    : _score > _questions.length ~/ 2
                        ? Icons.thumb_up
                        : Icons.replay,
                size: 80,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'You scored $_score out of ${_questions.length}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                _score == _questions.length
                    ? 'Perfect score! Amazing!'
                    : _score > _questions.length ~/ 2
                        ? 'Great job! Keep practicing.'
                        : 'Keep trying, you will get it!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Question ${_currentQuestion + 1}/${_questions.length}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            LinearProgressIndicator(
              value: (_currentQuestion + 1) / _questions.length,
            ),
            const SizedBox(height: 32),
            Text(
              _currentQuestionItem.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            if (_currentQuestionItem.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                _currentQuestionItem.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
            if (_currentQuestionItem.quizOptions.isNotEmpty) ...[
              const SizedBox(height: 24),
              ..._currentQuestionItem.quizOptions.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: OutlinedButton(
                        onPressed: () => _selectOption(entry.key),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: _selectedOption == entry.key
                              ? Theme.of(context).colorScheme.primaryContainer
                              : null,
                          padding: const EdgeInsets.all(16),
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(entry.value),
                        ),
                      ),
                    ),
                  ),
            ],
            const Spacer(),
            FilledButton(
              onPressed: _selectedOption != null ? _next : null,
              child: Text(
                _currentQuestion < _questions.length - 1
                    ? 'Next'
                    : 'Finish',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
