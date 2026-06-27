import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../utils/colors.dart';
import '../utils/typography.dart';
import '../utils/responsive.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_state.dart';
import '../widgets/common/clarity_card.dart';
import '../widgets/course/subject_card.dart';

class SubjectScreen extends StatefulWidget {
  final String courseId;

  const SubjectScreen({super.key, required this.courseId});

  @override
  State<SubjectScreen> createState() => _SubjectScreenState();
}

class _SubjectScreenState extends State<SubjectScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().selectCourse(widget.courseId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();
    final course = courseProvider.selectedCourse;
    final subjects = courseProvider.subjects;
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(course?.title ?? 'Course',
            style: ClarityTypography.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildContent(courseProvider, subjects, isDesktop),
    );
  }

  Widget _buildContent(CourseProvider provider, List<dynamic> subjects,
      bool isDesktop) {
    if (provider.isLoading) {
      return const ClarityLoadingIndicator(
          message: 'Loading subjects...');
    }

    if (provider.error != null) {
      return ErrorState(
        message: provider.error!,
        onRetry: () =>
            provider.selectCourse(widget.courseId),
      );
    }

    if (subjects.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.menu_book_outlined,
                size: 64, color: ClarityColors.primaryLight),
            const SizedBox(height: 16),
            Text('No subjects available yet',
                style: ClarityTypography.titleLarge),
            const SizedBox(height: 8),
            Text('Subjects are being added for this course.',
                style: ClarityTypography.bodySmall.copyWith(
                    color: ClarityColors.textSecondary)),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 48 : 24),
      child: ConstrainedBox(
        constraints:
            const BoxConstraints(maxWidth: 1200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Choose a Subject',
                style: ClarityTypography.displaySmall),
            const SizedBox(height: 4),
            Text(
                'Select a subject to start learning.',
                style: ClarityTypography.bodyMedium.copyWith(
                    color: ClarityColors.textSecondary)),
            const SizedBox(height: 24),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    isDesktop ? 3 : 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return SubjectCard(
                  title: subject.title,
                  description: subject.description,
                  icon: _getSubjectIcon(subject.title),
                  color: _getSubjectColor(index),
                  lessonCount: subject.unitIds.length,
                  onTap: () {
                    provider.selectSubject(subject.id);
                    _showUnitsSheet(context, provider,
                        subject.id, subject.title);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUnitsSheet(BuildContext context,
      CourseProvider provider, String subjectId, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _UnitsSheet(
        provider: provider,
        subjectTitle: title,
        onUnitTap: (unitId) {
          Navigator.pop(context);
          provider.selectUnit(unitId);
        },
        onLessonTap: (lessonId) {
          Navigator.pop(context);
          context.go('/lesson/$lessonId');
        },
      ),
    );
  }

  IconData _getSubjectIcon(String title) {
    final t = title.toLowerCase();
    if (t.contains('math')) return Icons.functions_outlined;
    if (t.contains('science') || t.contains('physics') ||
        t.contains('chemistry') || t.contains('biology'))
      return Icons.science_outlined;
    if (t.contains('english') || t.contains('language'))
      return Icons.translate_outlined;
    if (t.contains('history') || t.contains('social'))
      return Icons.public_outlined;
    if (t.contains('art') || t.contains('music'))
      return Icons.palette_outlined;
    if (t.contains('computer') || t.contains('programming'))
      return Icons.computer_outlined;
    return Icons.menu_book_outlined;
  }

  Color _getSubjectColor(int index) {
    final colors = [
      ClarityColors.primary,
      ClarityColors.secondary,
      ClarityColors.accent,
      ClarityColors.info,
      Colors.purple,
      Colors.teal,
    ];
    return colors[index % colors.length];
  }
}

class _UnitsSheet extends StatefulWidget {
  final CourseProvider provider;
  final String subjectTitle;
  final ValueChanged<String> onUnitTap;
  final ValueChanged<String> onLessonTap;

  const _UnitsSheet({
    required this.provider,
    required this.subjectTitle,
    required this.onUnitTap,
    required this.onLessonTap,
  });

  @override
  State<_UnitsSheet> createState() => _UnitsSheetState();
}

class _UnitsSheetState extends State<_UnitsSheet> {
  @override
  Widget build(BuildContext context) {
    final units = widget.provider.units;
    final lessons = widget.provider.lessons;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: ClarityColors.background,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ClarityColors.divider,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(widget.subjectTitle,
                style: ClarityTypography.headlineMedium),
          ),
          Expanded(
            child: units.isEmpty
                ? Center(
                    child: Text('No units available',
                        style: ClarityTypography.bodyMedium
                            .copyWith(
                                color: ClarityColors
                                    .textSecondary)),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: units.length,
                    itemBuilder: (context, index) {
                      final unit = units[index];
                      return ClarityCard(
                        onTap: () =>
                            widget.onUnitTap(unit.id),
                        padding:
                            const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding:
                                      const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color:
                                        ClarityColors.primary
                                            .withOpacity(0.1),
                                    borderRadius:
                                        BorderRadius.circular(
                                            8),
                                  ),
                                  child: const Icon(
                                      Icons
                                          .folder_outlined,
                                      size: 18,
                                      color:
                                          ClarityColors
                                              .primary),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                      unit.title,
                                      style:
                                          ClarityTypography
                                              .titleMedium),
                                ),
                                Icon(
                                    Icons.chevron_right,
                                    size: 20,
                                    color: ClarityColors
                                        .textTertiary),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
