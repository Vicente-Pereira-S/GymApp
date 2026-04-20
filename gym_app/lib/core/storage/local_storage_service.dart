import 'package:hive_flutter/hive_flutter.dart';
import 'package:gym_app/core/storage/app_storage_keys.dart';

class LocalStorageService {
  static Box<dynamic> get _box => Hive.box<dynamic>(AppStorageKeys.appBox);

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox<dynamic>(AppStorageKeys.appBox);
  }

  static dynamic read(String key) {
    return _box.get(key);
  }

  static Future<void> write(String key, dynamic value) async {
    await _box.put(key, value);
  }

  static Future<void> delete(String key) async {
    await _box.delete(key);
  }

  static Future<void> clearAll() async {
    await _box.clear();
  }
}
