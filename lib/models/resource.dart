class Resource {
  final String id;
  final String title;
  final String type;
  final String url;
  final String? thumbnailUrl;
  final int durationSeconds;
  final String source;
  final String? sourceId;
  final Map<String, dynamic>? metadata;

  Resource({
    required this.id,
    required this.title,
    required this.type,
    required this.url,
    this.thumbnailUrl,
    this.durationSeconds = 0,
    this.source = 'manual',
    this.sourceId,
    this.metadata,
  });

  factory Resource.fromMap(Map<String, dynamic> data) {
    return Resource(
      id: data['id'] as String? ?? '',
      title: data['title'] as String? ?? '',
      type: data['type'] as String? ?? 'document',
      url: data['url'] as String? ?? '',
      thumbnailUrl: data['thumbnailUrl'] as String?,
      durationSeconds: data['durationSeconds'] as int? ?? 0,
      source: data['source'] as String? ?? 'manual',
      sourceId: data['sourceId'] as String?,
      metadata: data['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'url': url,
      'thumbnailUrl': thumbnailUrl,
      'durationSeconds': durationSeconds,
      'source': source,
      'sourceId': sourceId,
      'metadata': metadata,
    };
  }

  bool get isVideo => type == 'video';
  bool get isDocument => type == 'document';
  bool get isAudio => type == 'audio';
  bool get isInteractive => type == 'interactive';
  bool get isKolibri => source == 'kolibri';
}
