import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenService {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
    resetOnError: true,
  );

  late final FlutterSecureStorage _storageKey;
  final _key = 'auth_token';

  TokenService() {
    _storageKey = FlutterSecureStorage(aOptions: _getAndroidOptions());
  }

  Future<void> saveToken(String token) async {
    try {
      await _storageKey.write(key: _key, value: token);
    } catch (e) {
      await _storageKey.deleteAll();
      await _storageKey.write(key: _key, value: token);
    }
  }

  Future<String?> getToken() async {
    try {
      return await _storageKey.read(key: _key);
    } catch (e) {
      await _storageKey.deleteAll();
      return null;
    }
  }

  Future<void> deleteToken() async {
    try {
      await _storageKey.delete(key: _key);
    } catch (e) {
      await _storageKey.deleteAll();
    }
  }
}