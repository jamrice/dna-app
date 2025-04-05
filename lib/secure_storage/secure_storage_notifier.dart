
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// StateNotifier 정의
class SecureStorageNotifier extends StateNotifier<Map<String, String>?> {
  final _storage = const FlutterSecureStorage();

  SecureStorageNotifier() : super(null) {
    _init();
  }

  // 초기화 함수
  Future<void> _init() async {
    try {
      // 저장된 모든 값을 로드
      final allValues = await _storage.readAll();
      if (allValues.isNotEmpty) {
        state = allValues;
      }
    } catch (e) {
      debugPrint('SecureStorage 초기화 오류: $e');
      state = {};
    }
  }

  // 값 저장
  Future<void> save(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);

      // 현재 상태 업데이트
      final currentState = state ?? {};
      state = {...currentState, key: value};

      debugPrint('✅ 토큰 저장 성공 - $key: $value');
    } catch (e) {
      debugPrint('❌ 토큰 저장 실패: $e');
    }
  }

  // 값 로드
  Future<String?> load(String key) async {
    try {
      // 상태에서 먼저 확인
      if (state != null && state!.containsKey(key)) {
        return state![key];
      }

      // 저장소에서 직접 로드
      final value = await _storage.read(key: key);

      // 상태 업데이트
      if (value != null) {
        final currentState = state ?? {};
        state = {...currentState, key: value};
      }

      return value;
    } catch (e) {
      debugPrint('❌ 토큰 로드 실패: $e');
      return null;
    }
  }

  // 값 삭제
  Future<void> delete(String key) async {
    try {
      await _storage.delete(key: key);

      // 상태에서도 삭제
      if (state != null && state!.containsKey(key)) {
        final newState = Map<String, String>.from(state!);
        newState.remove(key);
        state = newState;
      }

      debugPrint('✅ 토큰 삭제 성공: $key');
    } catch (e) {
      debugPrint('❌ 토큰 삭제 실패: $e');
    }
  }

  // 모든 값 삭제
  Future<void> deleteAll() async {
    try {
      await _storage.deleteAll();
      state = {};
      debugPrint('✅ 모든 토큰 삭제 성공');
    } catch (e) {
      debugPrint('❌ 모든 토큰 삭제 실패: $e');
    }
  }
}

// Provider 정의
final secureStorageProvider = StateNotifierProvider<SecureStorageNotifier, Map<String, String>?>((ref) {
  return SecureStorageNotifier();
});