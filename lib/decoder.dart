import 'dart:convert';
import 'dart:developer';
// import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInfo {
  final int id;
  final String email;
  final String name;
  final String role;
  final String avatar;

  TokenInfo({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.avatar,
  });

  factory TokenInfo.fromJson(Map<String, dynamic> jsonData) {
    if (jsonData['id'] == null ||
        jsonData['email'] == null ||
        jsonData['name'] == null ||
        jsonData['role'] == null ||
        jsonData['avatar'] == null) {
      throw ArgumentError('Invalid token data');
    }

    return TokenInfo(
      id: jsonData['id'],
      email: jsonData['email'],
      name: jsonData['name'],
      role: jsonData['role'],
      avatar: jsonData['avatar'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'avatar': avatar,
    };
  }

  static Future<void> saveToPrefs(TokenInfo info) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileData', jsonEncode(info.toJson()));
  }

  static Future<TokenInfo?> loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString('profileData');
    if (jsonStr == null) return null;
    return TokenInfo.fromJson(jsonDecode(jsonStr));
  }
}

TokenInfo? decodeToken(String token) {
  final parts = token.split('.');
  if (parts.length != 3) return null;

  final payload = base64.normalize(parts[1]);
  final decoded = utf8.decode(base64Url.decode(payload));

  try {
    final jsonData = jsonDecode(decoded);
    if (jsonData is Map<String, dynamic>) {
      log('Decoded token: $jsonData');
      return TokenInfo.fromJson(jsonData);
    }
  } catch (e) {
    return null;
  }

  return null;
}
