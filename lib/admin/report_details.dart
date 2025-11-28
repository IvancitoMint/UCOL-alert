import 'package:flutter/material.dart';
import 'models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../user/utils/app_messages.dart';

class DetalleReportePage extends StatelessWidget {
  final Reporte reporte;
  const DetalleReportePage({super.key, required this.reporte});

  final String baseUrl = "http://192.168.100.25:8000"; // CAMBIA ESTA IP

  Future<void> validarReporte(BuildContext context) async {
    final url = Uri.parse("$baseUrl/reportes/${reporte.id}");

    final reporteJson = reporte.toJson();

    final body = {
      "id": reporteJson["id"],
      "autor": reporteJson["autor"],
      "estatus": "aceptado", // ACTUALIZADO
      "descripcion": reporteJson["descripcion"],
      "ubicacion": reporteJson["ubicacion"],
      "categoria": reporteJson["categoria"],
      "foto": reporteJson["foto"],
      "likes": reporteJson["likes"],
      "comentarios": reporteJson["comentarios"],
      "emergencia": reporteJson["emergencia"],
      "fecha": reporteJson["fecha"],
    };

    final res = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reporte validado con éxito")),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al validar el reporte")),
      );
    }
  }

  Future<void> eliminarReporte(BuildContext context) async {
    final url = Uri.parse("$baseUrl/reportes/${reporte.id}");

    final res = await http.delete(url);

    if (res.statusCode == 204) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Reporte eliminado")));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al eliminar (${res.statusCode})")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del Reporte")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Categoría: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextSpan(text: reporte.categoria),
                ],
              ),
            ),

            Divider(height: 30, thickness: 1, color: Colors.grey[300]),

            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Descripción: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextSpan(text: reporte.descripcion),
                ],
              ),
            ),

            Divider(height: 30, thickness: 1, color: Colors.grey[300]),

            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Reportado por: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextSpan(text: reporte.autor),
                ],
              ),
            ),

            Divider(height: 30, thickness: 1, color: Colors.grey[300]),

            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Fecha: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextSpan(text: reporte.fecha.creacion),
                ],
              ),
            ),

            Divider(height: 30, thickness: 1, color: Colors.grey[300]),

            Container(
              height: 230,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: Center(
                child: Text(
                  "Foto de evidencia (aún no implementada)",
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            ),

            const Spacer(),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    "Validar",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => validarReporte(context),
                ),

                ElevatedButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    "Eliminar",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => eliminarReporte(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}