import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/app_state.dart';
import '../../models/video_content.dart';

class VideoScreen extends StatelessWidget {
  final VideoContent video;

  const VideoScreen({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final linkedLesson = appState.contentRepository.getLessonById(
      video.linkedLessonId,
    );

    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(video.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.play_circle_fill,
                    size: 64,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    video.duration,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            video.description,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          if (video.keyPoints.isNotEmpty) ...[
            Text(
              'Key Points',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...video.keyPoints.map(
              (point) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(point)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          if (video.chapters.isNotEmpty) ...[
            Text(
              'Chapters',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...video.chapters.asMap().entries.map(
                  (entry) => ListTile(
                    leading: CircleAvatar(
                      child: Text('${entry.key + 1}'),
                    ),
                    title: Text(entry.value),
                    dense: true,
                  ),
                ),
            const SizedBox(height: 16),
          ],
          if (linkedLesson != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.menu_book),
                title: const Text('Linked Lesson'),
                subtitle: Text(linkedLesson.title),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.pushNamed(
                  context,
                  '/lesson',
                  arguments: linkedLesson,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
