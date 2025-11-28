import 'package:flutter/material.dart';

import 'models.dart';
import 'report_details.dart';
import '../user/utils/app_messages.dart';

class AdminMain extends StatelessWidget {
  const AdminMain({super.key});

  @override
  Widget build(BuildContext context) {
    final reportesFiltrados = reportesDemo
        .where((r) => r.tipo == "normal")
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Panel de administrador")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Reportes pendientes",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // Reportes
          Expanded(
            child: ListView.builder(
              itemCount: reportesFiltrados.length,
              itemBuilder: (context, i) {
                final r = reportesFiltrados[i];
                return ListTile(
                  title: Text(r.categoria),
                  subtitle: Text(r.descripcion),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetalleReportePage(reporte: r),
                      ),
                    );

                    if (result == "approved") {
                      AppMessages().showSuccess(context, "Reporte aprobado");
                    }

                    if (result == "rejected") {
                      AppMessages().showError(context, "Reporte rechazado");
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}