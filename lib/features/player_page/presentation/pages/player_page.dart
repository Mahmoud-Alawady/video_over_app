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
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class PlayerPage extends StatefulWidget {
  final Video video;
  const PlayerPage({super.key, required this.video});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  YoutubePlayerController? _controller;

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<TranscriptCubit>()
                ..loadTranscript(widget.video.latestTranscript ?? ''),
        ),
        BlocProvider(create: (context) => PositionCubit()),
        BlocProvider(create: (context) => LoopCubit()),
      ],
      child: BlocBuilder<TranscriptCubit, TranscriptState>(
        builder: (context, state) {
          if (state is TranscriptLoading) {
            Widget buildCont(double h) => Container(
              width: double.infinity,
              height: h,
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(16),
              ),
            );
            return Scaffold(
              backgroundColor: Colors.black,
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
            final isReel = widget.video.aspectRatio < 1.0;
            return Scaffold(
              backgroundColor: Colors.black,
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
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is TranscriptError) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Text(
                  'Error: ${state.message}',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            );
          }

          return const Scaffold(backgroundColor: Colors.black);
        },
      ),
    );
  }

  Widget _buildVideo(BuildContext context) {
    if (Platform.isLinux) {
      return const SizedBox();
    }

    final videoId = YoutubePlayerController.convertUrlToId(widget.video.url);
    _controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        origin: 'https://www.youtube-nocookie.com',
        showControls: true,
        showFullscreenButton: false,
        strictRelatedVideos: true,
        showVideoAnnotations: true,
      ),
    );
    if (videoId != null) {
      _controller?.loadVideoById(videoId: videoId);
    }
    _controller?.videoStateStream.listen((data) {
      if (!context.mounted) return;
      final positionMs = data.position.inMilliseconds;
      context.read<PositionCubit>().emitNewPosition(data.position);

      final loopSentence = context.read<LoopCubit>().state;
      if (loopSentence != null) {
        if (positionMs >= loopSentence.end ||
            (_controller?.value.playerState == PlayerState.ended)) {
          seekToMs(loopSentence.start);
        }
      }
    });
    return SizedBox(
      width: double.infinity,
      child: YoutubePlayer(controller: _controller!),
    );
  }

  void seekToMs(int ms) {
    _controller?.seekTo(seconds: ms / 1000, allowSeekAhead: true);
  }
}
