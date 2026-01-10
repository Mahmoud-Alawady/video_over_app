import 'package:flutter/material.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';

class AppSentence extends StatelessWidget {
  final Sentence sentence;
  final double currentPosition;
  const AppSentence(this.sentence, {required this.currentPosition, super.key});

  @override
  Widget build(BuildContext context) {
    // final currentPosition > word.timing;
    // for (var i = 0; i < sentence.words.length; i++) {
    //   word = sentence.words[i];
    //   if (sent) {

    //   }
    // }
    return Wrap(
      children: sentence.words
          .map(
            (word) => WordCard(
              word: word,
              isSelected: word.hasPosition(currentPosition),
            ),
          )
          .toList(),
    );
  }
}

class WordCard extends StatelessWidget {
  final Word word;
  final bool isSelected;
  const WordCard({required this.word, this.isSelected = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isSelected ? Colors.green : Colors.transparent,
        // borderRadius: BorderRadius.circular(8),
      ),

      child: Text(
        '${word.text} ',

        style: TextStyle(
          fontSize: 38,
          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
