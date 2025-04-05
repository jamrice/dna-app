import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

class SecureStorageService {
  // Flutter Secure Storage 인스턴스 생성 (옵션 적용)
  final FlutterSecureStorage _storage = FlutterSecureStorage(
    aOptions: _getAndroidOptions(),
    iOptions: _getIOSOptions(),
  );

  // 데이터 저장
  Future<void> saveData(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print("Error saving data: $e");
    }
  }

  // 데이터 읽기
  Future<String?> getData(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print("Error reading data: $e");
      return null;
    }
  }

  // 데이터 삭제
  Future<void> deleteData(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print("Error deleting data: $e");
    }
  }

  // 저장소 전체 삭제 (로그아웃 등에 활용)
  Future<void> clearStorage() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print("Error clearing storage: $e");
    }
  }

  // ✅ Android용 보안 옵션 (KeyStore 사용)
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true, // AES-256 암호화 적용
  );

  // ✅ iOS용 보안 옵션 (Keychain 사용)
  static IOSOptions _getIOSOptions() => const IOSOptions(
    accessibility: KeychainAccessibility.first_unlock, // 첫 번째 언락 이후 접근 가능
  );
}
