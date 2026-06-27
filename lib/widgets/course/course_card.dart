import 'package:flutter/material.dart';
import '../../models/course.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';
import '../common/clarity_card.dart';

class CourseCard extends StatelessWidget {
  final Course course;
  final VoidCallback? onTap;
  final double? progress;

  const CourseCard({
    super.key,
    required this.course,
    this.onTap,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final color = course.colorHex != null
        ? Color(int.parse(course.colorHex!.replaceFirst('#', '0xFF')))
        : ClarityColors.primary;

    return ClarityCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withOpacity(0.1),
                  color.withOpacity(0.05),
                ],
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _getCategoryIcon(course.category),
                    color: color,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(course.title,
                          style: ClarityTypography.titleLarge),
                      const SizedBox(height: 4),
                      Text(course.description,
                          style: ClarityTypography.bodySmall
                              .copyWith(color: ClarityColors.textSecondary),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
            child: Row(
              children: [
                _InfoChip(
                    label: _getCategoryLabel(course.category),
                    color: color),
                const SizedBox(width: 8),
                _InfoChip(
                    label: course.difficulty,
                    color: ClarityColors.textSecondary),
                const Spacer(),
                Text('${course.subjectIds.length} subjects',
                    style: ClarityTypography.labelSmall
                        .copyWith(color: ClarityColors.textTertiary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'cbse':
        return Icons.school_outlined;
      case 'icse':
        return Icons.library_books_outlined;
      case 'competitive_exams':
        return Icons.trophy_outlined;
      case 'skill_learning':
        return Icons.rocket_launch_outlined;
      default:
        return Icons.explore_outlined;
    }
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'cbse':
        return 'CBSE';
      case 'icse':
        return 'ICSE';
      case 'competitive_exams':
        return 'Competitive';
      case 'skill_learning':
        return 'Skills';
      default:
        return 'General';
    }
  }
}

class _InfoChip extends StatelessWidget {
  final String label;
  final Color color;

  const _InfoChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          )),
    );
  }
}
