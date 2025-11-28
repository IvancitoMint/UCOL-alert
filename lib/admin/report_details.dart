import 'package:flutter/material.dart';
import 'models.dart';

class DetalleReportePage extends StatelessWidget {
  final Reporte reporte;
  const DetalleReportePage({super.key, required this.reporte});

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
                    text: "Categoria: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextSpan(
                    text: reporte.categoria,
                    style: TextStyle(fontSize: 16),
                  ),
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
                  TextSpan(
                    text: reporte.descripcion,
                    style: TextStyle(fontSize: 16),
                  ),
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
                  TextSpan(
                    text: reporte.usuario,
                    style: TextStyle(fontSize: 16),
                  ),
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
                  TextSpan(text: reporte.fecha, style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            Divider(height: 30, thickness: 1, color: Colors.grey[300]),
            RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 16, color: Colors.black),
                children: [
                  const TextSpan(
                    text: "Detalles: ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  TextSpan(
                    text: reporte.detalles,
                    style: const TextStyle(fontSize: 16),
                  ),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Foto de evidencia de ejemplo w",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(),

            // BUTTONS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.check, color: Colors.white),
                  label: const Text(
                    "Aceptar",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    //---------- GET BACK TO home_page ---------- //
                    Navigator.pop(context, "approved");
                  },
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text(
                    "Eliminar",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    backgroundColor: const Color.fromARGB(255, 220, 20, 60),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pop(context, "rejected");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}