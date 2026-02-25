import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/cubit/loop_cubit.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/transcript_controller.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/word_wrap.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/voice_note_player.dart';

class SentenceWidget extends StatelessWidget {
  final Sentence sentence;
  final TranscriptController controller;
  final void Function(Sentence) onTap;
  final void Function(Sentence) onLongPress;
  final VoidCallback? onVoiceNotePlay;

  const SentenceWidget({
    super.key,
    required this.sentence,
    required this.controller,
    required this.onTap,
    required this.onLongPress,
    this.onVoiceNotePlay,
  });

  void _showMeaning(BuildContext context) {
    if (sentence.meaning == null || sentence.meaning!.isEmpty) return;
    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.black.withValues(alpha: 0.4),
            child: Center(
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.1),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 30,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Text(
                  sentence.meaning!,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showVoiceNotePlayer(BuildContext context) {
    if (sentence.voiceKey == null) return;

    onVoiceNotePlay?.call();

    const String voiceBaseUrl =
        'https://pub-ba251cf33b30468f9e5017846b4d08e4.r2.dev';
    final String fullUrl = '$voiceBaseUrl/${sentence.voiceKey}';

    showDialog(
      context: context,
      barrierColor: Colors.transparent,
      builder: (context) => GestureDetector(
        onTap: () => Navigator.pop(context),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.black.withValues(alpha: 0.4),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // Prevent closing when tapping the player
                child: VoiceNotePlayer(url: fullUrl),
              ),
            ),
          ),
        ),
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
            if (positionMs >= sentence.start && positionMs <= sentence.end) {
              print("## now $positionMs");
              print("## start ${sentence.start}");
              print("## end ${sentence.end}");
            }
            return positionMs >= sentence.start && positionMs <= sentence.end;
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
                    color: isActive ? Colors.grey[850] : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
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
                        const SizedBox(height: 12),
                        const Divider(color: Colors.white10, height: 1),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (sentence.meaning != null)
                              IconButton(
                                icon: const Icon(
                                  Icons.translate,
                                  color: Colors.white70,
                                ),
                                onPressed: () => _showMeaning(context),
                                tooltip: 'Show Meaning',
                              ),
                            if (sentence.voiceKey != null)
                              IconButton(
                                icon: const Icon(
                                  Icons.mic,
                                  color: Colors.white70,
                                ),
                                onPressed: () => _showVoiceNotePlayer(context),
                                tooltip: 'Play Voice Note',
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
