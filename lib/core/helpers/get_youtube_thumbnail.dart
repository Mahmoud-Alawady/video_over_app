String getYoutubeThumbnail(String url) {
  final uri = Uri.parse(url);

  String? videoId;

  // youtu.be/VIDEO_ID
  if (uri.host.contains('youtu.be')) {
    videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
  }
  // youtube.com/watch?v=VIDEO_ID
  else if (uri.queryParameters['v'] != null) {
    videoId = uri.queryParameters['v'];
  }
  // youtube.com/shorts/VIDEO_ID
  else if (uri.pathSegments.contains('shorts')) {
    final index = uri.pathSegments.indexOf('shorts');
    if (index + 1 < uri.pathSegments.length) {
      videoId = uri.pathSegments[index + 1];
    }
  }

  if (videoId == null || videoId.isEmpty) {
    throw Exception('Invalid YouTube URL');
  }

  return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
}
