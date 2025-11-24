import 'package:flutter/material.dart';

import 'reports/report_modal.dart';
import 'reports/emergency_modal.dart';

import 'sidebar/sidebar_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const SideBar(),
      backgroundColor: const Color(0xFFF4F4F4),
      // ---------- TOP APP BAR  ---------- //
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: false,
        title: const Text(
          "Campus Report",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 10),
            const Text(
              "Reportes Recientes",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            // ---------- REPORT CARD ---------- //
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  // ---------- USER HEADER ---------- //
                  Row(
                    children: [
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                          "https://randomuser.me/api/portraits/men/32.jpg",
                        ),
                        radius: 22,
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Carlos Ramírez",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              Text("hace 7 días",
                                  style: TextStyle(
                                      color: Colors.grey.shade600)),
                              const SizedBox(width: 6),
                              const Icon(Icons.circle, size: 4),
                              const SizedBox(width: 6),
                              Text("Edificio A",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 13)),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF3CD),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          "Pendiente",
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF996F00),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  const Text(
                    "Baño descompuesto en el segundo piso del edificio A. "
                    "Está inundado y necesita reparación urgente.",
                    style: TextStyle(fontSize: 15),
                  ),

                  const SizedBox(height: 10),

                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.blue.shade50,
                    ),
                    child: Text(
                      "Mantenimiento",
                      style: TextStyle(
                        color: Colors.blue.shade700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      "https://images.unsplash.com/photo-1600585154340-be6161a56a0c",
                      height: 200,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ---------- INTERACTIONS ---------- //
                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined,
                          size: 22, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      const Text("12"),
                      const SizedBox(width: 20),
                      Icon(Icons.comment_outlined,
                          size: 22, color: Colors.grey.shade600),
                      const SizedBox(width: 4),
                      const Text("3"),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 120),
          ],
        ),
      ),

      // ---------- BOTTOM NAVIGATION ---------- //
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
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const HomePage(),
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.home, color: Colors.black87),
                SizedBox(height: 4),
                Text("Inicio", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const ReportModal(),
                );
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
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => const EmergencyModal(),
                );
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.emergency_outlined, color: Colors.red),
                  SizedBox(height: 4),
                  Text("Emergencia", style: TextStyle(fontSize: 12)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}