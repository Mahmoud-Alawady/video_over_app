import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/sentence_widget.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/transcript_controller.dart';

class TranscriptWidget extends StatefulWidget {
  final Transcript transcript;
  final void Function(Sentence) onSentenceTap;
  final void Function(Sentence) onSentenceLongPress;

  const TranscriptWidget({
    super.key,
    required this.transcript,
    required this.onSentenceTap,
    required this.onSentenceLongPress,
  });

  @override
  State<TranscriptWidget> createState() => _TranscriptWidgetState();
}

class _TranscriptWidgetState extends State<TranscriptWidget> {
  late final TranscriptController controller;
  final ItemScrollController itemScrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    controller = TranscriptController(widget.transcript);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PositionCubit, int>(
      listenWhen: (prev, curr) =>
          curr == 0 ||
          controller.findSentenceIndex(prev) !=
              controller.findSentenceIndex(curr),
      listener: (context, positionMs) {
        if (positionMs == 0) {
          scrollToSentence(0);
          return;
        }
        final index = controller.findSentenceIndex(positionMs - 100);
        if (index >= 0) {
          scrollToSentence(index);
        }
      },
      child: ScrollConfiguration(
        behavior: ScrollBehavior().copyWith(overscroll: false),
        child: ScrollablePositionedList.builder(
          itemCount: widget.transcript.sentences.length,
          itemScrollController: itemScrollController,
          itemPositionsListener: itemPositionsListener,
          itemBuilder: (context, index) {
            return SentenceWidget(
              sentence: widget.transcript.sentences[index],
              controller: controller,
              onTap: widget.onSentenceTap,
              onLongPress: widget.onSentenceLongPress,
            );
          },
        ),
      ),
    );
  }

  void scrollToSentence(int index) {
    if (itemScrollController.isAttached) {
      itemScrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        alignment: 0.3,
      );
    }
  }
}
