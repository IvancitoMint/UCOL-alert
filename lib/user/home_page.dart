import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../reportes_provider.dart';
import 'sidebar/sidebar_page.dart';
import 'utils/app_messages.dart';

import 'models/report_model.dart';
import 'models/report_card.dart';

import 'reports/report_modal.dart';
import 'reports/emergency_modal.dart';

import 'utils/session_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variables de sesión
  String? userId;
  String? userName;

  @override
  void initState() {
    super.initState();
    loadUserData();

    // Cargar reportes desde la API al iniciar
    Future.microtask(() {
      Provider.of<ReportesProvider>(context, listen: false).cargarReportes();
    });
  }

  void loadUserData() async {
    userId = await SessionManagerUser.getUserId();
    userName = await SessionManagerUser.getUserName();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final reportesProvider = Provider.of<ReportesProvider>(context);

    final reportes = reportesProvider.reportes
        .where((r) => r.estatus != "No revisado")
        .toList();

    return Scaffold(
      drawer: const SideBar(),
      backgroundColor: const Color(0xFFF4F4F4),

      // ---------- APP BAR ---------- //
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          "Bienvenido",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),

      // ---------- BODY ---------- //
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<ReportesProvider>(
            context,
            listen: false,
          ).cargarReportes();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Text(
                "Reportes Recientes",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),

              // ---------- LOADING ---------- //
              if (reportesProvider.cargando)
                const Center(child: CircularProgressIndicator(strokeWidth: 2)),

              // ---------- EMPTY ---------- //
              if (!reportesProvider.cargando && reportes.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      "No hay reportes todavía.",
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                  ),
                ),

              // ---------- REPORT LIST ---------- //
              ...reportes.map((r) {
                return ReportCard(
                  reportUi: ReportModel(
                    id: r.id,
                    usuario: r.autor,
                    avatarUrl:
                        "https://ui-avatars.com/api/?name=${r.autor}", // avatar temporal
                    tiempo: r.fecha.creacion,
                    ubicacion: r.ubicacion,
                    estado: r.estatus,
                    descripcion: r.descripcion,
                    categoria: r.categoria,
                    imagenUrl: (r.foto.isNotEmpty) ? r.foto.first : "",
                    likes: r.likes,
                    comments: r.comentarios.length,
                  ),
                  reportBackend: r,
                  currentUserId: userId ?? '',
                );
              }),

              const SizedBox(height: 120),
            ],
          ),
        ),
      ),

      // ---------- BOTTOM NAV BAR ---------- //
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              color: Colors.black12,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // ---------- HOME ---------- //
            GestureDetector(
              onTap: () {},
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.home, color: Colors.black87),
                  SizedBox(height: 4),
                  Text("Inicio", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),

            // ---------- REPORT BUTTON ---------- //
            GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const ReportModal(),
                );

                if (result != null && result["status"] == "success") {
                  AppMessages().showSuccess(context, result["mensaje"]);

                  // Recargar reportes después de crear uno
                  Provider.of<ReportesProvider>(
                    context,
                    listen: false,
                  ).cargarReportes();
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.add_circle_outline, color: Colors.blue),
                  SizedBox(height: 4),
                  Text("Reportar", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),

            // ---------- EMERGENCY BUTTON ---------- //
            GestureDetector(
              onTap: () async {
                final result = await showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const EmergencyModal(),
                );

                if (result != null && result["status"] == "success") {
                  AppMessages().showSuccess(context, result["mensaje"]);
                  Provider.of<ReportesProvider>(
                    context,
                    listen: false,
                  ).cargarReportes();
                }
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.emergency_outlined, color: Colors.red),
                  SizedBox(height: 4),
                  Text("Emergencia", style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
