import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../utils/session_manager.dart';
import '../../main.dart'; // o donde tengas "ip"

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? userId;

  // Datos del usuario (stats)
  String nombre = "";
  String rol = "";
  String fotoPerfil = "";
  int reportesTotales = 0;
  int reportesResueltos = 0;
  int likesDados = 0;

  bool loading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future<void> loadProfile() async {
    try {
      final id = await SessionManagerUser.getUserId();

      // Depuración rápida
      print(">>> ProfilePage: userId desde SharedPreferences: <$id>");

      if (id == null || id.trim().isEmpty) {
        setState(() {
          loading = false;
          errorMessage = "No se encontró el ID del usuario. Inicia sesión de nuevo.";
        });
        return;
      }

      userId = id.trim();

      // Asegúrate de que 'ip' termine con '/' o construye la URL de forma segura:
      final base = ip.endsWith("/") ? ip : "$ip/";
      final url = Uri.parse("${base}users/$userId/stats");

      print(">>> ProfilePage: llamando a URL -> $url");

      final res = await http.get(url);

      print(">>> ProfilePage: statusCode = ${res.statusCode}");
      print(">>> ProfilePage: body = ${res.body}");

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        setState(() {
          fotoPerfil = data["foto_perfil"] ?? "";
          nombre = data["nombre_completo"] ?? "";
          rol = data["rol"] ?? "";
          reportesTotales = data["reportes_totales"] ?? 0;
          reportesResueltos = data["reportes_resueltos"] ?? 0;
          likesDados = data["likes_dados"] ?? 0;
          loading = false;
          errorMessage = null;
        });
      } else {
        // Mostrar error con detalle del backend
        setState(() {
          loading = false;
          errorMessage =
              "Error al obtener perfil: ${res.statusCode} - ${res.body}";
        });
      }
    } catch (e, st) {
      print(">>> ProfilePage: excepción en loadProfile: $e\n$st");
      setState(() {
        loading = false;
        errorMessage = "Error de red o de parsing: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        elevation: 0,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : (errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Center(
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: fotoPerfil.isNotEmpty
                              ? NetworkImage(fotoPerfil)
                              : const AssetImage("assets/profile.jpg")
                                  as ImageProvider,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          nombre.isNotEmpty ? nombre : "Sin nombre",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(rol.isNotEmpty ? rol : ""),
                        const Divider(height: 30),
                        Text(
                          "$reportesTotales  Reportes   |   "
                          "$reportesResueltos  Resueltos   |   "
                          "$likesDados  Me gusta",
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
