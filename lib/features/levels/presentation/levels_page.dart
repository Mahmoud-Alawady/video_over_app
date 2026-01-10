import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/videos/presentation/videos_page.dart';
import '../../../core/di.dart';
import '../cubit/level_cubit.dart';
import '../models/level.dart';

class LevelsPage extends StatelessWidget {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LevelCubit>(
      create: (_) => getIt<LevelCubit>()..fetchLevels(),
      child: const _LevelsView(),
    );
  }
}

class _LevelsView extends StatelessWidget {
  const _LevelsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Levels')),
      body: BlocBuilder<LevelCubit, LevelState>(
        builder: (context, state) {
          if (state is LevelsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LevelsError) {
            return _buildErrorState(context, state.message);
          }

          if (state is LevelsLoaded) {
            final levels = state.levels;
            if (levels.isEmpty) {
              return const Center(child: Text('No levels found'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: levels.length,
              itemBuilder: (context, index) {
                final level = levels[index];
                return _LevelCard(level: level);
              },
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => context.read<LevelCubit>().fetchLevels(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  final Level level;
  const _LevelCard({required this.level});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideosPage(levelId: level.id)),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Big image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Image.network(
                level.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Center(child: Icon(Icons.broken_image, size: 48)),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Center(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        value: progress.expectedTotalBytes != null
                            ? progress.cumulativeBytesLoaded /
                                  (progress.expectedTotalBytes ?? 1)
                            : null,
                        strokeWidth: 2.0,
                      ),
                    ),
                  );
                },
              ),
            ),

            // Name under image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                level.name,
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
