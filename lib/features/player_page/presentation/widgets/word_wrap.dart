import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/transcript_controller.dart';

class WordWrap extends StatelessWidget {
  final Sentence sentence;
  final TranscriptController controller;

  const WordWrap({super.key, required this.sentence, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PositionCubit, int>(
      buildWhen: (p, c) =>
          controller.findWordIndex(sentence, p) !=
          controller.findWordIndex(sentence, c),
      builder: (context, positionMs) {
        final activeWordIndex = controller.findWordIndex(sentence, positionMs);

        return Wrap(
          spacing: 6,
          runSpacing: 6,
          children: List.generate(sentence.words.length, (index) {
            final word = sentence.words[index];
            final isActive = index == activeWordIndex;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isActive ? Colors.blue : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                word.text,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.black,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}
