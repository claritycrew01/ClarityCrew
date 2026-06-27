import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/content_item.dart';
import '../../models/interaction_event.dart';
import '../quiz/quiz_screen.dart';
import '../flashcards/flashcards_screen.dart';
import '../../services/content/subject_icon_registry.dart';

class LearningSessionScreen extends StatefulWidget {
  final ContentItem lesson;
  final String mode;

  const LearningSessionScreen({
    super.key,
    required this.lesson,
    this.mode = 'lesson',
  });

  @override
  State<LearningSessionScreen> createState() => _LearningSessionScreenState();
}

class _LearningSessionScreenState extends State<LearningSessionScreen> {
  @override
  void initState() {
    super.initState();
    final appState = context.read<AppState>();
    appState.sessionState.startSession(widget.mode, [
      widget.lesson.subject,
      widget.lesson.chapter,
    ]);
  }

  @override
  void dispose() {
    context.read<AppState>().sessionState.endSession();
    super.dispose();
  }

  void _recordInteraction(String type) {
    final appState = context.read<AppState>();
    appState.sessionState.recordInteraction(
      InteractionEvent(
        id: 'int_${DateTime.now().millisecondsSinceEpoch}',
        sessionId: appState.sessionState.currentSession?.id ?? '',
        learnerId: appState.learnerState.profile?.id ?? '',
        contentType: widget.mode,
        contentId: widget.lesson.id,
        interactionType: type,
        timestamp: DateTime.now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lesson = widget.lesson;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Icon(
                SubjectIconRegistry.getIcon(lesson.subject),
                color: SubjectIconRegistry.getColor(lesson.subject),
              ),
              const SizedBox(width: 8),
              Text(
                lesson.subject,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                lesson.difficulty,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            lesson.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          if (lesson.quizOptions.isNotEmpty)
            Card(
              child: ListTile(
                leading: const Icon(Icons.quiz),
                title: const Text('Practice Quiz'),
                subtitle: const Text('Test your knowledge'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _recordInteraction('started_quiz');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => QuizScreen(lesson: lesson),
                    ),
                  );
                },
              ),
            ),
          if (lesson.flashcards.isNotEmpty)
            Card(
              child: ListTile(
                leading: const Icon(Icons.style),
                title: const Text('Flashcards'),
                subtitle: const Text('Review key concepts'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  _recordInteraction('started_flashcards');
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => FlashcardsScreen(lesson: lesson),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _recordInteraction('requested_simpler'),
                  icon: const Icon(Icons.remove_circle_outline),
                  label: const Text('Simplify'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _recordInteraction('requested_deeper'),
                  icon: const Icon(Icons.add_circle_outline),
                  label: const Text('Go Deeper'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
