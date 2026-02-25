class Video {
  final int id;
  final String url;
  final int section;
  final double? aspectRatio;
  final String? transcriptKey;
  final DateTime? createdAt;

  Video({
    required this.id,
    required this.url,
    required this.section,
    this.aspectRatio,
    this.transcriptKey,
    this.createdAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final sectionRaw = json['section'];
    final createdAtRaw = (json['createdAt'] ?? json['transcriptCreatedAt'])
        ?.toString();
    final url = json['url']?.toString() ?? '';

    int parseInt(dynamic v) {
      if (v == null) return 0;
      if (v is int) return v;
      return int.tryParse(v.toString()) ?? 0;
    }

    DateTime? parseDate(String? s) {
      if (s == null || s.isEmpty) return null;
      // try direct parse, then try replacing space with 'T' for ISO-like input
      return DateTime.tryParse(s) ??
          DateTime.tryParse(s.replaceFirst(' ', 'T'));
    }

    // Infer aspect ratio
    double aspectRatio = 16 / 9;
    if (url.contains('/shorts/')) {
      aspectRatio = 9 / 16;
    }

    return Video(
      id: parseInt(idRaw),
      url: url,
      section: parseInt(sectionRaw),
      aspectRatio: aspectRatio,
      transcriptKey: (json['transcriptKey'] ?? json['latestTranscript'])
          ?.toString(),
      createdAt: parseDate(createdAtRaw),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'section': section,
      'transcriptKey': transcriptKey,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
