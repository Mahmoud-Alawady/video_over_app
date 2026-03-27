import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_over_app/features/auth/data/repositories/auth_repository.dart';
import 'package:video_over_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:video_over_app/features/player_page/cubit/transcript_cubit.dart';
import 'package:video_over_app/features/player_page/cubit/starred_words_cubit.dart';
import 'package:video_over_app/features/player_page/repository/transcript_repository.dart';
import 'package:video_over_app/features/player_page/repository/starred_words_repository.dart';
import 'package:video_over_app/features/videos/cubit/video_cubit.dart';
import 'package:video_over_app/features/videos/repository/video_repository.dart';
import '../features/sections/cubit/section_cubit.dart';
import '../features/sections/repository/section_repository.dart';
import '../features/profile/data/repositories/profile_repository.dart';
import '../features/profile/presentation/cubit/profile_cubit.dart';
import 'services/audio_cache_service.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Core
  getIt.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );

  getIt.registerLazySingleton<Dio>(
    () => Dio(BaseOptions(baseUrl: 'https://api.video-over.workers.dev')),
  );

  getIt.registerLazySingleton<AudioCacheService>(
    () => AudioCacheService(getIt<Dio>(), getIt<AuthRepository>()),
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

  // Sections
  getIt.registerLazySingleton<SectionRepository>(
    () => SectionRepository(getIt()),
  );
  getIt.registerFactory<SectionCubit>(
    () => SectionCubit(getIt<SectionRepository>()),
  );

  // Videos
  getIt.registerLazySingleton<VideoRepository>(() => VideoRepository(getIt()));
  getIt.registerFactory<VideoCubit>(() => VideoCubit(getIt<VideoRepository>()));

  getIt.registerLazySingleton<TranscriptRepository>(
    () => TranscriptRepository(getIt(), getIt()),
  );
  getIt.registerLazySingleton<StarredWordsRepository>(
    () => StarredWordsRepository(getIt(), getIt()),
  );
  getIt.registerFactory<TranscriptCubit>(
    () => TranscriptCubit(getIt<TranscriptRepository>()),
  );
  getIt.registerFactory<StarredWordsCubit>(
    () => StarredWordsCubit(getIt<StarredWordsRepository>()),
  );

  // Profile
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepository(getIt(), getIt()),
  );
  getIt.registerFactory<ProfileCubit>(
    () => ProfileCubit(getIt<ProfileRepository>()),
  );
}
