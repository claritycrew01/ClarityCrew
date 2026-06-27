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
        return _QuizSection(lesson: lesson);
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

class _QuizSection extends StatelessWidget {
  final dynamic lesson;

  const _QuizSection({required this.lesson});

  @override
  Widget build(BuildContext context) {
    if (lesson.quizIds.isEmpty) {
      return const EmptyState(
        title: 'No quiz available',
        subtitle: 'A quiz for this lesson is being prepared.',
        icon: Icons.quiz_outlined,
      );
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
        ...lesson.quizIds.map((quizId) => ClarityCard(
              onTap: () {
                // Launch quiz
              },
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
}

class _ExercisesSection extends StatelessWidget {
  final dynamic lesson;
  final LessonProvider provider;

  const _ExercisesSection(
      {required this.lesson, required this.provider});

  @override
  Widget build(BuildContext context) {
    if (lesson.exerciseIds.isEmpty) {
      return const EmptyState(
        title: 'No exercises available',
        subtitle:
            'Practice exercises are being prepared for this lesson.',
        icon: Icons.code_outlined,
      );
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
        ...lesson.exerciseIds.map((exId) => ClarityCard(
              onTap: () {
                // Launch exercise
              },
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
                        Text('Practice Exercise',
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
