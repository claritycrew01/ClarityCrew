import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../providers/lesson_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/ai_provider.dart';
import '../utils/colors.dart';
import '../utils/typography.dart';
import '../utils/responsive.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_state.dart';
import '../widgets/common/empty_state.dart';
import '../widgets/common/clarity_card.dart';
import '../widgets/lesson/lesson_tab.dart';

class LessonScreen extends StatefulWidget {
  final String lessonId;

  const LessonScreen({super.key, required this.lessonId});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LessonProvider>().loadLesson(widget.lessonId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lessonProvider = context.watch<LessonProvider>();
    final lesson = lessonProvider.currentLesson;
    final activeSection = lessonProvider.activeSection;
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(lesson?.title ?? 'Lesson',
            style: ClarityTypography.headlineSmall),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome_outlined,
                color: ClarityColors.primary),
            onPressed: () => context.go('/ai-assistant'),
            tooltip: 'AI Help',
          ),
        ],
      ),
      body: _buildContent(
          lessonProvider, lesson, activeSection, isDesktop),
    );
  }

  Widget _buildContent(LessonProvider provider, dynamic lesson,
      String activeSection, bool isDesktop) {
    if (provider.isLoading) {
      return const ClarityLoadingIndicator(
          message: 'Loading lesson...');
    }

    if (provider.error != null || lesson == null) {
      return ErrorState(
        message: provider.error ?? 'Lesson not found.',
        onRetry: () =>
            provider.loadLesson(widget.lessonId),
      );
    }

    return Column(
      children: [
        LessonSectionTabs(
          activeSection: activeSection,
          onSectionChanged: provider.setActiveSection,
        ),
        const SizedBox(height: 8),
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isDesktop ? 48 : 24),
            child: ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: 800),
              child: _renderSection(
                  activeSection, lesson, provider),
            ),
          ),
        ),
      ],
    );
  }

  Widget _renderSection(
      String section, dynamic lesson, LessonProvider provider) {
    switch (section) {
      case 'overview':
        return _OverviewSection(lesson: lesson);
      case 'notes':
        return _NotesSection(lesson: lesson);
      case 'video':
        return _VideoSection(lesson: lesson);
      case 'quiz':
        return _QuizSection(lesson: lesson, provider: provider);
      case 'exercises':
        return _ExercisesSection(lesson: lesson, provider: provider);
      case 'revision':
        return _RevisionSection(lesson: lesson);
      case 'ai_help':
        return _AIHelpSection(lesson: lesson);
      default:
        return const EmptyState(
          title: 'Content coming soon',
          icon: Icons.construction_outlined,
        );
    }
  }
}

class _OverviewSection extends StatelessWidget {
  final dynamic lesson;

  const _OverviewSection({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lesson.title,
            style: ClarityTypography.displaySmall),
        const SizedBox(height: 8),
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: ClarityColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(lesson.difficulty,
              style: TextStyle(
                  color: ClarityColors.primary,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ),
        const SizedBox(height: 16),
        Text(lesson.description,
            style: ClarityTypography.bodyLarge),
        const SizedBox(height: 24),
        if (lesson.overview.isNotEmpty)
          MarkdownBody(
            data: lesson.overview,
            styleSheet: MarkdownStyleSheet(
              p: ClarityTypography.bodyLarge,
              h1: ClarityTypography.headlineLarge,
              h2: ClarityTypography.headlineMedium,
              h3: ClarityTypography.headlineSmall,
              listBullet:
                  ClarityTypography.bodyLarge,
            ),
          ),
        const SizedBox(height: 24),
        Row(
          children: [
            const Icon(Icons.access_time_outlined,
                size: 16, color: ClarityColors.textSecondary),
            const SizedBox(width: 6),
            Text('${lesson.estimatedMinutes} minutes',
                style: ClarityTypography.bodySmall.copyWith(
                    color: ClarityColors.textSecondary)),
            const SizedBox(width: 16),
            const Icon(Icons.menu_book_outlined,
                size: 16, color: ClarityColors.textSecondary),
            const SizedBox(width: 6),
            Text('${lesson.resources.length} resources',
                style: ClarityTypography.bodySmall.copyWith(
                    color: ClarityColors.textSecondary)),
          ],
        ),
      ],
    );
  }
}

class _NotesSection extends StatelessWidget {
  final dynamic lesson;

  const _NotesSection({required this.lesson});

  @override
  Widget build(BuildContext context) {
    if (lesson.notes.isEmpty) {
      return const EmptyState(
        title: 'No notes available',
        subtitle: 'Notes for this lesson are being prepared.',
        icon: Icons.article_outlined,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Lesson Notes',
            style: ClarityTypography.headlineMedium),
        const SizedBox(height: 16),
        MarkdownBody(
          data: lesson.notes,
          styleSheet: MarkdownStyleSheet(
            p: ClarityTypography.bodyLarge,
            h1: ClarityTypography.headlineLarge,
            h2: ClarityTypography.headlineMedium,
            h3: ClarityTypography.headlineSmall,
            listBullet: ClarityTypography.bodyLarge,
            code: ClarityTypography.bodyMedium.copyWith(
              backgroundColor:
                  ClarityColors.surfaceAlt,
              fontFamily: 'monospace',
            ),
            codeblockDecoration: BoxDecoration(
              color: ClarityColors.surfaceAlt,
              borderRadius: BorderRadius.circular(10),
            ),
            blockquoteDecoration: BoxDecoration(
              color: ClarityColors.primary.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
              border: const Border(
                left: BorderSide(
                    color: ClarityColors.primary, width: 3),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VideoSection extends StatelessWidget {
  final dynamic lesson;

  const _VideoSection({required this.lesson});

  @override
  Widget build(BuildContext context) {
    final videos = lesson.resources
        .where((r) => r.type == 'video')
        .toList();

    if (videos.isEmpty) {
      return const EmptyState(
        title: 'No video available',
        subtitle: 'A video for this lesson will be added soon.',
        icon: Icons.play_circle_outline,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Video Resources',
            style: ClarityTypography.headlineMedium),
        const SizedBox(height: 16),
        ...videos.map((video) => ClarityCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 120,
                    height: 68,
                    decoration: BoxDecoration(
                      color: ClarityColors.primary
                          .withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Icon(
                          Icons.play_circle_fill,
                          size: 32,
                          color: ClarityColors.primary),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(video.title,
                            style:
                                ClarityTypography
                                    .titleSmall),
                        const SizedBox(height: 4),
                        Text(
                            '${video.durationSeconds ~/ 60}:${(video.durationSeconds % 60).toString().padLeft(2, '0')}',
                            style:
                                ClarityTypography
                                    .labelSmall
                                    .copyWith(
                                        color:
                                            ClarityColors
                                                .textSecondary)),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ],
    );
  }
}

class _QuizSection extends StatefulWidget {
  final dynamic lesson;
  final LessonProvider provider;

  const _QuizSection({required this.lesson, required this.provider});

  @override
  State<_QuizSection> createState() => _QuizSectionState();
}

class _QuizSectionState extends State<_QuizSection> {
  List<dynamic>? _questions;
  int _currentIndex = 0;
  int? _selectedAnswer;
  bool _showResult = false;
  int _correctCount = 0;
  bool _quizComplete = false;
  List<bool?> _answerResults = [];
  bool _loading = false;

  Future<void> _startQuiz(String quizId) async {
    setState(() {
      _loading = true;
      _currentIndex = 0;
      _selectedAnswer = null;
      _showResult = false;
      _correctCount = 0;
      _quizComplete = false;
      _answerResults = [];
    });
    await widget.provider.loadQuizQuestions(quizId);
    if (mounted) {
      setState(() {
        _questions = List.from(widget.provider.quizQuestions);
        _answerResults = List.filled(_questions!.length, null);
        _loading = false;
      });
    }
  }

  void _selectAnswer(int index) {
    if (_showResult) return;
    setState(() {
      _selectedAnswer = index;
    });
  }

  void _submitAnswer() {
    if (_selectedAnswer == null) return;
    final correct = _selectedAnswer == _questions![_currentIndex].correctIndex;
    setState(() {
      _showResult = true;
      _answerResults[_currentIndex] = correct;
      if (correct) _correctCount++;
    });
  }

  void _nextQuestion() {
    if (_currentIndex < _questions!.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedAnswer = null;
        _showResult = false;
      });
    } else {
      setState(() => _quizComplete = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.quizIds.isEmpty) {
      return const EmptyState(
        title: 'No quiz available',
        subtitle: 'A quiz for this lesson is being prepared.',
        icon: Icons.quiz_outlined,
      );
    }

    if (_questions != null) {
      if (_quizComplete) {
        return _buildResults();
      }
      return _buildQuizQuestion();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Knowledge Check',
            style: ClarityTypography.headlineMedium),
        const SizedBox(height: 8),
        Text('Test your understanding of this lesson.',
            style: ClarityTypography.bodyMedium.copyWith(
                color: ClarityColors.textSecondary)),
        const SizedBox(height: 16),
        ...widget.lesson.quizIds.map((quizId) => ClarityCard(
              onTap: () => _startQuiz(quizId),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ClarityColors.primary
                          .withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: const Icon(
                        Icons.quiz_outlined,
                        size: 22,
                        color: ClarityColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Start Quiz',
                            style:
                                ClarityTypography
                                    .titleSmall),
                        Text('5 questions',
                            style:
                                ClarityTypography
                                    .labelSmall
                                    .copyWith(
                                        color:
                                            ClarityColors
                                                .textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward,
                      color: ClarityColors.primary),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildQuizQuestion() {
    if (_loading) {
      return const ClarityLoadingIndicator(message: 'Loading quiz...');
    }
    final question = _questions![_currentIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Question ${_currentIndex + 1} of ${_questions!.length}',
                style: ClarityTypography.titleMedium),
            const Spacer(),
            Text('${_correctCount}/${_currentIndex}',
                style: ClarityTypography.bodySmall.copyWith(
                    color: ClarityColors.textSecondary)),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: (_currentIndex + 1) / _questions!.length,
          backgroundColor: ClarityColors.divider,
          valueColor:
              const AlwaysStoppedAnimation(ClarityColors.primary),
        ),
        const SizedBox(height: 24),
        Text(question.question,
            style: ClarityTypography.titleLarge),
        const SizedBox(height: 16),
        ...question.options.asMap().entries.map((entry) {
          final idx = entry.key;
          final option = entry.value;
          Color? bgColor;
          Color? borderColor;
          if (_showResult) {
            if (idx == question.correctIndex) {
              bgColor = Colors.green.withOpacity(0.1);
              borderColor = Colors.green;
            } else if (idx == _selectedAnswer) {
              bgColor = Colors.red.withOpacity(0.1);
              borderColor = Colors.red;
            }
          } else if (idx == _selectedAnswer) {
            bgColor = ClarityColors.primary.withOpacity(0.1);
            borderColor = ClarityColors.primary;
          }
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: bgColor ?? ClarityColors.surfaceAlt,
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _showResult ? null : () => _selectAnswer(idx),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: borderColor != null
                        ? Border.all(color: borderColor)
                        : null,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: idx == _selectedAnswer
                              ? ClarityColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: idx == _selectedAnswer
                                ? ClarityColors.primary
                                : ClarityColors.textTertiary,
                          ),
                        ),
                        child: Center(
                          child: Text('${String.fromCharCode(65 + idx)}',
                              style: TextStyle(
                                color: idx == _selectedAnswer
                                    ? Colors.white
                                    : ClarityColors.textTertiary,
                                fontWeight: FontWeight.w600,
                              )),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(option,
                            style: ClarityTypography.bodyLarge),
                      ),
                      if (_showResult && idx == question.correctIndex)
                        const Icon(Icons.check_circle,
                            color: Colors.green, size: 22),
                      if (_showResult &&
                          idx == _selectedAnswer &&
                          idx != question.correctIndex)
                        const Icon(Icons.cancel,
                            color: Colors.red, size: 22),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        if (_showResult && question.explanation != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: ClarityColors.info.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline,
                    size: 18, color: ClarityColors.info),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(question.explanation!,
                      style: ClarityTypography.bodyMedium),
                ),
              ],
            ),
          ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _showResult
                ? _nextQuestion
                : (_selectedAnswer != null ? _submitAnswer : null),
            child: Text(_showResult
                ? (_currentIndex < _questions!.length - 1
                    ? 'Next Question'
                    : 'See Results')
                : 'Submit Answer'),
          ),
        ),
      ],
    );
  }

  Widget _buildResults() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 24),
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _correctCount >= _questions!.length / 2
                ? Colors.green.withOpacity(0.1)
                : Colors.orange.withOpacity(0.1),
          ),
          child: Center(
            child: Text('$_correctCount/${_questions!.length}',
                style: ClarityTypography.headlineLarge.copyWith(
                  color: _correctCount >= _questions!.length / 2
                      ? Colors.green
                      : Colors.orange,
                )),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _correctCount == _questions!.length
              ? 'Perfect Score!'
              : _correctCount >= _questions!.length / 2
                  ? 'Good Job!'
                  : 'Keep Practicing!',
          style: ClarityTypography.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          'You got $_correctCount out of ${_questions!.length} questions correct.',
          style: ClarityTypography.bodyMedium.copyWith(
              color: ClarityColors.textSecondary),
        ),
        const SizedBox(height: 24),
        Column(
          children: _answerResults.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                children: [
                  Icon(
                    entry.value == true
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: entry.value == true
                        ? Colors.green
                        : Colors.red,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text('Question ${entry.key + 1}',
                      style: ClarityTypography.bodyMedium),
                ],
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {
              setState(() {
                _questions = null;
                _currentIndex = 0;
                _selectedAnswer = null;
                _showResult = false;
                _correctCount = 0;
                _quizComplete = false;
              });
            },
            child: const Text('Try Again'),
          ),
        ),
      ],
    );
  }
}

class _ExercisesSection extends StatefulWidget {
  final dynamic lesson;
  final LessonProvider provider;

  const _ExercisesSection(
      {required this.lesson, required this.provider});

  @override
  State<_ExercisesSection> createState() => _ExercisesSectionState();
}

class _ExercisesSectionState extends State<_ExercisesSection> {
  List<dynamic>? _exercises;
  int? _expandedIndex;
  Set<int> _revealedHints = {};
  bool _showSolution = false;
  bool _loading = false;

  Future<void> _loadExercises() async {
    setState(() => _loading = true);
    await widget.provider.loadExercises(widget.lesson.id);
    if (mounted) {
      setState(() {
        _exercises = List.from(widget.provider.exercises);
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lesson.exerciseIds.isEmpty) {
      return const EmptyState(
        title: 'No exercises available',
        subtitle:
            'Practice exercises are being prepared for this lesson.',
        icon: Icons.code_outlined,
      );
    }

    if (_exercises != null) {
      return _buildExerciseList();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Practice Exercises',
            style: ClarityTypography.headlineMedium),
        const SizedBox(height: 8),
        Text('Practice what you\'ve learned.',
            style: ClarityTypography.bodyMedium.copyWith(
                color: ClarityColors.textSecondary)),
        const SizedBox(height: 16),
        ...widget.lesson.exerciseIds.map((exId) => ClarityCard(
              onTap: _loadExercises,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: ClarityColors.accent
                          .withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(10),
                    ),
                    child: const Icon(
                        Icons.code_outlined,
                        size: 22,
                        color: ClarityColors.accent),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text('Practice Exercises',
                            style:
                                ClarityTypography
                                    .titleSmall),
                        Text('Interactive practice',
                            style:
                                ClarityTypography
                                    .labelSmall
                                    .copyWith(
                                        color:
                                            ClarityColors
                                                .textSecondary)),
                      ],
                    ),
                  ),
                  const Icon(Icons.arrow_forward,
                      color: ClarityColors.accent),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildExerciseList() {
    if (_loading) {
      return const ClarityLoadingIndicator(message: 'Loading exercises...');
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _exercises!.length,
      itemBuilder: (context, index) {
        final ex = _exercises![index];
        final expanded = _expandedIndex == index;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ClarityCard(
            onTap: () {
              setState(() {
                _expandedIndex = expanded ? null : index;
                _revealedHints = {};
                _showSolution = false;
              });
            },
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: ClarityColors.accent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.code_outlined,
                          size: 18, color: ClarityColors.accent),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(ex.title,
                          style: ClarityTypography.titleMedium),
                    ),
                    Icon(
                      expanded ? Icons.expand_less : Icons.expand_more,
                      color: ClarityColors.textSecondary,
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: 12),
                  Text('Instructions',
                      style: ClarityTypography.titleSmall),
                  const SizedBox(height: 4),
                  Text(ex.instructions,
                      style: ClarityTypography.bodyMedium),
                  if (ex.hints.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.lightbulb_outline,
                            size: 16, color: ClarityColors.info),
                        const SizedBox(width: 6),
                        Text('Hints',
                            style: ClarityTypography.titleSmall),
                        const Spacer(),
                        if (_revealedHints.length < ex.hints.length)
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _revealedHints.add(_revealedHints.length);
                              });
                            },
                            child: const Text('Show Hint'),
                          ),
                      ],
                    ),
                    ..._revealedHints.map((i) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: ClarityColors.info.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: ClarityColors.info.withOpacity(0.2)),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${i + 1}. ',
                                    style: ClarityTypography.bodyMedium
                                        .copyWith(fontWeight: FontWeight.w600)),
                                Expanded(
                                  child: Text(ex.hints[i],
                                      style: ClarityTypography.bodyMedium),
                                ),
                              ],
                            ),
                          ),
                        )),
                  ],
                  const SizedBox(height: 16),
                  if (ex.solution.isNotEmpty)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          setState(() => _showSolution = !_showSolution);
                        },
                        icon: Icon(
                          _showSolution
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          size: 18,
                        ),
                        label: Text(
                            _showSolution ? 'Hide Solution' : 'Show Solution'),
                      ),
                    ),
                  if (_showSolution && ex.solution.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: Colors.green.withOpacity(0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Solution',
                              style: ClarityTypography.titleSmall.copyWith(
                                  color: Colors.green)),
                          const SizedBox(height: 8),
                          Text(ex.solution,
                              style: ClarityTypography.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RevisionSection extends StatelessWidget {
  final dynamic lesson;

  const _RevisionSection({required this.lesson});

  @override
  Widget build(BuildContext context) {
    if (lesson.revisionSummary.isEmpty) {
      return const EmptyState(
        title: 'No revision summary',
        subtitle:
            'A revision summary will be available soon.',
        icon: Icons.summarize_outlined,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Revision Summary',
            style: ClarityTypography.headlineMedium),
        const SizedBox(height: 16),
        MarkdownBody(
          data: lesson.revisionSummary,
          styleSheet: MarkdownStyleSheet(
            p: ClarityTypography.bodyLarge,
            h1: ClarityTypography.headlineLarge,
            h2: ClarityTypography.headlineMedium,
            h3: ClarityTypography.headlineSmall,
          ),
        ),
      ],
    );
  }
}

class _AIHelpSection extends StatelessWidget {
  final dynamic lesson;

  const _AIHelpSection({required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: ClarityColors.primaryGradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text('ClarityBuddy AI Help',
                style: ClarityTypography.headlineMedium),
          ],
        ),
        const SizedBox(height: 16),
        Text(
            'Ask ClarityBuddy anything about this lesson. I can explain concepts, simplify content, or generate practice questions.',
            style: ClarityTypography.bodyMedium.copyWith(
                color: ClarityColors.textSecondary)),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: () => context.go('/ai-assistant'),
            icon: const Icon(Icons.chat_outlined, size: 18),
            label: const Text('Open AI Chat'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              final aiProvider =
                  context.read<AIProvider>();
              final summary = await aiProvider
                  .generateSummary(
                      lesson.notes.isNotEmpty
                          ? lesson.notes
                          : lesson.overview);
              if (summary.isNotEmpty && context.mounted) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('AI Summary'),
                    content: SingleChildScrollView(
                      child: Text(summary),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(ctx),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.summarize_outlined,
                size: 18),
            label: const Text('Generate Summary'),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              final aiProvider =
                  context.read<AIProvider>();
              final explanation = await aiProvider
                  .generateExplanation(lesson.title);
              if (explanation.isNotEmpty &&
                  context.mounted) {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title:
                        const Text('AI Explanation'),
                    content: SingleChildScrollView(
                      child: Text(explanation),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () =>
                            Navigator.pop(ctx),
                        child: const Text('Close'),
                      ),
                    ],
                  ),
                );
              }
            },
            icon: const Icon(Icons.psychology_outlined,
                size: 18),
            label: const Text('Explain This Lesson'),
          ),
        ),
      ],
    );
  }
}
