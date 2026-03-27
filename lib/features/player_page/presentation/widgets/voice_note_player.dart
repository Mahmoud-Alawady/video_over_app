import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:video_over_app/core/di.dart';
import 'package:video_over_app/core/services/audio_cache_service.dart';
import 'package:video_over_app/features/player_page/presentation/widgets/waveform_widget.dart';
import 'package:rxdart/rxdart.dart';

class VoiceNotePlayer extends StatefulWidget {
  final String voiceKey;

  const VoiceNotePlayer({super.key, required this.voiceKey});

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  final _player = AudioPlayer();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      final cacheService = getIt<AudioCacheService>();
      final file = await cacheService.getAudioFile(widget.voiceKey);
      await _player.setFilePath(file.path);
      _player.setLoopMode(LoopMode.off);
    } catch (e) {
      if (kDebugMode) print("Error loading audio: $e");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }

    // Listen for completion to reset to start and pause
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _player.pause();
        _player.seek(Duration.zero);
      }
    });
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        _player.positionStream,
        _player.bufferedPositionStream,
        _player.durationStream,
        (position, bufferedPosition, duration) =>
            PositionData(position, bufferedPosition, duration ?? Duration.zero),
      );

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = Theme.of(context).primaryColor;
    final inactiveColor = activeColor.withValues(alpha: 0.2);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Play/Pause Button
        _isLoading
            ? SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                    ),
                  ),
                ),
              )
            : StreamBuilder<PlayerState>(
                stream: _player.playerStateStream,
                builder: (context, snapshot) {
                  final playerState = snapshot.data;
                  final playing = playerState?.playing ?? false;

                  return GestureDetector(
                    onTap: playing ? _player.pause : _player.play,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: activeColor.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        size: 24,
                        color: activeColor,
                      ),
                    ),
                  );
                },
              ),
        const SizedBox(width: 8),
        // Waveform
        Flexible(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final duration = positionData?.duration ?? Duration.zero;
                final position = positionData?.position ?? Duration.zero;
                final progress = duration.inMilliseconds > 0
                    ? position.inMilliseconds / duration.inMilliseconds
                    : 0.0;

                void seek(Offset localPosition, double width) {
                  if (duration == Duration.zero) return;
                  final seekProgress = (localPosition.dx / width).clamp(
                    0.0,
                    1.0,
                  );
                  final seekPosition = duration * seekProgress;
                  _player.seek(seekPosition);
                }

                return LayoutBuilder(
                  builder: (context, constraints) {
                    return GestureDetector(
                      onTapDown: (details) =>
                          seek(details.localPosition, constraints.maxWidth),
                      onHorizontalDragUpdate: (details) =>
                          seek(details.localPosition, constraints.maxWidth),
                      child: WaveformWidget(
                        progress: progress,
                        activeColor: activeColor,
                        inactiveColor: inactiveColor,
                        barCount: 30,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
