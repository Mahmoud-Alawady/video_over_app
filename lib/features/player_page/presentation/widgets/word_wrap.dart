import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/player_page/cubit/loop_cubit.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/transcript_controller.dart';

class WordWrap extends StatelessWidget {
  final Sentence sentence;
  final TranscriptController controller;
  final void Function(Word) onWordTap;

  const WordWrap({
    super.key,
    required this.sentence,
    required this.controller,
    required this.onWordTap,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PositionCubit, int>(
      buildWhen: (p, c) =>
          controller.findWordIndex(sentence, p) !=
          controller.findWordIndex(sentence, c),
      builder: (context, positionMs) {
        int activeWordIndex = _getWordIndex(context, positionMs);
        return Wrap(
          spacing: 0,
          runSpacing: 0,
          children: List.generate(sentence.words.length, (index) {
            final word = sentence.words[index];
            final isActive = index == activeWordIndex;

            return GestureDetector(
              onTap: () => onWordTap(word),
              child: Container(
                // duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
                decoration: BoxDecoration(
                  color: isActive ? Colors.blue[700] : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  word.text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  int _getWordIndex(BuildContext context, int positionMs) {
    final loopSentence = context.read<LoopCubit>().state;
    if (loopSentence != null) {
      if (loopSentence != sentence) return -1;
    }

    return controller.findWordIndex(sentence, positionMs);
  }
}
