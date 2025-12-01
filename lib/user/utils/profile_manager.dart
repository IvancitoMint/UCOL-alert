import 'package:shared_preferences/shared_preferences.dart';

class ProfileManager {
  static const String _keyUserFoto = "user_foto";
  static const String _keyUserName = "user_name";
  static const String _keyUserRol = "user_rol";
  static const String _keyUserReportes = "user_reportes";
  static const String _keyUserReportesResueltos = "user_resportes_resueltos";
  static const String _keyUserLikes = "user_likes";


  static Future<void> saveProfileData(String foto, String name, String rol, String reportes, String reportes_resueltos, String likes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserFoto, foto);
    await prefs.setString(_keyUserName, name);
    await prefs.setString(_keyUserRol, rol);
    await prefs.setString(_keyUserReportes, reportes);
    await prefs.setString(_keyUserReportesResueltos, reportes_resueltos);
    await prefs.setString(_keyUserLikes, likes);
  }

  static Future<String?> getUserFoto() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserFoto);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  static Future<String?> getUserRol() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRol);
  }

  static Future<String?> getUserReportes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserReportes);
  }

  static Future<String?> getUserReportesResueltos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserReportesResueltos);
  }

  static Future<String?> getUserLikes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserLikes);
  }  

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserName);
    await prefs.remove(_keyUserRol);
    await prefs.remove(_keyUserReportes);
    await prefs.remove(_keyUserReportesResueltos);
    await prefs.remove(_keyUserLikes);
  }
}