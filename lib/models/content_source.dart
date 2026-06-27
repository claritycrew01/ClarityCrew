class ContentSource {
  final String id;
  final String sourceType;
  final String sourceName;
  final String? sourceId;
  final String? sourceUrl;
  final String importStatus;
  final Map<String, dynamic>? sourceMetadata;
  final DateTime importedAt;
  final int version;
  final String? checksum;

  ContentSource({
    required this.id,
    required this.sourceType,
    required this.sourceName,
    this.sourceId,
    this.sourceUrl,
    this.importStatus = 'pending',
    this.sourceMetadata,
    DateTime? importedAt,
    this.version = 1,
    this.checksum,
  }) : importedAt = importedAt ?? DateTime.now();

  factory ContentSource.fromFirestore(
      Map<String, dynamic> data, String docId) {
    return ContentSource(
      id: docId,
      sourceType: data['sourceType'] as String? ?? '',
      sourceName: data['sourceName'] as String? ?? '',
      sourceId: data['sourceId'] as String?,
      sourceUrl: data['sourceUrl'] as String?,
      importStatus: data['importStatus'] as String? ?? 'pending',
      sourceMetadata:
          data['sourceMetadata'] as Map<String, dynamic>?,
      importedAt: (data['importedAt'] as dynamic)?.toDate(),
      version: data['version'] as int? ?? 1,
      checksum: data['checksum'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'sourceType': sourceType,
      'sourceName': sourceName,
      'sourceId': sourceId,
      'sourceUrl': sourceUrl,
      'importStatus': importStatus,
      'sourceMetadata': sourceMetadata,
      'importedAt': importedAt,
      'version': version,
      'checksum': checksum,
    };
  }
}
