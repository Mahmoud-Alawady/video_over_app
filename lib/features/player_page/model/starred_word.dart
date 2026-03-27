class StarredWord {
  final String word;
  final String meaning;
  final String? userId;
  final String? createdAt;

  StarredWord({
    required this.word,
    required this.meaning,
    this.userId,
    this.createdAt,
  });

  factory StarredWord.fromJson(Map<String, dynamic> json) {
    return StarredWord(
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      userId: json['userId'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'meaning': meaning,
      if (userId != null) 'userId': userId,
      if (createdAt != null) 'createdAt': createdAt,
    };
  }
}
