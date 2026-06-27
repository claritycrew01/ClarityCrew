import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';
import '../common/clarity_card.dart';

class LessonCard extends StatelessWidget {
  final String title;
  final String description;
  final int estimatedMinutes;
  final String difficulty;
  final bool completed;
  final double? score;
  final VoidCallback? onTap;

  const LessonCard({
    super.key,
    required this.title,
    required this.description,
    this.estimatedMinutes = 15,
    this.difficulty = 'beginner',
    this.completed = false,
    this.score,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final difficultyColor = _getDifficultyColor(difficulty);

    return ClarityCard(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: completed
                  ? ClarityColors.success.withOpacity(0.15)
                  : ClarityColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              completed ? Icons.check_circle_outline : Icons.play_circle_outline,
              color: completed ? ClarityColors.success : ClarityColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: ClarityTypography.titleMedium),
                const SizedBox(height: 4),
                Text(description,
                    style: ClarityTypography.bodySmall.copyWith(
                        color: ClarityColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(difficulty,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: difficultyColor,
                    )),
              ),
              const SizedBox(height: 4),
              Text('$estimatedMinutes min',
                  style: ClarityTypography.labelSmall.copyWith(
                      color: ClarityColors.textTertiary)),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'beginner':
      case 'easy':
        return ClarityColors.success;
      case 'medium':
        return ClarityColors.warning;
      case 'hard':
      case 'advanced':
        return ClarityColors.error;
      default:
        return ClarityColors.textSecondary;
    }
  }
}
