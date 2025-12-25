import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  final _storageKey = const FlutterSecureStorage();
  final _key = 'auth_token';

  Future<void> saveToken(String token) async {
    await _storageKey.write(key: _key, value: token);
  }

  Future<String?> getToken() async {
    return await _storageKey.read(key: _key);
  }

  Future<void> deleteToken() async {
    await _storageKey.delete(key: _key);
  }
}