class Transcript {
  List<Sentence> sentences;

  Transcript({required this.sentences});

  int get length => sentences.length;

  Map<String, dynamic> toJson() => {
    'sentences': sentences.map((s) => s.toJson()).toList(),
  };

  factory Transcript.fromJson(Map<String, dynamic> json) {
    return Transcript(
      sentences:
          (json['sentences'] as List<dynamic>?)
              ?.map((s) => Sentence.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      // uuid: json['uuid']?.toString() ?? '',
    );
  }
}

class Sentence {
  List<Word> words;
  String? meaning;
  String? voiceKey;
  String? localVoicePath;

  Sentence({
    required this.words,
    this.meaning,
    this.voiceKey,
    this.localVoicePath,
  });

  int get start => words.isEmpty ? 0 : words.first.start;
  int get end => words.isEmpty ? 0 : words.last.end;
  String get text => words.map((w) => w.text).join(' ');

  Map<String, dynamic> toJson() => {
    'words': words.map((w) => w.toJson()).toList(),
    'start': start,
    'end': end,
    'text': text,
    if (meaning != null) 'meaning': meaning,
    if (voiceKey != null) 'voiceKey': voiceKey,
  };

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      words:
          (json['words'] as List<dynamic>?)
              ?.map((w) => Word.fromJson(w as Map<String, dynamic>))
              .toList() ??
          [],
      meaning: json['meaning']?.toString(),
      voiceKey: json['voiceKey']?.toString(),
    );
  }
}

class Word {
  final String text;
  final int start;
  final int end;
  final String? meaning;

  Word({
    required this.text,
    required this.start,
    required this.end,
    this.meaning,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      text: json['text']?.toString() ?? '',
      start: (json['start'] as num?)?.round() ?? 0,
      end: (json['end'] as num?)?.round() ?? 0,
      meaning: json['meaning']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    'start': start,
    'end': end,
    if (meaning != null) 'meaning': meaning,
  };
}
