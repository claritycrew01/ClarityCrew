import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';
import '../../providers/accessibility_provider.dart';

class ContrastControl extends StatelessWidget {
  final AccessibilityProvider provider;

  const ContrastControl({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Contrast',
                style: ClarityTypography.titleSmall),
            Text('${(provider.contrastLevel * 100).round()}%',
                style: ClarityTypography.labelLarge.copyWith(
                    color: ClarityColors.primary)),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: ClarityColors.primary,
            inactiveTrackColor: ClarityColors.divider,
            thumbColor: ClarityColors.primary,
            overlayColor: ClarityColors.primary.withOpacity(0.12),
            trackHeight: 4,
          ),
          child: Slider(
            value: provider.contrastLevel,
            min: 0.8,
            max: 2.0,
            divisions: 12,
            onChanged: provider.setContrastLevel,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Softer',
                style: ClarityTypography.labelSmall.copyWith(
                    color: ClarityColors.textTertiary)),
            Text('Higher',
                style: ClarityTypography.labelSmall.copyWith(
                    color: ClarityColors.textTertiary)),
          ],
        ),
      ],
    );
  }
}
