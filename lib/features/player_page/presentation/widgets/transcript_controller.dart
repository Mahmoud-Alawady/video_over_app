import 'package:video_over_app/features/player_page/model/transcript.dart';

class TranscriptController {
  final Transcript transcript;

  TranscriptController(this.transcript);

  int findSentenceIndex(int positionMs) {
    final sentences = transcript.sentences;
    for (int i = 0; i < sentences.length; i++) {
      if (positionMs >= sentences[i].start && positionMs <= sentences[i].end) {
        return i;
      }
    }
    return -1;
  }

  int findWordIndex(Sentence sentence, int positionMs) {
    final words = sentence.words;
    for (int i = 0; i < words.length; i++) {
      if (positionMs >= words[i].start && positionMs <= words[i].end) {
        return i;
      }
    }
    return -1;
  }
}
