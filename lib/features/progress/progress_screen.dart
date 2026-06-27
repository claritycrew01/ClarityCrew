import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../persistence/local_storage_repository.dart';
import '../../services/content/progress_tracker.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final profile = appState.learnerState.profile;
    final repo = context.read<LocalStorageRepository>();
    final tracker = ProgressTracker(repo);

    final totalMinutes = tracker.totalStudyMinutes();
    final sessionsCompleted = tracker.sessionsCompleted();
    final subjectsStarted = tracker.subjectsStarted();
    final overallProgress = profile != null ? tracker.overallProgress(profile) : 0.0;

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Your Progress')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: overallProgress,
                          strokeWidth: 10,
                          backgroundColor: theme.colorScheme.surfaceVariant,
                        ),
                        Center(
                          child: Text(
                            '${(overallProgress * 100).round()}%',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Overall Progress',
                    style: theme.textTheme.titleMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.timer,
                            size: 32, color: theme.colorScheme.primary),
                        const SizedBox(height: 8),
                        Text(
                          '$totalMinutes',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Minutes',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.check_circle,
                            size: 32, color: theme.colorScheme.primary),
                        const SizedBox(height: 8),
                        Text(
                          '$sessionsCompleted',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Sessions',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Icon(Icons.subject,
                            size: 32, color: theme.colorScheme.primary),
                        const SizedBox(height: 8),
                        Text(
                          '$subjectsStarted',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Subjects',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          if (profile != null && profile.engagementHistory.isNotEmpty)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Engagement by Topic',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    ...profile.engagementHistory.entries.map(
                      (entry) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 100,
                              child: Text(entry.key,
                                  style: theme.textTheme.bodyMedium),
                            ),
                            Expanded(
                              child: LinearProgressIndicator(
                                value: entry.value.clamp(0, 1),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(entry.value * 100).round()}%',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
