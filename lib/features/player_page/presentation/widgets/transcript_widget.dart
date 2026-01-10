import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/sentence_widget.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/transcript_controller.dart';

class TranscriptWidget extends StatefulWidget {
  final Transcript transcript;

  const TranscriptWidget({super.key, required this.transcript});

  @override
  State<TranscriptWidget> createState() => _TranscriptWidgetState();
}

class _TranscriptWidgetState extends State<TranscriptWidget> {
  late final TranscriptController controller;
  late final List<GlobalKey> sentenceKeys;

  int _lastSentenceIndex = -1;

  @override
  void initState() {
    super.initState();
    controller = TranscriptController(widget.transcript);
    sentenceKeys = List.generate(
      widget.transcript.sentences.length,
      (_) => GlobalKey(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PositionCubit, int>(
      listenWhen: (prev, curr) =>
          controller.findSentenceIndex(prev) !=
          controller.findSentenceIndex(curr),
      listener: (context, positionMs) {
        final index = controller.findSentenceIndex(positionMs);
        if (index >= 0 && index != _lastSentenceIndex) {
          _lastSentenceIndex = index;

          final ctx = sentenceKeys[index].currentContext;
          if (ctx != null) {
            Scrollable.ensureVisible(
              ctx,
              alignment: 0.3,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
            );
          }
        }
      },
      child: ListView.builder(
        itemCount: widget.transcript.sentences.length,
        itemBuilder: (context, index) {
          return SentenceWidget(
            key: sentenceKeys[index],
            sentence: widget.transcript.sentences[index],
            controller: controller,
          );
        },
      ),
    );
  }
}
