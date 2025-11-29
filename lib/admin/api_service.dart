import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';
import '../main.dart';

class ApiService {
  Future<List<Reporte>> obtenerReportes() async {
    final url = Uri.parse("${ip}reportes");

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final List data = json.decode(respuesta.body);
      return data.map((e) => Reporte.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener reportes");
    }
  }
}