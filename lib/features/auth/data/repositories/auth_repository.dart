import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:video_over_app/features/auth/data/models/user_model.dart';

class AuthRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;
  final GoogleSignIn _googleSignIn;

  AuthRepository(this._dio, this._storage, this._googleSignIn);

  Future<AuthResponse?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final String? idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Failed to get ID token from Google');
      }
      print(idToken);
      final response = await _dio.post(
        '/auth/google',
        data: {'idToken': idToken},
      );

      if (response.statusCode == 200) {
        final authResponse = AuthResponse.fromJson(response.data);
        await _saveAuthData(authResponse);
        return authResponse;
      } else {
        throw Exception('Failed to sign in with backend');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _saveAuthData(AuthResponse authResponse) async {
    await _storage.write(key: 'token', value: authResponse.token);
    await _storage.write(
      key: 'user',
      value: jsonEncode(authResponse.user.toJson()),
    );
  }

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<UserModel?> getUser() async {
    final userStr = await _storage.read(key: 'user');
    if (userStr == null) return null;
    return UserModel.fromJson(jsonDecode(userStr));
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _storage.delete(key: 'token');
    await _storage.delete(key: 'user');
  }
}
