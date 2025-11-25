import 'package:flutter/material.dart';
import 'models.dart';
import 'reportDetails.dart';

class ReportsPage extends StatelessWidget {
  final String tipo;

  const ReportsPage({super.key, required this.tipo});

  @override
  Widget build(BuildContext context) {
    final reportesFiltrados = reportesDemo
        .where((r) => r.tipo == tipo)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text("Reportes ${tipo == 'normal' ? 'Normales' : 'Urgentes'}"),
      ),
      body: ListView.builder(
        itemCount: reportesFiltrados.length,
        itemBuilder: (context, i) {
          final r = reportesFiltrados[i];
          return ListTile(
            title: Text(r.categoria),
            subtitle: Text(r.descripcion),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetalleReportePage(reporte: r),
                ),
              );
            },
          );
        },
      ),
    );
  }
}