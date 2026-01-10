import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/core/di.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/extension/stream_throttle_extension.dart';
import 'package:video_over_app/features/player_page/cubit/transcript_cubit.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/app_sentence_list.dart';
import 'package:video_over_app/features/videos/models/video.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import 'package:video_over_app/features/player_page/model/transcript.dart';

class PlayerPage extends StatefulWidget {
  final Video video;
  const PlayerPage({super.key, required this.video});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  YoutubePlayerController? _controller;

  @override
  void initState() {
    super.initState();
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
  }

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
      ],
      child: BlocBuilder<TranscriptCubit, TranscriptState>(
        builder: (context, state) {
          if (state is TranscriptLoading) {
            return Scaffold(
              backgroundColor: Colors.black,
              body: Center(
                child: Container(
                  width: 300,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[800],
                    borderRadius: BorderRadius.circular(16),
                  ),
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
                    Expanded(flex: isReel ? 6 : 4, child: _buildVideo(context)),
                    Expanded(flex: 4, child: _buildWords(state.transcript)),
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
    _controller?.videoStateStream
        .throttle(const Duration(milliseconds: 250))
        .listen((data) {
          if (!context.mounted) return;
          context.read<PositionCubit>().emitNewPosition(data.position);
        });
    return SizedBox(
      width: double.infinity,
      child: YoutubePlayer(controller: _controller!),
    );
  }

  Widget _buildWords(Transcript transcript) {
    return AppSentenceList(transcript);
    return BlocBuilder<PositionCubit, PositionState>(
      builder: (context, state) {
        Sentence? currentSentence;
        for (final sentence in transcript.sentences) {
          if (sentence.hasPosition(state.position)) {
            currentSentence = sentence;
            break;
          }
        }

        if (currentSentence == null && transcript.sentences.isNotEmpty) {
          for (final sentence in transcript.sentences) {
            if (sentence.end < state.position) {
              currentSentence = sentence;
            } else {
              break;
            }
          }
          currentSentence ??= transcript.sentences.first;
        }

        if (currentSentence == null) return const SizedBox.shrink();

        return Center(
          child: Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 6,
              runSpacing: 4,
              children: currentSentence.words.map((word) {
                final isCurrentWord = word.hasPosition(state.position);
                return Text(
                  word.text,
                  style: TextStyle(
                    color: isCurrentWord ? Colors.yellow : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
