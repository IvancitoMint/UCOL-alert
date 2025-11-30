import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'report_details.dart';
import '../../reportes_provider.dart';
import '../../user/utils/app_messages.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  @override
  void initState() {
    super.initState();

    // Cargar reportes una sola vez
    Future.microtask(() {
      Provider.of<ReportesProvider>(context, listen: false).cargarReportes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Panel de administrador")),

      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Reportes No revisados",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          Expanded(
            child: Builder(
              builder: (_) {
                if (provider.cargando) {
                  return const Center(child: CircularProgressIndicator());
                }

                // FILTRADO (tal como antes)
                final reportesPendientes = provider.reportes
                    .where((r) => r.emergencia == false)
                    .where((r) => r.estatus == "No revisado")
                    .toList();

                if (reportesPendientes.isEmpty) {
                  return const Center(
                    child: Text("No hay reportes pendientes."),
                  );
                }

                return ListView.builder(
                  itemCount: reportesPendientes.length,
                  itemBuilder: (_, i) {
                    final r = reportesPendientes[i];

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

                        // ⬇️ Nuevo: mostrar mensajes según resultado
                        if (result == "Validado") {
                          AppMessages().showSuccess(context,"Reporte validado con éxito");
                        }

                        if (result == "Eliminado") {
                          AppMessages().showSuccess(context,"Reporte eliminado correctamente");
                        }
                      },
                    );
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
