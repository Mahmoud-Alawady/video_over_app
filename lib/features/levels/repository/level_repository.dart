import 'dart:io';

import 'package:dio/dio.dart';

import '../models/level.dart';

class LevelRepository {
  final Dio _dio;

  LevelRepository(this._dio);

  Future<List<Level>> fetchLevels() async {
    try {
      final response = await _dio.get('/levels');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List<dynamic>;
        return data
            .map((e) => Level.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load levels (status ${response.statusCode})',
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
