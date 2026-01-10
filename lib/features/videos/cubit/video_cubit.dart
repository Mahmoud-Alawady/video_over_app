import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repository/video_repository.dart';
import '../models/video.dart';

part 'video_state.dart';

class VideoCubit extends Cubit<VideoState> {
  final VideoRepository _repository;

  VideoCubit(this._repository) : super(const VideosInitial());

  Future<void> fetchVideos() async {
    emit(const VideosLoading());
    try {
      final videos = await _repository.fetchVideos();
      emit(VideosLoaded(videos));
    } catch (e) {
      emit(VideosError(e.toString()));
    }
  }
}
