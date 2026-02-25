import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:rxdart/rxdart.dart';

class VoiceNotePlayer extends StatefulWidget {
  final String url;

  const VoiceNotePlayer({super.key, required this.url});

  @override
  State<VoiceNotePlayer> createState() => _VoiceNotePlayerState();
}

class _VoiceNotePlayerState extends State<VoiceNotePlayer> {
  final _player = AudioPlayer();
  Duration _lastValidPosition = Duration.zero;
  bool _isSeeking = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAudio();
  }

  Future<void> _initAudio() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final voiceNotesDir = Directory('${dir.path}/voice_notes');
      if (!await voiceNotesDir.exists()) {
        await voiceNotesDir.create(recursive: true);
      }

      final fileName = widget.url.split('/').last;
      final file = File('${voiceNotesDir.path}/$fileName');
      final tempFile = File('${file.path}.temp');

      if (await file.exists()) {
        await _playFromFile(file);
      } else {
        if (await tempFile.exists()) {
          await tempFile.delete();
        }
        await _downloadAndPlay(widget.url, file, tempFile);
      }
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

  Future<void> _downloadAndPlay(String url, File file, File tempFile) async {
    try {
      await Dio().download(url, tempFile.path);
      await tempFile.rename(file.path);
      await _playFromFile(file);
    } catch (e) {
      if (kDebugMode) print("Error downloading audio: $e");
    }
  }

  Future<void> _playFromFile(File file) async {
    try {
      await _player.setFilePath(file.path);
      _player.play();
    } catch (e) {
      if (kDebugMode) print("Error playing file: $e");
    }
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
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 32),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 30,
            spreadRadius: 10,
          ),
        ],
      ),
      constraints: const BoxConstraints(maxWidth: 400),
      height: 120,
      child: Row(
        children: [
          // Play/Pause Button
          // Play/Pause Button
          SizedBox(
            width: 50,
            child: _isLoading
                ? const Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  )
                : StreamBuilder<PlayerState>(
                    stream: _player.playerStateStream,
                    builder: (context, snapshot) {
                      final playerState = snapshot.data;
                      final playing = playerState?.playing ?? false;

                      return IconButton(
                        icon: Icon(
                          playing
                              ? Icons.pause_rounded
                              : Icons.play_arrow_rounded,
                        ),
                        iconSize: 32,
                        color: Colors.white70,
                        onPressed: playing ? _player.pause : _player.play,
                      );
                    },
                  ),
          ),
          const SizedBox(width: 6),

          // Progress Bar
          Expanded(
            child: StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                final duration = positionData?.duration ?? Duration.zero;
                var position = positionData?.position ?? Duration.zero;

                // Handle monotonic progress
                if (_isSeeking) {
                  // While seeking, use the last valid position or the raw position
                  // But we usually want to avoid jitter from the stream while the user is dragging.
                  // Since we don't control the thumb position directly here (ProgressBar handles it internally during drag),
                  // we just need to ensure we don't overwrite it with bad stream data if possible.
                  // However, ProgressBar usually ignores 'progress' update while dragging.
                  // So we just update our internal state.
                  position = _player
                      .position; // Use actual player position or keep last valid
                } else {
                  // Monotonic check
                  if (position < _lastValidPosition) {
                    // Detect if this is a small backward jump (e.g. clock drift) vs a seek/reset
                    final diff = _lastValidPosition - position;
                    if (diff <= const Duration(milliseconds: 300)) {
                      // Small backward jump: IGNORE it, clamp to last valid
                      position = _lastValidPosition;
                    } else {
                      // Large backward jump: Accept it (Seek or Reset)
                      _lastValidPosition = position;
                    }
                  } else {
                    // Forward movement: Accept it
                    _lastValidPosition = position;
                  }
                }

                // Clamp to duration
                if (position > duration) {
                  position = duration;
                }

                return ProgressBar(
                  progress: position,
                  buffered: positionData?.bufferedPosition ?? Duration.zero,
                  total: duration,
                  onSeek: (newPosition) {
                    _player.seek(newPosition);
                    _lastValidPosition =
                        newPosition; // Update local state immediately
                  },
                  onDragStart: (details) {
                    _isSeeking = true;
                  },
                  onDragEnd: () {
                    _isSeeking = false;
                    // Ensure we capture the final drag position if available,
                    // though usually onSeek is called right after.
                  },
                  barHeight: 3,
                  baseBarColor: Colors.white.withValues(alpha: 0.1),
                  progressBarColor: Colors.white,
                  thumbColor: Colors.white,
                  thumbRadius: 6,
                  timeLabelTextStyle: const TextStyle(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}
