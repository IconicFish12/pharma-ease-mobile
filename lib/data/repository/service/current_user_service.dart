import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class CurrentUserService {
  final _storageKey = const FlutterSecureStorage();
  final _key = 'userId_key';

  Future<void> saveUserId(String token) async {
    await _storageKey.write(key: _key, value: token);
  }

  Future<String?> getUserId() async {
    return await _storageKey.read(key: _key);
  }

  Future<void> deleteUserId() async {
    await _storageKey.delete(key: _key);
  }
}