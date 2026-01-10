part of 'video_cubit.dart';

@immutable
abstract class VideoState {
  const VideoState();
}

class VideosInitial extends VideoState {
  const VideosInitial();
}

class VideosLoading extends VideoState {
  const VideosLoading();
}

class VideosLoaded extends VideoState {
  final List<Video> videos;
  const VideosLoaded(this.videos);
}

class VideosError extends VideoState {
  final String message;
  const VideosError(this.message);
}
