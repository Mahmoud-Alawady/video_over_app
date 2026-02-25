import 'dart:io';

import 'package:dio/dio.dart';

import '../models/section.dart';

class SectionRepository {
  final Dio _dio;

  SectionRepository(this._dio);

  Future<List<Section>> fetchSections() async {
    try {
      final response = await _dio.get('/sections');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data as List<dynamic>;
        return data
            .map((e) => Section.fromJson(e as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception(
          'Failed to load sections (status ${response.statusCode})',
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
