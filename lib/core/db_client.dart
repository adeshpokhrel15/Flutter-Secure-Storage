import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final dbProvider = Provider<DbClient>((ref) {
  return DbClient();
});

class DbClient {
  getData({required String dbKey}) async {
    const storage = FlutterSecureStorage();
    final result = await storage.read(key: dbKey);
    return result;
  }

  saveData({required String dbKey, required String dbValue}) async {
    const storage = FlutterSecureStorage();
    await storage.write(
      key: dbKey,
      value: dbValue,
    );
  }

  resetDb() async {
    const storage = FlutterSecureStorage();
    await storage.deleteAll();
  }
}
