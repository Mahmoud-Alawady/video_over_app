import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/transcript_controller.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/word_wrap.dart';

class SentenceWidget extends StatelessWidget {
  final Sentence sentence;
  final TranscriptController controller;

  const SentenceWidget({
    super.key,
    required this.sentence,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<PositionCubit, int, bool>(
      selector: (positionMs) =>
          positionMs >= sentence.start && positionMs <= sentence.end,
      builder: (context, isActive) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
          decoration: BoxDecoration(
            color: isActive
                ? Colors.blue.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: WordWrap(sentence: sentence, controller: controller),
        );
      },
    );
  }
}
