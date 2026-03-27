import 'package:dio/dio.dart';
import '../model/starred_word.dart';
import '../../auth/data/repositories/auth_repository.dart';

class StarredWordsRepository {
  final Dio _dio;
  final AuthRepository _authRepository;

  StarredWordsRepository(this._dio, this._authRepository);

  Future<List<StarredWord>> getStarredWords() async {
    final token = await _authRepository.getToken();
    final response = await _dio.get(
      '/starred-words',
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = response.data as List<dynamic>;
      return data
          .map((e) => StarredWord.fromJson(e as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Failed to fetch starred words: ${response.statusCode}');
    }
  }

  Future<StarredWord> starWord(String word, String meaning) async {
    final token = await _authRepository.getToken();
    final response = await _dio.post(
      '/starred-words',
      data: {'word': word, 'meaning': meaning},
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );

    if (response.statusCode == 201) {
      return StarredWord.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw Exception('Failed to star word: ${response.statusCode}');
    }
  }

  Future<void> unstarWord(String word) async {
    final token = await _authRepository.getToken();
    final response = await _dio.delete(
      '/starred-words',
      data: {'word': word},
      options: Options(
        headers: token != null ? {'Authorization': 'Bearer $token'} : null,
      ),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to unstar word: ${response.statusCode}');
    }
  }
}
