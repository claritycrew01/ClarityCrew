import 'package:flutter/material.dart';
import '../../utils/colors.dart';
import '../../utils/typography.dart';
import '../../providers/accessibility_provider.dart';

class TextSizeControl extends StatelessWidget {
  final AccessibilityProvider provider;

  const TextSizeControl({super.key, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Text Size',
                style: ClarityTypography.titleSmall),
            Text('${(provider.textScale * 100).round()}%',
                style: ClarityTypography.labelLarge.copyWith(
                    color: ClarityColors.primary)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: provider.decreaseTextSize,
              icon: const Icon(Icons.text_fields,
                  size: 18, color: ClarityColors.textSecondary),
              constraints: const BoxConstraints(
                  minWidth: 40, minHeight: 40),
            ),
            Expanded(
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: ClarityColors.primary,
                  inactiveTrackColor: ClarityColors.divider,
                  thumbColor: ClarityColors.primary,
                  overlayColor:
                      ClarityColors.primary.withOpacity(0.12),
                  trackHeight: 4,
                ),
                child: Slider(
                  value: provider.textScale,
                  min: 0.8,
                  max: 1.8,
                  divisions: 10,
                  onChanged: provider.setTextScale,
                ),
              ),
            ),
            IconButton(
              onPressed: provider.increaseTextSize,
              icon: const Icon(Icons.text_fields,
                  size: 24, color: ClarityColors.primary),
              constraints: const BoxConstraints(
                  minWidth: 40, minHeight: 40),
            ),
          ],
        ),
      ],
    );
  }
}
