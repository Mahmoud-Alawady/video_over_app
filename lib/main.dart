import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_over_app/const/app_theme.dart';
import 'package:video_over_app/core/di.dart';
import 'package:video_over_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:video_over_app/features/auth/presentation/pages/login_page.dart';
import 'package:video_over_app/features/sections/presentation/sections_page.dart';
import 'package:video_over_app/features/profile/presentation/pages/profile_page.dart';
import 'package:video_over_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:video_over_app/features/player_page/presentation/pages/starred_words_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  // com.rootbit.videoover
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => getIt<AuthCubit>()..checkAuthStatus(),
        ),
        BlocProvider(create: (context) => getIt<ProfileCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Video Over',
        theme: AppTheme.darkTheme,
        home: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const SectionsPage();
            }
            if (state is AuthUnauthenticated || state is AuthError) {
              return const LoginPage();
            }
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          },
        ),
        routes: {
          '/sections': (context) => const SectionsPage(),
          '/login': (context) => const LoginPage(),
          '/profile': (context) => const ProfilePage(),
          '/starred-words': (context) => const StarredWordsPage(),
        },
      ),
    );
  }
}
