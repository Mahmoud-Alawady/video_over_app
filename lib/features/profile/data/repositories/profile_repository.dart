import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:video_over_app/features/auth/data/models/user_model.dart';
import 'package:video_over_app/features/auth/data/repositories/auth_repository.dart';

class ProfileRepository {
  final Dio _dio;
  final AuthRepository _authRepository;

  ProfileRepository(this._dio, this._authRepository);

  Future<UserModel> getMe() async {
    final token = await _authRepository.getToken();
    if (token == null) throw Exception('No token found');

    final response = await _dio.get(
      '/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode == 200) {
      if (kDebugMode) print(token);
      if (kDebugMode) print(response.data);
      return UserModel.fromJson(response.data);
    } else {
      throw Exception('Failed to fetch user profile');
    }
  }

  Future<void> deleteMe() async {
    final token = await _authRepository.getToken();
    if (token == null) throw Exception('No token found');

    final response = await _dio.delete(
      '/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete account');
    }
  }
}
