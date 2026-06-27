import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';

class EmptyState extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.title,
    this.subtitle,
    this.icon = Icons.inbox_outlined,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: ClarityColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon,
                  size: 48, color: ClarityColors.primaryLight),
            ),
            const SizedBox(height: 20),
            Text(title,
                style: ClarityTypography.titleLarge,
                textAlign: TextAlign.center),
            if (subtitle != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(subtitle!,
                    style: ClarityTypography.bodySmall
                        .copyWith(color: ClarityColors.textSecondary),
                    textAlign: TextAlign.center),
              ),
            if (action != null) Padding(
              padding: const EdgeInsets.only(top: 24),
              child: action!,
            ),
          ],
        ),
      ),
    );
  }
}
