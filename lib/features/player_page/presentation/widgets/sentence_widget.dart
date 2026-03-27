import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/cubit/loop_cubit.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/transcript_controller.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/word_wrap.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/voice_note_player.dart';
import 'package:video_over_app/features/player_page/presentation/pages/translation_page.dart';

class SentenceWidget extends StatelessWidget {
  final Sentence sentence;
  final TranscriptController controller;
  final void Function(Sentence) onTap;
  final void Function(Sentence) onLongPress;
  final VoidCallback? onVoiceNotePlay;
  final VoidCallback? onTranslation;

  const SentenceWidget({
    super.key,
    required this.sentence,
    required this.controller,
    required this.onTap,
    required this.onLongPress,
    this.onVoiceNotePlay,
    this.onTranslation,
  });

  void _navigateToTranslation(BuildContext context) {
    if (sentence.meaning == null || sentence.meaning!.isEmpty) return;
    onTranslation?.call();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TranslationPage(sentence: sentence),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoopCubit, Sentence?>(
      builder: (context, loopSentence) {
        final isLooping = loopSentence == sentence;
        return BlocSelector<PositionCubit, int, bool>(
          selector: (positionMs) {
            if (loopSentence != null) {
              return (loopSentence == sentence);
            }

            return positionMs >= sentence.start && positionMs < sentence.end;
          },
          builder: (context, isActive) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  if (!isActive) {
                    onTap(sentence);
                  }
                },
                onLongPress: () => onLongPress(sentence),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isLooping ? Colors.white : Colors.transparent,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      WordWrap(sentence: sentence, controller: controller),
                      if (isActive) ...[
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (sentence.voiceKey != null)
                              Expanded(
                                child: VoiceNotePlayer(
                                  voiceKey: sentence.voiceKey!,
                                ),
                              ),
                            if (sentence.meaning != null)
                              IconButton(
                                icon: Icon(
                                  Icons.translate,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () =>
                                    _navigateToTranslation(context),
                                tooltip: 'Show Meaning',
                              ),
                          ],
                        ),
                      ],
                    ],
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
