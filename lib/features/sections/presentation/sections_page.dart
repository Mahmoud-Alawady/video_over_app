import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:video_over_app/features/videos/presentation/videos_page.dart';
import '../../../core/di.dart';
import '../cubit/section_cubit.dart';
import '../models/section.dart';

class SectionsPage extends StatelessWidget {
  const SectionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SectionCubit>(
      create: (_) => getIt<SectionCubit>()..fetchSections(),
      child: const _SectionsView(),
    );
  }
}

class _SectionsView extends StatelessWidget {
  const _SectionsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sections'),
        actions: [
          IconButton(
            onPressed: () {
              context.read<AuthCubit>().signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: BlocBuilder<SectionCubit, SectionState>(
        builder: (context, state) {
          if (state is SectionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SectionsError) {
            return _buildErrorState(context, state.message);
          }

          if (state is SectionsLoaded) {
            final sections = state.sections;
            if (sections.isEmpty) {
              return const Center(child: Text('No sections found'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: sections.length,
              itemBuilder: (context, index) {
                final section = sections[index];
                return _SectionCard(section: section);
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
              onPressed: () => context.read<SectionCubit>().fetchSections(),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final Section section;
  const _SectionCard({required this.section});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VideosPage(levelId: section.id)),
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
              child: CachedNetworkImage(
                imageUrl: section.imageUrl,
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

            // Name under image
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Text(
                section.name,
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
