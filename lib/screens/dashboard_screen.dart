import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/course_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/accessibility_provider.dart';
import '../utils/colors.dart';
import '../utils/typography.dart';
import '../utils/responsive.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/common/clarity_card.dart';
import '../widgets/dashboard/continue_learning_card.dart';
import '../widgets/dashboard/progress_overview.dart';
import '../widgets/dashboard/recent_activity.dart';
import '../widgets/dashboard/recommended_section.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }

  void _loadData() {
    final auth = context.read<AuthProvider>();
    final courseProvider = context.read<CourseProvider>();
    final progressProvider = context.read<ProgressProvider>();

    if (courseProvider.courses.isEmpty) {
      courseProvider.loadCourses();
    }

    if (auth.userId != null && courseProvider.courses.isNotEmpty) {
      progressProvider.loadProgress(
          auth.userId!, courseProvider.courses.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final courseProvider = context.watch<CourseProvider>();
    final progressProvider = context.watch<ProgressProvider>();
    final accessibility = context.watch<AccessibilityProvider>();
    final isDesktop = ResponsiveUtils.isDesktop(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _DashboardAppBar(
              userName: auth.user?.displayName ?? 'Learner',
              onMenuTap: () => _showDrawer(context),
              onAITap: () => context.go('/ai-assistant'),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 48 : 24,
                  vertical: 16,
                ),
                child: ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 1200),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      _WelcomeSection(
                          userName:
                              auth.user?.displayName ?? 'Learner'),
                      const SizedBox(height: 20),
                      if (courseProvider.courses.isNotEmpty)
                        ContinueLearningCard(
                          courseTitle:
                              courseProvider.courses.first.title,
                          lessonTitle:
                              'Continue where you left off',
                          progress:
                              progressProvider.getCourseProgress(
                                  courseProvider
                                      .courses.first.id),
                          onTap: () => context.go(
                              '/subjects/${courseProvider.courses.first.id}'),
                        ),
                      const SizedBox(height: 24),
                      ProgressOverview(
                        completedLessons:
                            progressProvider
                                .getCompletedLessons(),
                        streak: progressProvider.streak,
                        averageScore:
                            progressProvider.getAverageScore(),
                        totalMinutes: 120,
                      ),
                      const SizedBox(height: 28),
                      _SectionHeader(
                        title: 'Your Courses',
                        action: TextButton(
                          onPressed: () =>
                              context.go('/courses'),
                          child: const Text('Browse All'),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CourseList(
                          courses: courseProvider.courses),
                      const SizedBox(height: 28),
                      _SectionHeader(
                          title: 'Recent Activity'),
                      const SizedBox(height: 12),
                      RecentActivityWidget(
                          activities:
                              progressProvider.recentActivity),
                      const SizedBox(height: 28),
                      if (progressProvider
                          .recommendations.isNotEmpty) ...[
                        _SectionHeader(
                            title: 'Recommended for You'),
                        const SizedBox(height: 12),
                        RecommendedSection(
                          recommendations:
                              progressProvider
                                  .recommendations,
                        ),
                      ],
                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }
}

class _DashboardAppBar extends StatelessWidget {
  final String userName;
  final VoidCallback onMenuTap;
  final VoidCallback onAITap;

  const _DashboardAppBar({
    required this.userName,
    required this.onMenuTap,
    required this.onAITap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: ClarityColors.surface,
        boxShadow: [
          BoxShadow(
            color: ClarityColors.cardShadow,
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu_outlined),
            onPressed: onMenuTap,
            style: IconButton.styleFrom(
              backgroundColor: ClarityColors.surfaceAlt,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text('Dashboard',
                style: ClarityTypography.headlineMedium),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: ClarityColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 20),
              onPressed: onAITap,
              tooltip: 'AI Assistant',
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeSection extends StatelessWidget {
  final String userName;

  const _WelcomeSection({required this.userName});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$greeting, $userName 👋',
            style: ClarityTypography.displaySmall),
        const SizedBox(height: 4),
        Text('Ready to learn something new today?',
            style: ClarityTypography.bodyMedium.copyWith(
                color: ClarityColors.textSecondary)),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;

  const _SectionHeader({required this.title, this.action});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: ClarityTypography.headlineSmall),
        const Spacer(),
        if (action != null) action!,
      ],
    );
  }
}

class _CourseList extends StatelessWidget {
  final List<dynamic> courses;

  const _CourseList({required this.courses});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: courses.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final course = courses[index];
          return GestureDetector(
            onTap: () =>
                context.go('/subjects/${course.id}'),
            child: Container(
              width: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: ClarityColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                    color: ClarityColors.divider, width: 0.5),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(Icons.school_outlined,
                      color: ClarityColors.primary, size: 24),
                  const Spacer(),
                  Text(course.title,
                      style: ClarityTypography.titleSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
