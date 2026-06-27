import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/progress_provider.dart';
import '../providers/auth_provider.dart';
import '../providers/course_provider.dart';
import '../utils/colors.dart';
import '../utils/typography.dart';
import '../widgets/common/clarity_card.dart';
import '../widgets/common/progress_bar.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProgress();
    });
  }

  void _loadProgress() {
    final auth = context.read<AuthProvider>();
    final courses = context.read<CourseProvider>().courses;
    if (auth.userId != null && courses.isNotEmpty) {
      context.read<ProgressProvider>().loadProgress(
          auth.userId!, courses.first.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = context.watch<ProgressProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Progress',
            style: ClarityTypography.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _StreakCard(streak: progressProvider.streak),
              const SizedBox(height: 20),
              Text('Learning Stats',
                  style: ClarityTypography.headlineMedium),
              const SizedBox(height: 12),
              _StatsGrid(provider: progressProvider),
              const SizedBox(height: 24),
              Text('Recent Activity',
                  style: ClarityTypography.headlineMedium),
              const SizedBox(height: 12),
              _ActivityList(
                  activities: progressProvider.recentActivity),
              const SizedBox(height: 24),
              Text('Course Progress',
                  style: ClarityTypography.headlineMedium),
              const SizedBox(height: 12),
              _CourseProgressList(
                  provider: progressProvider),
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;

  const _StreakCard({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [ClarityColors.primary, Color(0xFF3550A0)],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ClarityColors.primary.withOpacity(0.3),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.local_fire_department,
              size: 48, color: Colors.white),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$streak',
                  style: ClarityTypography.displayLarge.copyWith(
                      color: Colors.white)),
              Text('Day Streak',
                  style: ClarityTypography.bodyLarge.copyWith(
                      color: Colors.white.withOpacity(0.8))),
            ],
          ),
          const Spacer(),
          Text(
            streak > 0 ? 'Keep going! 🔥' : 'Start today!',
            style: ClarityTypography.bodyMedium.copyWith(
                color: Colors.white.withOpacity(0.9)),
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final ProgressProvider provider;

  const _StatsGrid({required this.provider});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _StatTile(
                label: 'Lessons Done',
                value: '${provider.getCompletedLessons()}',
                icon: Icons.check_circle_outline,
                color: ClarityColors.success)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatTile(
                label: 'Avg Score',
                value: '${provider.getAverageScore().round()}%',
                icon: Icons.trending_up,
                color: ClarityColors.primary)),
        const SizedBox(width: 12),
        Expanded(
            child: _StatTile(
                label: 'Activities',
                value: '${provider.recentActivity.length}',
                icon: Icons.history,
                color: ClarityColors.info)),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClarityCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: 12),
          Text(value,
              style: ClarityTypography.displaySmall),
          Text(label,
              style: ClarityTypography.labelMedium.copyWith(
                  color: ClarityColors.textSecondary)),
        ],
      ),
    );
  }
}

class _ActivityList extends StatelessWidget {
  final List<dynamic> activities;

  const _ActivityList({required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return ClarityCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('No activity yet. Start learning!',
                style: ClarityTypography.bodyMedium.copyWith(
                    color: ClarityColors.textSecondary)),
          ),
        ),
      );
    }

    return Column(
      children: activities.map((a) {
        return ClarityCard(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(Icons.check_circle,
                  size: 18, color: ClarityColors.success),
              const SizedBox(width: 12),
              Expanded(
                child: Text(a.title,
                    style: ClarityTypography.titleSmall),
              ),
              Text(
                _formatDate(a.timestamp),
                style: ClarityTypography.labelSmall.copyWith(
                    color: ClarityColors.textTertiary),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}

class _CourseProgressList extends StatelessWidget {
  final ProgressProvider provider;

  const _CourseProgressList({required this.provider});

  @override
  Widget build(BuildContext context) {
    final progress = provider.progressList;
    if (progress.isEmpty) {
      return ClarityCard(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Text('No course progress yet.',
                style: ClarityTypography.bodyMedium.copyWith(
                    color: ClarityColors.textSecondary)),
          ),
        ),
      );
    }

    return Column(
      children: progress.take(10).map((p) {
        return ClarityCard(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    p.completed
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    size: 18,
                    color: p.completed
                        ? ClarityColors.success
                        : ClarityColors.textTertiary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text('Lesson ${p.lessonId ?? ''}',
                        style: ClarityTypography.titleSmall),
                  ),
                  if (p.score > 0)
                    Text('${p.score.round()}%',
                        style:
                            ClarityTypography.labelLarge.copyWith(
                                color: ClarityColors.primary)),
                ],
              ),
              if (p.timeSpentMinutes > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: 28),
                  child: Text('${p.timeSpentMinutes} min spent',
                      style: ClarityTypography.labelSmall
                          .copyWith(
                              color: ClarityColors.textTertiary)),
                ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
