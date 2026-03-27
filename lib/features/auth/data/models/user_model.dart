class UserModel {
  final int id;
  final String email;
  final String name;
  final String plan;
  final String? avatarUrl;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    required this.plan,
    this.avatarUrl,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final email = json['email'] as String? ?? 'Unknown';
    return UserModel(
      id: json['id'] ?? json['user_id'],
      email: email,
      name: json['name'] ?? email.split('@').first,
      plan: json['plan'] ?? 'free',
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'plan': plan,
      'avatar_url': avatarUrl,
      'created_at': createdAt,
    };
  }
}

class AuthResponse {
  final String token;
  final UserModel user;

  AuthResponse({required this.token, required this.user});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      token: json['token'],
      user: UserModel.fromJson(json['user']),
    );
  }
}
