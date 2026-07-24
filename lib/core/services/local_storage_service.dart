// TODO: Wrap local storage operations here.
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String userRoleKey = 'user_role';
  static const String userIdKey = 'user_id';

  Future<void> saveUserRole(String role) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      userRoleKey,
      role,
    );
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(userRoleKey);
  }

  Future<void> saveUserId(String uid) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      userIdKey,
      uid,
    );
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getString(userIdKey);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.clear();
  }
}