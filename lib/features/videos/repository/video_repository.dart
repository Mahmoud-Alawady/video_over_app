import 'dart:io';
import 'package:dio/dio.dart';
import '../models/video.dart';

class VideoRepository {
  final Dio _dio;

  VideoRepository(this._dio);

  Future<List<Video>> fetchVideos() async {
    try {
      final response = await _dio.get('/videos');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List<dynamic>;
        return data
            .map((e) => Video.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load videos (status ${response.statusCode})',
        );
      }
    } on DioException catch (e) {
      if (e.error is SocketException) {
        throw Exception('No internet connection');
      }
      throw Exception(e.message);
    }
  }
}
