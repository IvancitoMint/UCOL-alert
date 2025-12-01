import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../reportes_provider.dart';
import 'package:provider/provider.dart';
import '../../user/utils/session_manager.dart';
import 'my_reports_details.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  String? userId;

  @override
  void initState() {
    super.initState();
    loadUserId();

    // Cargar reportes desde la API
    Future.microtask(() {
      Provider.of<ReportesProvider>(context, listen: false).cargarReportes();
    });
  }

  Future<void> loadUserId() async {
    userId = await SessionManagerUser.getUserId();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ReportesProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Mis Reportes"), elevation: 0),
      body: Column(
        children: [
          const Padding(padding: EdgeInsets.all(16)),

          Expanded(
            child: Builder(
              builder: (_) {
                if (provider.cargando || userId == null) {
                  return const Center(child: CircularProgressIndicator());
                }

                final reportesPendientes = provider.reportes
                    .where((r) => r.autor == userId)
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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetalleReporteUsuarioPage(reporte: r),
                          ),
                        );
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
