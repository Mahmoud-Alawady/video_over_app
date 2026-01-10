import 'package:flutter/material.dart';
import 'package:video_over_app/const/app_theme.dart';
import 'package:video_over_app/core/di.dart';
import 'package:video_over_app/features/levels/presentation/levels_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Video Over',
      theme: AppTheme.darkTheme,
      home: LevelsPage(),
    );
  }
}


      // BlocProvider(
      //   create: (_) => PositionCubit(),
      //   child: const VideoPage(),
      // ),
