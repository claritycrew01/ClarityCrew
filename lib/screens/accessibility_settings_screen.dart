import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/accessibility_provider.dart';
import '../utils/colors.dart';
import '../utils/typography.dart';
import '../widgets/common/clarity_card.dart';
import '../widgets/accessibility/text_size_control.dart';
import '../widgets/accessibility/contrast_control.dart';

class AccessibilitySettingsScreen extends StatelessWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final accessibility = context.watch<AccessibilityProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Accessibility',
            style: ClarityTypography.headlineMedium),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customize your experience',
                  style: ClarityTypography.bodyMedium.copyWith(
                      color: ClarityColors.textSecondary)),
              const SizedBox(height: 24),
              ClarityCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    TextSizeControl(
                        provider: accessibility),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ClarityCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    ContrastControl(
                        provider: accessibility),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ClarityCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text('Motion',
                        style:
                            ClarityTypography.titleSmall),
                    const SizedBox(height: 8),
                    _ToggleTile(
                      title: 'Reduced Motion',
                      subtitle:
                          'Minimize animations and transitions',
                      value:
                          accessibility.reducedMotion,
                      onChanged: (_) =>
                          accessibility
                              .toggleReducedMotion(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ClarityCard(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text('Focus Mode',
                        style:
                            ClarityTypography.titleSmall),
                    const SizedBox(height: 8),
                    _ToggleTile(
                      title: 'Enable Focus Mode',
                      subtitle:
                          'Dim outside areas to help you concentrate',
                      value:
                          accessibility.focusMode,
                      onChanged: (_) =>
                          accessibility
                              .toggleFocusMode(),
                    ),
                    if (accessibility.focusMode)
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 12),
                        child: Text(
                          'Focus mode dims the edges of the screen to help you concentrate on the main content.',
                          style: ClarityTypography
                              .bodySmall
                              .copyWith(
                                  color: ClarityColors
                                      .textSecondary),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: accessibility.resetAll,
                  style: OutlinedButton.styleFrom(
                    foregroundColor:
                        ClarityColors.error,
                    side: const BorderSide(
                        color: ClarityColors.error),
                    padding:
                        const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child:
                      const Text('Reset All Settings'),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(title,
                  style:
                      ClarityTypography.titleSmall),
              Text(subtitle,
                  style: ClarityTypography.bodySmall
                      .copyWith(
                          color: ClarityColors
                              .textSecondary)),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          onChanged: onChanged,
          activeColor: ClarityColors.primary,
        ),
      ],
    );
  }
}
