import 'package:shared_preferences/shared_preferences.dart';

class SessionManagerUser {
  static const String _keyUserId = "user_id";
  static const String _keyUserName = "user_name";
  static const String _keyUserEmail = "user_email";
  static const String _keyUserFoto = "user_foto";

  static Future<void> saveUserData(String id, String name, String email, String foto) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, id);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserEmail, email);
    await prefs.setString(_keyUserFoto, foto);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  static Future<String?> getUserFoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserFoto);
  }  

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserFoto);
  }
}
