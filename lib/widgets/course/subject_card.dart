import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';
import '../common/clarity_card.dart';

class SubjectCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final int lessonCount;
  final VoidCallback? onTap;

  const SubjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.lessonCount = 0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClarityCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 16),
            Text(title, style: ClarityTypography.titleMedium),
            const SizedBox(height: 6),
            Text(description,
                style: ClarityTypography.bodySmall.copyWith(
                    color: ClarityColors.textSecondary),
                maxLines: 2,
                overflow: TextOverflow.ellipsis),
            const Spacer(),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.menu_book_outlined,
                    size: 14, color: ClarityColors.textTertiary),
                const SizedBox(width: 4),
                Text('$lessonCount lessons',
                    style: ClarityTypography.labelSmall.copyWith(
                        color: ClarityColors.textTertiary)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
