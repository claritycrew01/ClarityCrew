import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';

class LessonSectionTab extends StatelessWidget {
  final String id;
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback? onTap;

  const LessonSectionTab({
    super.key,
    required this.id,
    required this.label,
    required this.icon,
    required this.isActive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isActive
              ? ClarityColors.primary.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isActive
              ? Border.all(color: ClarityColors.primary.withOpacity(0.2))
              : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? ClarityColors.primary : ClarityColors.textTertiary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: ClarityTypography.labelMedium.copyWith(
                color: isActive ? ClarityColors.primary : ClarityColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonSectionTabs extends StatelessWidget {
  final String activeSection;
  final ValueChanged<String> onSectionChanged;

  static const sections = [
    {'id': 'overview', 'label': 'Overview', 'icon': Icons.explore_outlined},
    {'id': 'notes', 'label': 'Notes', 'icon': Icons.article_outlined},
    {'id': 'video', 'label': 'Video', 'icon': Icons.play_circle_outline},
    {'id': 'quiz', 'label': 'Quiz', 'icon': Icons.quiz_outlined},
    {'id': 'exercises', 'label': 'Exercises', 'icon': Icons.code_outlined},
    {'id': 'revision', 'label': 'Revision', 'icon': Icons.summarize_outlined},
    {'id': 'ai_help', 'label': 'AI Help', 'icon': Icons.auto_awesome_outlined},
  ];

  const LessonSectionTabs({
    super.key,
    required this.activeSection,
    required this.onSectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: ClarityColors.surfaceAlt,
        borderRadius: BorderRadius.circular(14),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: sections.map((section) {
            return Padding(
              padding: const EdgeInsets.only(right: 4),
              child: LessonSectionTab(
                id: section['id'] as String,
                label: section['label'] as String,
                icon: section['icon'] as IconData,
                isActive: activeSection == section['id'],
                onTap: () => onSectionChanged(section['id'] as String),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
