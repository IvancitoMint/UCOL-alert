import 'package:flutter/material.dart';

import 'sidebar/sidebar_page.dart';
import 'utils/app_messages.dart';

import 'models/report_model.dart';
import 'models/report_card.dart';

import 'reports/report_modal.dart';
import 'reports/emergency_modal.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // ---------- REPORTS LIST ---------- //
  List<ReportModel> getReports() {
    return [
      ReportModel(
        usuario: "Carlos Ramírez",
        avatarUrl: "https://randomuser.me/api/portraits/men/32.jpg",
        tiempo: "hace 7 días",
        ubicacion: "Edificio A",
        estado: "Pendiente",
        descripcion:
            "Baño descompuesto en el segundo piso del edificio A. Está inundado y necesita reparación urgente.",
        categoria: "Mantenimiento",
        imagenUrl:
            "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
        likes: 12,
        comments: 3,
      ),

      ReportModel(
        usuario: "Lucía Hernández",
        avatarUrl: "https://randomuser.me/api/portraits/women/22.jpg",
        tiempo: "hace 2 días",
        ubicacion: "Biblioteca",
        estado: "En proceso",
        descripcion:
            "El aire acondicionado está fallando y emite ruido fuerte.",
        categoria: "Servicios",
        imagenUrl:
            "https://images.unsplash.com/photo-1507668077129-56e328d7a34b",
        likes: 8,
        comments: 1,
      ),

      ReportModel(
        usuario: "Miguel Torres",
        avatarUrl: "https://randomuser.me/api/portraits/men/45.jpg",
        tiempo: "hace 1 día",
        ubicacion: "Cafetería",
        estado: "Resuelto",
        descripcion:
            "La máquina de café no funciona correctamente y necesita mantenimiento.",
        categoria: "Servicios",
        imagenUrl:
            "https://images.unsplash.com/photo-1517248135467-4c7edcad34c4",
        likes: 15,
        comments: 4,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final reports = getReports();

    return Scaffold(
      drawer: const SideBar(),
      backgroundColor: const Color(0xFFF4F4F4),

      // ---------- TOP APP BAR ---------- //
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text("Campus Report",
            style: TextStyle(
                color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: false,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),


      // ---------- CONTENT FOR REPORTS ---------- //
      body: SingleChildScrollView(
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

            ...reports.map((r) => ReportCard(report: r)).toList(),

            const SizedBox(height: 120),
          ],
        ),
      ),

      // ---------- BOTTOM BAR ---------- //
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

            // ---------- BUTTONS ---------- //
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
                  backgroundColor: Colors.transparent,
                  builder: (_) => const ReportModal(),
                );

                if (result == "success") {
                  AppMessages().showSuccess(context, "Reporte creado correctamente");
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
                  backgroundColor: Colors.transparent,
                  builder: (_) => const EmergencyModal(),
                );

                if (result == "success") {
                  AppMessages().showSuccess(
                      context, "Reporte de emergencia enviado");
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