import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../services/content/subject_icon_registry.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final subjects = appState.contentRepository.subjects;
    final profile = appState.learnerState.profile;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi${profile?.name.isNotEmpty == true ? ", ${profile!.name}" : ""}!'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'What would you like to learn today?',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...subjects.map((subject) => Card(
                child: ListTile(
                  leading: Icon(
                    SubjectIconRegistry.getIcon(subject['iconKey'] as String? ?? ''),
                    color: SubjectIconRegistry.getColor(subject['iconKey'] as String? ?? ''),
                  ),
                  title: Text(subject['name'] as String? ?? ''),
                  subtitle: Text('${subject['id']}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.pushNamed(
                    context,
                    '/subject',
                    arguments: subject,
                  ),
                ),
              )),
          const SizedBox(height: 24),
          Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ActionChip(
                avatar: const Icon(Icons.smart_toy),
                label: const Text('AI Tutor'),
                onPressed: () => Navigator.pushNamed(context, '/ai_tutor'),
              ),
              ActionChip(
                avatar: const Icon(Icons.timer),
                label: const Text('Focus Session'),
                onPressed: () => Navigator.pushNamed(context, '/focus'),
              ),
              ActionChip(
                avatar: const Icon(Icons.bar_chart),
                label: const Text('Progress'),
                onPressed: () => Navigator.pushNamed(context, '/progress'),
              ),
              ActionChip(
                avatar: const Icon(Icons.accessible),
                label: const Text('Accessibility'),
                onPressed: () =>
                    Navigator.pushNamed(context, '/accessibility_settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
