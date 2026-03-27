import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/core/di.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/features/player_page/cubit/transcript_cubit.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';
import 'package:video_over_app/features/player_page/cubit/loop_cubit.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/transcript_widget.dart';
import 'package:video_over_app/features/videos/models/video.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlayerPage extends StatelessWidget {
  final Video video;
  const PlayerPage({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<TranscriptCubit>()
                ..loadTranscript(video.transcriptKey ?? ''),
        ),
        BlocProvider(create: (context) => PositionCubit()),
        BlocProvider(create: (context) => LoopCubit()),
      ],
      child: _PlayerPageView(video: video),
    );
  }
}

class _PlayerPageView extends StatefulWidget {
  final Video video;
  const _PlayerPageView({required this.video});

  @override
  State<_PlayerPageView> createState() => _PlayerPageViewState();
}

class _PlayerPageViewState extends State<_PlayerPageView> {
  YoutubePlayerController? _controller;

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TranscriptCubit, TranscriptState>(
      builder: (context, state) {
        if (state is TranscriptLoading) {
          Widget buildCont(double h) => Container(
            width: double.infinity,
            height: h,
            decoration: BoxDecoration(
              color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
          );
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  buildCont(300),
                  const SizedBox(height: 24),
                  buildCont(80),
                  const SizedBox(height: 24),
                  buildCont(80),
                  const SizedBox(height: 24),
                  buildCont(80),
                ],
              ),
            ),
          );
        }

        if (state is TranscriptLoaded) {
          final isReel = (widget.video.aspectRatio ?? 16 / 9) < 1.0;
          return Scaffold(
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(flex: isReel ? 6 : 2, child: _buildVideo(context)),
                  Expanded(
                    flex: 4,
                    child: TranscriptWidget(
                      transcript: state.transcript,
                      onSentenceTap: (Sentence sentence) {
                        final loopCubit = context.read<LoopCubit>();
                        if (loopCubit.state != null &&
                            loopCubit.state != sentence) {
                          loopCubit.clearLoop();
                        }
                        seekToMs(sentence.start);
                      },
                      onSentenceLongPress: (Sentence sentence) {
                        context.read<LoopCubit>().toggleLoop(sentence);
                        seekToMs(sentence.start);
                      },
                      onVoiceNotePlay: () {
                        _controller?.pause();
                      },
                      onTranslation: () {
                        _controller?.pause();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is TranscriptError) {
          return Scaffold(
            body: Center(
              child: Text(
                'Error: ${state.message}',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        return const Scaffold();
      },
    );
  }

  Widget _buildVideo(BuildContext context) {
    if (Platform.isLinux) {
      return const SizedBox();
    }

    final videoId = YoutubePlayer.convertUrlToId(widget.video.url);
    if (videoId == null) return const SizedBox();

    _controller ??=
        YoutubePlayerController(
          initialVideoId: videoId,
          flags: const YoutubePlayerFlags(
            autoPlay: true,
            mute: false,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        )..addListener(() {
          if (!mounted) return;
          final positionMs = _controller!.value.position.inMilliseconds;
          context.read<PositionCubit>().emitNewPosition(
            _controller!.value.position,
          );

          final loopSentence = context.read<LoopCubit>().state;
          if (loopSentence != null) {
            if (positionMs >= loopSentence.end ||
                (_controller!.value.playerState == PlayerState.ended)) {
              seekToMs(loopSentence.start);
            }
          }
        });

    return YoutubePlayer(
      controller: _controller!,
      showVideoProgressIndicator: true,
      progressIndicatorColor: Theme.of(context).primaryColor,
      progressColors: ProgressBarColors(
        playedColor: Theme.of(context).primaryColor,
        handleColor: Theme.of(context).primaryColor,
      ),
    );
  }

  void seekToMs(int ms) {
    if (_controller == null) return;
    final wasPlaying = _controller!.value.isPlaying;
    _controller!.seekTo(Duration(milliseconds: ms));
    if (!wasPlaying) {
      _controller!.pause();
    }
    context.read<PositionCubit>().emitNewPosition(Duration(milliseconds: ms));
  }
}
