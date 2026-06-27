import 'package:flutter/material.dart';
import '../../models/user_progress.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<RecentActivity> activities;

  const RecentActivityWidget({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('No recent activity yet. Start learning!',
              style: ClarityTypography.bodySmall
                  .copyWith(color: ClarityColors.textTertiary)),
        ),
      );
    }

    return Column(
      children: activities.take(5).map((activity) {
        return _ActivityItem(activity: activity);
      }).toList(),
    );
  }
}

class _ActivityItem extends StatelessWidget {
  final RecentActivity activity;

  const _ActivityItem({required this.activity});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _getIconColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(_getIcon(), size: 18, color: _getIconColor()),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(activity.title,
                    style: ClarityTypography.titleSmall),
                Text(activity.activityType.replaceAll('_', ' '),
                    style: ClarityTypography.labelSmall.copyWith(
                        color: ClarityColors.textTertiary)),
              ],
            ),
          ),
          Text(
            _formatTime(activity.timestamp),
            style: ClarityTypography.labelSmall.copyWith(
                color: ClarityColors.textTertiary),
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (activity.activityType) {
      case 'lesson_completed':
        return Icons.check_circle_outline;
      case 'quiz_completed':
        return Icons.quiz_outlined;
      case 'exercise_completed':
        return Icons.code_outlined;
      case 'video_watched':
        return Icons.play_circle_outline;
      default:
        return Icons.access_time_outlined;
    }
  }

  Color _getIconColor() {
    switch (activity.activityType) {
      case 'lesson_completed':
        return ClarityColors.success;
      case 'quiz_completed':
        return ClarityColors.primary;
      case 'exercise_completed':
        return ClarityColors.accent;
      case 'video_watched':
        return ClarityColors.info;
      default:
        return ClarityColors.textSecondary;
    }
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
