import 'dart:convert';
import 'dart:io';

class Transcript {
  List<Sentence> sentences;

  Transcript({required this.sentences});

  factory Transcript.fromWords(List<Word> words) {
    return Transcript(sentences: [Sentence(words: words)]);
  }

  Transcript copyWithUpdatedWord({
    required int sentenceIndex,
    required int wordIndex,
    required String newText,
    required String newMeaning,
  }) {
    final updatedSentences = List<Sentence>.from(sentences);
    final sentence = updatedSentences[sentenceIndex];
    final updatedWords = List<Word>.from(sentence.words);

    final oldWord = updatedWords[wordIndex];
    updatedWords[wordIndex] = Word(
      text: newText,
      meaning: newMeaning,
      start: oldWord.start,
      end: oldWord.end,
    );
    updatedSentences[sentenceIndex] = Sentence(words: updatedWords);
    return Transcript(sentences: updatedSentences);
  }

  int get length => sentences.length;
  Sentence operator [](int index) => sentences[index];

  Map<String, dynamic> toJson() => {
    'sentences': sentences.map((s) => s.toJson()).toList(),
  };

  factory Transcript.fromJson(Map<String, dynamic> json) {
    return Transcript(
      sentences: (json['sentences'] as List<dynamic>)
          .map((s) => Sentence.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> toFile({String fileName = 'file.json'}) async {
    final dir = Directory('${Directory.current.path}/temp');

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final file = File('${dir.path}/$fileName');
    final jsonString = const JsonEncoder.withIndent('  ').convert(toJson());

    await file.writeAsString(jsonString);
  }
}

class Sentence {
  List<Word> words;

  Sentence({required this.words});

  double get start => words.first.start;
  double get end => words.last.end;
  String get text => words.map((w) => w.text).join(' ');

  Map<String, dynamic> toJson() => {
    'words': words.map((w) => w.toJson()).toList(),
    'start': start,
    'end': end,
    'text': text,
  };

  factory Sentence.fromJson(Map<String, dynamic> json) {
    return Sentence(
      words: (json['words'] as List<dynamic>)
          .map((w) => Word.fromJson(w as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Word {
  final String text;
  final String? meaning;
  final double start;
  final double end;

  Word({
    required this.text,
    this.meaning,
    required this.start,
    required this.end,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      text: json['text'] as String,
      meaning: json['meaning'] as String?,
      start: (json['start'] as num).toDouble(),
      end: (json['end'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'text': text,
    if (meaning != null) 'meaning': meaning,
    'start': start,
    'end': end,
  };
}
