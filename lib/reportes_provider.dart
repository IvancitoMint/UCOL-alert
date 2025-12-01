import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// Modelo del backend
import 'models.dart';

// Modelo para la UI
import 'user/models/report_model.dart';
import 'user/models/likes_model.dart';

import '../main.dart';

class ReportesProvider extends ChangeNotifier {
  final String currentUserId = "user123"; // simulado
  List<Report> _reportesBackend = []; // crudo del backend
  List<ReportModel> _reportesUI = []; // listo para UI

  final String apiUrl = "${ip}reportes";
  final String apiUsuario = "${ip}users";

  bool cargando = false;

  List<Report> get reportes => _reportesBackend;

  // =====================================================
  //               CARGAR REPORTES
  // =====================================================
  Future<void> cargarReportes() async {
    cargando = true;
    notifyListeners();

    final res = await http.get(Uri.parse(apiUrl));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);

      // 1. Cargar crudo
      _reportesBackend = data.map((e) => Report.fromJson(e)).toList();

      // 2. Convertir a ReportModel (UI)
      _reportesUI = _reportesBackend.map((r) {
        return ReportModel(
          id: r.id,
          usuario: r.autor,
          avatarUrl: r.foto.first ?? "",
          tiempo: r.fecha.creacion,
          ubicacion: r.ubicacion,
          estado: r.estatus,
          descripcion: r.descripcion,
          categoria: r.categoria,
          imagenUrl: r.foto.first ?? "",
          likes: r.likes,
          comments: r.comentarios.length,
        );
      }).toList();
    }

    cargando = false;
    notifyListeners();
  }

  // =====================================================
  //       CARGAR USUARIOS DE LISTA DE LIKES
  // =====================================================
  Future<List<LikeUser>> cargarUsuariosDeLikes(List likes) async {
    List<LikeUser> listaUsuarios = [];

    for (var userId in likes) {
      final res = await http.get(Uri.parse("$apiUsuario/$userId"));

      if (res.statusCode == 200) {
        final data = json.decode(res.body);
        listaUsuarios.add(
          LikeUser(
            name: data["nombre"] ?? "Usuario desconocido",
            photoUrl:
                data["foto"] ??
                "https://cdn-icons-png.flaticon.com/512/149/149071.png",
          ),
        );
      }
    }

    return listaUsuarios;
  }

  // =====================================================
  //          ACTUALIZAR LIKES EN UI
  // =====================================================
  void actualizarLikes(String reportId, List likes) {
    final index = _reportesUI.indexWhere((r) => r.usuario == reportId);

    if (index != -1) {
      final r = _reportesUI[index];
      _reportesUI[index] = ReportModel(
        id: r.id,
        usuario: r.usuario,
        avatarUrl: r.avatarUrl,
        tiempo: r.tiempo,
        ubicacion: r.ubicacion,
        estado: r.estado,
        descripcion: r.descripcion,
        categoria: r.categoria,
        imagenUrl: r.imagenUrl,
        likes: likes,
        comments: r.comments,
      );
      notifyListeners();
    }
  }

  Future<void> actualizarReporteCompleto(Report reporte) async {
    final url = Uri.parse("$apiUrl/${reporte.id}");

    final body = jsonEncode({
      "id": reporte.id,
      "autor": reporte.autor,
      "estatus": reporte.estatus,
      "descripcion": reporte.descripcion,
      "ubicacion": reporte.ubicacion,
      "categoria": reporte.categoria,
      "foto": reporte.foto,
      "likes": reporte.likes,
      "comentarios": reporte.comentarios,
      "emergencia": reporte.emergencia,
      "fecha": {
        "creacion": reporte.fecha.creacion,
        "actualizacion": DateTime.now().toIso8601String(),
      },
    });

    final res = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: body,
    );

    if (res.statusCode == 200) {
      print("Reporte actualizado correctamente.");
    } else {
      print("Error al actualizar reporte: ${res.body}");
    }
  }

  Future<void> updateLikes(
    Report reporteBackend,
    List<String> nuevosLikes,
  ) async {
    final url = Uri.parse("${ip}reportes/${reporteBackend.id}");

    // Crear copia actualizada
    final cuerpo = reporteBackend.toJson();
    cuerpo["likes"] = nuevosLikes;

    final res = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cuerpo),
    );

    if (res.statusCode == 200) {
      // Actualiza en memoria
      final index = _reportesUI.indexWhere((r) => r.id == reporteBackend.id);
      if (index != -1) {
        _reportesBackend[index] = Report.fromJson(jsonDecode(res.body));
      }

      notifyListeners();
    }
  }

  Future<void> toggleLike(String reportId, String userId) async {
    try {
      final res = await http.put(
        Uri.parse("$apiUrl/likes?reporte_id=$reportId&user_id=$userId"),
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body);

        // Buscar reporte en la lista
        final index = _reportesUI.indexWhere((r) => r.id == reportId);
        if (index != -1) {
          _reportesUI[index].likes = List<String>.from(data["likes"]);
          notifyListeners();
        }
      }
    } catch (e) {
      print("Error toggling like: $e");
    }
  }

  void agregarReporte(Report r) {
    _reportesBackend.insert(0, r);
    notifyListeners();
  }

  void eliminarReporte(String id) {
    _reportesBackend.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
