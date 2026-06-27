import 'package:flutter/material.dart';
import '../../models/recommendation.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';
import '../common/clarity_card.dart';

class RecommendedSection extends StatelessWidget {
  final List<Recommendation> recommendations;
  final VoidCallback? onItemTap;

  const RecommendedSection({
    super.key,
    required this.recommendations,
    this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (recommendations.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Text('No recommendations yet. Keep learning!',
              style: ClarityTypography.bodySmall
                  .copyWith(color: ClarityColors.textTertiary)),
        ),
      );
    }

    return Column(
      children: recommendations.take(3).map((rec) {
        return ClarityCard(
          onTap: onItemTap,
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: ClarityColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.lightbulb_outline,
                    size: 20, color: ClarityColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(rec.title,
                        style: ClarityTypography.titleSmall),
                    const SizedBox(height: 2),
                    Text(rec.reason,
                        style: ClarityTypography.labelSmall.copyWith(
                            color: ClarityColors.textTertiary)),
                  ],
                ),
              ),
              Icon(Icons.chevron_right,
                  size: 20, color: ClarityColors.textTertiary),
            ],
          ),
        );
      }).toList(),
    );
  }
}
