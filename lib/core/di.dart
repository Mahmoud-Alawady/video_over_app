import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:video_over_app/features/player_page/cubit/transcript_cubit.dart';
import 'package:video_over_app/features/player_page/repository/transcript_repository.dart';
import 'package:video_over_app/features/videos/cubit/video_cubit.dart';
import 'package:video_over_app/features/videos/repository/video_repository.dart';
import '../features/levels/cubit/level_cubit.dart';
import '../features/levels/repository/level_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  getIt.registerLazySingleton<Dio>(
    () =>
        Dio(BaseOptions(baseUrl: 'https://video-over.video-over.workers.dev')),
  );

  // Levels
  getIt.registerLazySingleton<LevelRepository>(() => LevelRepository(getIt()));
  getIt.registerFactory<LevelCubit>(() => LevelCubit(getIt<LevelRepository>()));

  // Videos
  getIt.registerLazySingleton<VideoRepository>(() => VideoRepository(getIt()));
  getIt.registerFactory<VideoCubit>(() => VideoCubit(getIt<VideoRepository>()));

  // Transcript
  getIt.registerLazySingleton<TranscriptRepository>(
    () => TranscriptRepository(getIt()),
  );
  getIt.registerFactory<TranscriptCubit>(
    () => TranscriptCubit(getIt<TranscriptRepository>()),
  );
}
