import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../utils/colors.dart';
import '../utils/typography.dart';
import '../utils/constants.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/error_state.dart';
import '../widgets/course/course_card.dart';

class CourseSelectionScreen extends StatefulWidget {
  const CourseSelectionScreen({super.key});

  @override
  State<CourseSelectionScreen> createState() =>
      _CourseSelectionScreenState();
}

class _CourseSelectionScreenState extends State<CourseSelectionScreen> {
  String _selectedCategory = '';

  final _categories = [
    {'id': '', 'label': 'All', 'icon': Icons.explore_outlined},
    {'id': 'cbse', 'label': 'CBSE', 'icon': Icons.school_outlined},
    {'id': 'icse', 'label': 'ICSE', 'icon': Icons.library_books_outlined},
    {
      'id': 'competitive_exams',
      'label': 'Competitive',
      'icon': Icons.emoji_events_outlined
    },
    {
      'id': 'skill_learning',
      'label': 'Skills',
      'icon': Icons.rocket_launch_outlined
    },
    {'id': 'custom', 'label': 'Custom', 'icon': Icons.edit_outlined},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CourseProvider>().loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Path',
            style: ClarityTypography.headlineMedium),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
            child: Text(
              'Select a learning track that matches your goals.',
              style: ClarityTypography.bodyMedium.copyWith(
                  color: ClarityColors.textSecondary),
            ),
          ),
          SizedBox(
            height: 44,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isActive = _selectedCategory == cat['id'];
                return FilterChip(
                  selected: isActive,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(cat['icon'] as IconData,
                          size: 16,
                          color: isActive
                              ? ClarityColors.primary
                              : ClarityColors.textSecondary),
                      const SizedBox(width: 6),
                      Text(cat['label'] as String),
                    ],
                  ),
                  onSelected: (selected) {
                    setState(() {
                      _selectedCategory =
                          selected ? cat['id'] as String : '';
                    });
                    courseProvider
                        .setCategory(_selectedCategory);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildContent(courseProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(CourseProvider provider) {
    if (provider.isLoading) {
      return const ClarityLoadingIndicator(
          message: 'Loading courses...');
    }

    if (provider.error != null) {
      return ErrorState(
        message: provider.error!,
        onRetry: () => provider.loadCourses(),
      );
    }

    final courses = provider.courses;

    if (courses.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.school_outlined,
                  size: 64, color: ClarityColors.primaryLight),
              const SizedBox(height: 16),
              Text('No courses available yet',
                  style: ClarityTypography.titleLarge),
              const SizedBox(height: 8),
              Text('New courses are being added. Check back soon!',
                  style: ClarityTypography.bodySmall.copyWith(
                      color: ClarityColors.textSecondary)),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final course = courses[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CourseCard(
            course: course,
            onTap: () {
              context
                  .read<CourseProvider>()
                  .selectCourse(course.id);
              context.go('/subjects/${course.id}');
            },
          ),
        );
      },
    );
  }
}
