import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';
import '../common/clarity_card.dart';

class ProgressOverview extends StatelessWidget {
  final int completedLessons;
  final int streak;
  final double averageScore;
  final int totalMinutes;

  const ProgressOverview({
    super.key,
    this.completedLessons = 0,
    this.streak = 0,
    this.averageScore = 0.0,
    this.totalMinutes = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: _StatCard(
                label: 'Lessons',
                value: '$completedLessons',
                icon: Icons.check_circle_outline,
                color: ClarityColors.success)),
        const SizedBox(width: 10),
        Expanded(
            child: _StatCard(
                label: 'Streak',
                value: '$streak days',
                icon: Icons.local_fire_department_outlined,
                color: ClarityColors.warning)),
        const SizedBox(width: 10),
        Expanded(
            child: _StatCard(
                label: 'Avg Score',
                value: '${averageScore.round()}%',
                icon: Icons.trending_up,
                color: ClarityColors.primary)),
        const SizedBox(width: 10),
        Expanded(
            child: _StatCard(
                label: 'Time',
                value: '$totalMinutes min',
                icon: Icons.access_time_outlined,
                color: ClarityColors.info)),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ClarityCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 10),
          Text(value,
              style: ClarityTypography.headlineSmall.copyWith(
                  color: ClarityColors.textPrimary)),
          Text(label,
              style: ClarityTypography.labelSmall.copyWith(
                  color: ClarityColors.textSecondary)),
        ],
      ),
    );
  }
}
