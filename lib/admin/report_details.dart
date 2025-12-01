import 'package:flutter/material.dart';
import '../models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../main.dart';
import '../reportes_provider.dart';
import 'package:provider/provider.dart';

class DetalleReportePage extends StatelessWidget {
  final Report reporte;
  const DetalleReportePage({super.key, required this.reporte});

  Future<void> validarReporte(BuildContext context) async {
    final url = Uri.parse("${ip}reportes/${reporte.id}");

    final reporteJson = reporte.toJson();
    final body = {...reporteJson, "estatus": "Pendiente"};
    //Los estatus de los reportes, son: 'No revisado' => 'Pendiente' => 'Resuelto'
    print(body);
    final res = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (res.statusCode == 200) {
      // ❗ Quitar el reporte validado
      Provider.of<ReportesProvider>(
        context,
        listen: false,
      ).eliminarReporte(reporte.id);

      Navigator.pop(context, "Validado");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al validar el reporte")),
      );
    }
  }

  Future<void> eliminarReporte(BuildContext context) async {
    final url = Uri.parse("${ip}reportes/${reporte.id}");

    final res = await http.delete(url);

    if (res.statusCode == 204) {
      // ❗ Eliminar de la lista local también
      Provider.of<ReportesProvider>(
        context,
        listen: false,
      ).eliminarReporte(reporte.id);

      Navigator.pop(context, "Eliminado");
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
<<<<<<< HEAD
                  TextSpan(text: "${reporte.fecha.creacion.split("T")[0]} ${reporte.fecha.creacion.split("T")[1].substring(0,5)}"),
=======
                  TextSpan(text: "${reporte.fecha.creacion.split("T")[0]} ${reporte.fecha.creacion.split("T")[1].substring(0, 5)}"),
>>>>>>> d6ff12fd254eac411d4707a57fbc1676433a8502
                ],
              ),
            ),

            Divider(height: 30, thickness: 1, color: Colors.grey[300]),

            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: reporte.foto.first == null || reporte.foto.isEmpty
                  ? Container(
                      height: 230,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        border: Border.all(color: Colors.black12),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          "Sin imagen adjunta",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  : Image.network(
                      reporte.foto.first,
                      height: 230,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 230,
                          color: Colors.grey.shade200,
                          child: Center(
                            child: Text(
                              "Error al cargar la imagen",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ),
                        );
                      },
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
