import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/core/di.dart';
import 'package:video_over_app/features/player_page/cubit/position_cubit.dart';
import 'package:video_over_app/extension/stream_throttle_extension.dart';
import 'package:video_over_app/features/player_page/cubit/transcript_cubit.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/app_sentence_list.dart';
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
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.black,
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(flex: 8, child: _buildVideo(context)),
                  Expanded(flex: 4, child: _buildWords()),
                ],
              ),
            ),
          );
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
    return YoutubePlayer(controller: _controller!);
  }

  Widget _buildWords() {
    return BlocBuilder<TranscriptCubit, TranscriptState>(
      builder: (context, state) {
        if (state is TranscriptLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is TranscriptLoaded) {
          return AppSentenceList(state.transcript);
        } else if (state is TranscriptError) {
          return Center(
            child: Text(
              'Error: ${state.message}',
              style: const TextStyle(color: Colors.white),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
