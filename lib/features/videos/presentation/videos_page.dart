import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/core/helpers/get_youtube_thumbnail.dart';
import 'package:video_over_app/features/player_page/presentation/pages/player_page.dart';

import '../../../core/di.dart';
import '../cubit/video_cubit.dart';
import '../models/video.dart';

class VideosPage extends StatelessWidget {
  final int levelId;
  const VideosPage({required this.levelId, super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VideoCubit>(
      create: (_) => getIt<VideoCubit>()..fetchVideos(),
      child: _VideosView(levelId: levelId),
    );
  }
}

class _VideosView extends StatelessWidget {
  const _VideosView({required this.levelId});

  final int levelId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Videos')),
      body: BlocBuilder<VideoCubit, VideoState>(
        builder: (context, state) {
          if (state is VideosLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VideosError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<VideoCubit>().fetchVideos(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is VideosLoaded) {
            final videos = state.videos
                .where((video) => video.section == levelId)
                .toList();

            if (videos.isEmpty) {
              return const Center(child: Text('No videos found'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: videos.length,
              itemBuilder: (context, index) {
                final video = videos[index];
                return _VideoCard(video: video);
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _VideoCard extends StatelessWidget {
  final Video video;
  const _VideoCard({required this.video});

  @override
  Widget build(BuildContext context) {
    print('## ${getYoutubeThumbnail(video.url)}');
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PlayerPage(video: video)),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            clipBehavior: Clip.none,
            children: [
              AspectRatio(
                aspectRatio: video.aspectRatio ?? 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: getYoutubeThumbnail(video.url),
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) =>
                      const Center(child: Icon(Icons.broken_image, size: 48)),
                  placeholder: (context, url) => const Center(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.blue[700],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '#${video.sortOrder}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (video.isPremium)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber[700],
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.star, color: Colors.white, size: 12),
                        SizedBox(width: 4),
                        Text(
                          'PREMIUM',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
