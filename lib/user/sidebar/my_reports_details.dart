import 'package:flutter/material.dart';
import '../../models.dart';
import '../../reportes_provider.dart';

class DetalleReporteUsuarioPage extends StatelessWidget {
  final Report reporte;

  const DetalleReporteUsuarioPage({super.key, required this.reporte});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle del Reporte")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- CATEGORÍA ----------
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 17, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Categoría: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: reporte.categoria),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- DESCRIPCIÓN ----------
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 17, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Descripción: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: reporte.descripcion),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- AUTOR ----------
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 17, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Reportado por: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: reporte.autor_nombre),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- FECHA ----------
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 17, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Fecha: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text:
                        "${reporte.fecha.creacion.split("T")[0]} "
                        "${reporte.fecha.creacion.split("T")[1].substring(0, 5)}",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // ---------- IMAGEN ----------
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: (reporte.foto.isEmpty)
                  ? Container(
                      height: 230,
                      color: Colors.grey.shade200,
                      child: Center(
                        child: Text(
                          "Sin imagen adjunta",
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  : Image.network(
                      reporte.foto.first,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        height: 230,
                        color: Colors.grey.shade200,
                        child: Center(
                          child: Text(
                            "Error al cargar la imagen",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
