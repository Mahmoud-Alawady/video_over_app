import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../model/transcript.dart';

class TranscriptRepository {
  final Dio _dio;

  TranscriptRepository(this._dio);

  Future<Transcript> getTranscript(String filename) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';
    final file = File(filePath);

    if (await file.exists()) {
      final content = await file.readAsString();
      return Transcript.fromJson(jsonDecode(content));
    }

    // 1. Get download URL
    final response = await _dio.get(
      '/transcript/download-url',
      queryParameters: {'filename': filename},
    );

    final downloadUrl = response.data['url'];

    // 2. Download file
    final downloadResponse = await Dio().get(
      downloadUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    // 3. Save to file
    await file.writeAsBytes(downloadResponse.data);

    // 4. Parse and return
    final content = await file.readAsString();
    return Transcript.fromJson(jsonDecode(content));
  }
}
