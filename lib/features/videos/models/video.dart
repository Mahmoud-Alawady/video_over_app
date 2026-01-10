class Video {
  final int id;
  final String url;
  final String title;
  final int level;
  final int durationInSecs;
  final String? latestTranscript;
  final DateTime? transcriptCreatedAt;

  Video({
    required this.id,
    required this.url,
    required this.title,
    required this.level,
    required this.durationInSecs,
    this.latestTranscript,
    this.transcriptCreatedAt,
  });

  factory Video.fromJson(Map<String, dynamic> json) {
    final idRaw = json['id'];
    final durationRaw = json['durationInSecs'];
    final levelRaw = json['level'];
    final transcriptCreatedAtRaw = json['transcriptCreatedAt']?.toString();

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

    return Video(
      id: parseInt(idRaw),
      url: json['url']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      level: parseInt(levelRaw),
      durationInSecs: parseInt(durationRaw),
      latestTranscript: json['latestTranscript']?.toString(),
      transcriptCreatedAt: parseDate(transcriptCreatedAtRaw),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'title': title,
      'level': level,
      'durationInSecs': durationInSecs,
      'latestTranscript': latestTranscript,
      'transcriptCreatedAt': transcriptCreatedAt?.toIso8601String(),
    };
  }
}
