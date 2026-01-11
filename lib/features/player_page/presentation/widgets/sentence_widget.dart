import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/cubit/loop_cubit.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/transcript_controller.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/word_wrap.dart';

class SentenceWidget extends StatelessWidget {
  final Sentence sentence;
  final TranscriptController controller;
  final void Function(Sentence) onTap;
  final void Function(Sentence) onLongPress;

  const SentenceWidget({
    super.key,
    required this.sentence,
    required this.controller,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopCubit, Sentence?>(
      builder: (context, loopSentence) {
        final isLooping = loopSentence == sentence;
        return BlocSelector<PositionCubit, int, bool>(
          selector: (positionMs) {
            if (loopSentence != null) {
              if (loopSentence != sentence) return false;
            }
            return positionMs >= sentence.start && positionMs <= sentence.end;
          },
          builder: (context, isActive) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => onTap(sentence),
                onLongPress: () => onLongPress(sentence),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActive ? Colors.grey[800] : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isLooping ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: WordWrap(
                    sentence: sentence,
                    controller: controller,
                    onWordTap: (word) {
                      if (isActive) {
                        if (word.meaning != null && word.meaning!.isNotEmpty) {
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${word.text}: ${word.meaning}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              backgroundColor: Colors.white,
                              duration: const Duration(seconds: 4),
                            ),
                          );
                        }
                      } else {
                        onTap(sentence);
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
