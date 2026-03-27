import 'dart:convert';
import 'package:dio/dio.dart';
import '../model/transcript.dart';

import 'package:video_over_app/features/auth/data/repositories/auth_repository.dart';

class TranscriptRepository {
  final Dio _dio;
  final AuthRepository _authRepository;

  TranscriptRepository(this._dio, this._authRepository);

  Future<Transcript> getTranscript(String filename) async {
    // 1. Get download URL
    final token = await _authRepository.getToken();
    final response = await _dio.get(
      '/transcript/download-url',
      queryParameters: {'filename': filename},
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );

    final downloadUrl = response.data['url'];

    // 2. Download file
    final downloadResponse = await Dio().get(downloadUrl);

    // 3. Parse and return
    final dynamic data = downloadResponse.data;
    final Map<String, dynamic> json = data is String ? jsonDecode(data) : data;
    final transcript = Transcript.fromJson(json);
    return transcript;
  }
}
