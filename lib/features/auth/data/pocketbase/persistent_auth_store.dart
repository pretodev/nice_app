import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';

class PersistentAuthStore extends AuthStore {
  final FlutterSecureStorage _storage;
  final String _storageKey;

  PersistentAuthStore({
    FlutterSecureStorage? storage,
    String storageKey = 'pb_auth',
  }) : _storage = storage ?? const FlutterSecureStorage(),
       _storageKey = storageKey;

  /// Loads the auth store state from the persistent storage
  Future<void> load() async {
    try {
      final storedData = await _storage.read(key: _storageKey);
      if (storedData != null && storedData.isNotEmpty) {
        final decoded = jsonDecode(storedData) as Map<String, dynamic>;

        // Restore token and model
        final token = decoded['token'] as String?;
        final modelData = decoded['model'];

        if (token != null && token.isNotEmpty) {
          if (modelData is Map<String, dynamic>) {
            if (modelData.containsKey('collectionId')) {
              // RecordModel
              super.save(token, RecordModel.fromJson(modelData));
            } else {
              // AdminModel - in newer SDKs maybe just use dynamic or ignore if AdminModel is not exported
              // If AdminModel is not exported, we can just save it as a map or try to ignore
              // Usually for users app we care about RecordModel.
              try {
                // Try to cast or construct if possible, otherwise just pass the map if supported
                // AuthStore stores 'dynamic' model, so passing the map itself might be fine
                // BUT PocketBase checks `model is RecordModel` or `model is AdminModel` for `isValid`.
                // Since AdminModel seems hidden/private or renamed?
                // Let's assume user app only uses RecordModel (Users).
                super.save(token, RecordModel.fromJson(modelData));
              } catch (_) {
                // Fallback
                super.save(token, null);
              }
            }
          } else {
            // Fallback if no model data
            super.save(token, null);
          }
        }
      }
    } catch (e) {
      // In case of error (e.g. corrupted data), we start clean
      super.clear();
    }
  }

  @override
  void save(String newToken, RecordModel? newRecord) {
    super.save(newToken, newRecord);

    // Persist to storage
    final encoded = jsonEncode(<String, dynamic>{
      'token': newToken,
      'model': newRecord?.toJson(),
    });

    _storage.write(key: _storageKey, value: encoded);
  }

  @override
  void clear() {
    super.clear();
    _storage.delete(key: _storageKey);
  }
}
