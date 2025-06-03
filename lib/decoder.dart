import 'dart:convert';
import 'dart:developer';
import 'package:shared_preferences/shared_preferences.dart';

class TokenInfo {
  final String nameId;
  final String username;
  final String position;
  final int exp;

  TokenInfo({
    required this.nameId,
    required this.username,
    required this.position,
    required this.exp,
  });

  static Future<void> saveTokenInfoo(TokenInfo tokenInfo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nameId', tokenInfo.nameId);
    await prefs.setString('username', tokenInfo.username);
    await prefs.setString('position', tokenInfo.position);
    await prefs.setInt('exp', tokenInfo.exp);
  }

  factory TokenInfo.fromJson(Map<String, dynamic> jsonData) {
    if (jsonData['nameid'] == null ||
        jsonData['unique_name'] == null ||
        jsonData['Position'] == null ||
        jsonData['exp'] == null) {
      throw ArgumentError('Invalid------- token------ data');
    }

    return TokenInfo(
      nameId: jsonData['nameid'],
      username: jsonData['unique_name'],
      position: jsonData['Position'],
      exp: jsonData['exp'],
    );
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
      log('Decoded token: $jsonData', name: 'decodeToken');

      return TokenInfo.fromJson(jsonData);
    }
  } catch (e) {
    return null;
  }

  return null;
}
