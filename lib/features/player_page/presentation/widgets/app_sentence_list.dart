import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/app_sentence.dart';

class AppSentenceList extends StatefulWidget {
  final Transcript transcript;

  const AppSentenceList(this.transcript, {super.key});

  @override
  State<AppSentenceList> createState() => _AppSentenceListState();
}

class _AppSentenceListState extends State<AppSentenceList> {
  int currentIndex = 0;
  final itemScrollController = ItemScrollController();
  final itemPositionsListener = ItemPositionsListener.create();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PositionCubit, PositionState>(
      builder: (context, state) {
        return ScrollConfiguration(
          behavior: ScrollBehavior().copyWith(overscroll: false),
          child: ScrollablePositionedList.builder(
            itemCount: widget.transcript.sentences.length,
            itemBuilder: (_, index) => AppSentence(
              widget.transcript.sentences[index],
              currentPosition: state.position,
            ),
            itemScrollController: itemScrollController,
            itemPositionsListener: itemPositionsListener,
          ),
        );
      },
      listener: (context, state) {
        int newIndex = currentIndex;
        for (int i = 0; i < widget.transcript.sentences.length; i++) {
          if (widget.transcript.sentences[i].hasPosition(state.position)) {
            newIndex = i;
            break;
          }
        }
        if (currentIndex != newIndex) {
          currentIndex = newIndex;
          scrollTo(currentIndex);
        }
      },
    );
  }

  void scrollTo(int i) {
    itemScrollController.scrollTo(
      index: i,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      // alignment: 0.5, // 0 = top, 0.5 = center, 1 = bottom
    );
  }
}


      // onSubtitleTap: (sub) async {
      //   // await _controller?.pauseVideo();
      //   // await _controller?.playVideo();
      //   await _controller?.seekTo(
      //     seconds: sub.start.inSeconds + 0.0,
      //     allowSeekAhead: true,
      //   );
      // },