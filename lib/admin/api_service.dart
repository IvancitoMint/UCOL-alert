import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models.dart';

class ApiService {
  final String baseUrl = "http://192.168.100.25:8000/";

  Future<List<Reporte>> obtenerReportes() async {
    final url = Uri.parse("$baseUrl/reportes");

    final respuesta = await http.get(url);

    if (respuesta.statusCode == 200) {
      final List data = json.decode(respuesta.body);
      return data.map((e) => Reporte.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener reportes");
    }
  }
}