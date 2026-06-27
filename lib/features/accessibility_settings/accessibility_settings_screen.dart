import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';

class AccessibilitySettingsScreen extends StatefulWidget {
  const AccessibilitySettingsScreen({super.key});

  @override
  State<AccessibilitySettingsScreen> createState() =>
      _AccessibilitySettingsScreenState();
}

class _AccessibilitySettingsScreenState
    extends State<AccessibilitySettingsScreen> {
  late bool _reducedMotion;
  late bool _reducedVisuals;
  late bool _highContrast;
  late double _lineSpacing;
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    final profile = context.read<AppState>().learnerState.profile;
    _reducedMotion = profile?.prefersReducedMotion ?? false;
    _reducedVisuals = profile?.prefersReducedVisuals ?? false;
    _highContrast = profile?.prefersHighContrast ?? false;
    _lineSpacing = profile?.lineSpacing ?? 1.5;
    _fontSize = profile?.fontSizeMultiplier ?? 1.0;
  }

  void _save() {
    context.read<AppState>().learnerState.updateAccessibility(
          prefersReducedMotion: _reducedMotion,
          prefersReducedVisuals: _reducedVisuals,
          prefersHighContrast: _highContrast,
          lineSpacing: _lineSpacing,
          fontSizeMultiplier: _fontSize,
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Accessibility settings saved')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Accessibility'),
        actions: [
          TextButton(onPressed: _save, child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Reduced Motion'),
            subtitle: const Text('Minimize animations and transitions'),
            value: _reducedMotion,
            onChanged: (v) => setState(() => _reducedMotion = v),
          ),
          SwitchListTile(
            title: const Text('Reduced Visuals'),
            subtitle: const Text('Simplify visual elements and decorations'),
            value: _reducedVisuals,
            onChanged: (v) => setState(() => _reducedVisuals = v),
          ),
          SwitchListTile(
            title: const Text('High Contrast'),
            subtitle: const Text('Increase contrast for better readability'),
            value: _highContrast,
            onChanged: (v) => setState(() => _highContrast = v),
          ),
          const Divider(),
          ListTile(
            title: const Text('Font Size'),
            subtitle: Text('${(_fontSize * 100).round()}%'),
          ),
          Slider(
            value: _fontSize,
            min: 0.8,
            max: 1.5,
            divisions: 7,
            onChanged: (v) => setState(() => _fontSize = v),
          ),
          ListTile(
            title: const Text('Line Spacing'),
            subtitle: Text('${_lineSpacing.toStringAsFixed(1)}x'),
          ),
          Slider(
            value: _lineSpacing,
            min: 1.0,
            max: 2.5,
            divisions: 15,
            onChanged: (v) => setState(() => _lineSpacing = v),
          ),
          const SizedBox(height: 24),
          Card(
            color: theme.colorScheme.secondaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'These settings help tailor the learning experience to your needs. Changes are saved per device.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSecondaryContainer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
