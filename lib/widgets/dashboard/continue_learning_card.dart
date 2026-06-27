import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';
import '../common/clarity_card.dart';
import '../common/progress_bar.dart';

class ContinueLearningCard extends StatelessWidget {
  final String courseTitle;
  final String lessonTitle;
  final double progress;
  final String? subjectName;
  final VoidCallback? onTap;

  const ContinueLearningCard({
    super.key,
    required this.courseTitle,
    required this.lessonTitle,
    required this.progress,
    this.subjectName,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClarityCard(
      onTap: onTap,
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          ClarityColors.primary,
          Color(0xFF3550A0),
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: ClarityColors.primary.withOpacity(0.3),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.play_circle_fill,
                  color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text('Continue Learning',
                  style: ClarityTypography.labelLarge.copyWith(
                      color: Colors.white.withOpacity(0.9))),
            ],
          ),
          const SizedBox(height: 12),
          Text(courseTitle,
              style: ClarityTypography.displaySmall.copyWith(
                  color: Colors.white)),
          const SizedBox(height: 4),
          Text(lessonTitle,
              style: ClarityTypography.bodyMedium.copyWith(
                  color: Colors.white.withOpacity(0.8)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          if (subjectName != null) ...[
            const SizedBox(height: 4),
            Text(subjectName!,
                style: ClarityTypography.labelSmall.copyWith(
                    color: Colors.white.withOpacity(0.6))),
          ],
          const SizedBox(height: 16),
          ClarityProgressBar(
            progress: progress,
            color: Colors.white,
            backgroundColor: Colors.white.withOpacity(0.2),
          ),
        ],
      ),
    );
  }
}
