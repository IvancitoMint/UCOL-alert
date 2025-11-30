import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models.dart';
import '../main.dart';

class ReportesProvider extends ChangeNotifier {
  List<Reporte> _reportes = [];
  bool cargando = false;

  List<Reporte> get reportes => _reportes;

  final String apiUrl = "${ip}reportes";

  Future<void> cargarReportes() async {
    cargando = true;
    notifyListeners();

    final res = await http.get(Uri.parse(apiUrl));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);

      _reportes = data.map((e) => Reporte.fromJson(e)).toList();
    }

    cargando = false;
    notifyListeners();
  }

  void agregarReporte(Reporte r) {
    _reportes.insert(0, r);
    notifyListeners();
  }

  void eliminarReporte(String id) {
    _reportes.removeWhere((r) => r.id == id);
    notifyListeners();
  }
}
