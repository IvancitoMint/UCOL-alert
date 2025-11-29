import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'models.dart'; // Modelo Reporte + Fecha
import 'report_details.dart'; // Pantalla de detalles
import '../main.dart';

class AdminMain extends StatefulWidget {
  const AdminMain({super.key});

  @override
  State<AdminMain> createState() => _AdminMainState();
}

class _AdminMainState extends State<AdminMain> {
  late Future<List<Reporte>> futureReportes;

  // URL de FastAPI
  final String apiUrl = "${ip}reportes";

  @override
  void initState() {
    super.initState();
    futureReportes = fetchReportesNormales();
  }

  // ==========================
  //   OBTENER REPORTES
  // ==========================
  Future<List<Reporte>> fetchReportesNormales() async {
    final res = await http.get(Uri.parse(apiUrl));

    if (res.statusCode != 200) {
      throw Exception("Error cargando reportes");
    }

    final List data = json.decode(res.body);

    return data
        .map((json) => Reporte.fromJson(json))
        .where((r) => r.emergencia == false)
        .where((r) => r.estatus == "No revisado")
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Panel de administrador")),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Reportes No revisados",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),

          // ==========================
          //     LISTA DESDE BACKEND
          // ==========================
          Expanded(
            child: FutureBuilder<List<Reporte>>(
              future: futureReportes,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final reportes = snapshot.data!;

                if (reportes.isEmpty) {
                  return const Center(
                    child: Text("No hay reportes pendientes."),
                  );
                }

                return ListView.builder(
                  itemCount: reportes.length,
                  itemBuilder: (context, i) {
                    final r = reportes[i];

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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}