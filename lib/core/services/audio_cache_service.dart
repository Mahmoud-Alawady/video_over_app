import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

import 'package:video_over_app/features/auth/data/repositories/auth_repository.dart';

class AudioCacheService {
  final Dio _dio;
  final AuthRepository _authRepository;
  Directory? _cacheDir;

  AudioCacheService(this._dio, this._authRepository);

  Future<void> _init() async {
    if (_cacheDir != null) return;
    final appDir = await getApplicationDocumentsDirectory();
    _cacheDir = Directory('${appDir.path}/voice_notes');
    if (!await _cacheDir!.exists()) {
      await _cacheDir!.create(recursive: true);
    }
  }

  Future<File> getAudioFile(String voiceKey) async {
    await _init();

    final file = File('${_cacheDir!.path}/$voiceKey');
    final tempFile = File('${file.path}.temp');

    if (await file.exists()) {
      return file;
    }

    try {
      if (await tempFile.exists()) {
        await tempFile.delete();
      }

      // Step 1: Get download URL from API
      final token = await _authRepository.getToken();
      final response = await _dio.get(
        '/transcript/download-url?filename=$voiceKey',
        options: Options(
          headers: token != null ? {'Authorization': 'Bearer $token'} : null,
        ),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get download URL: ${response.statusCode}');
      }

      final downloadUrl = response.data['url'];
      if (downloadUrl == null) {
        throw Exception('Download URL not found in response');
      }

      // Step 2: Download the file
      await _dio.download(downloadUrl, tempFile.path);
      await tempFile.rename(file.path);
      return file;
    } catch (e) {
      if (kDebugMode) print("Error downloading audio: $e");
      if (await tempFile.exists()) {
        await tempFile.delete();
      }
      rethrow;
    }
  }
}
