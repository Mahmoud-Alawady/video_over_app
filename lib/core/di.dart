import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_over_app/features/auth/data/repositories/auth_repository.dart';
import 'package:video_over_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:video_over_app/features/player_page/cubit/transcript_cubit.dart';
import 'package:video_over_app/features/player_page/repository/transcript_repository.dart';
import 'package:video_over_app/features/videos/cubit/video_cubit.dart';
import 'package:video_over_app/features/videos/repository/video_repository.dart';
import '../features/levels/cubit/level_cubit.dart';
import '../features/levels/repository/level_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core
  getIt.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: 'https://api.video-over.workers.dev')),
  );
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  // Auth
  getIt.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(
      clientId:
          '123877414748-h70ttofetvv6r3s3vdfauaclf1o2okqt.apps.googleusercontent.com',
      scopes: ['email', 'profile'],
    ),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepository(getIt(), getIt(), getIt()),
  );
  getIt.registerFactory<AuthCubit>(() => AuthCubit(getIt<AuthRepository>()));

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
