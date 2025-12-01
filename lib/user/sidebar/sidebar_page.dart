import 'package:flutter/material.dart';

import 'profile_page.dart';
import 'my_reports_page.dart';
import 'settings_page.dart';

import '../utils/session_manager.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  String? userName;
  String? userFoto;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final name = await SessionManagerUser.getUserName();
    final foto = await SessionManagerUser.getUserFoto();

    setState(() {
      userName = name;
      userFoto = foto;
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),

            // ---------- X CLOSE BUTTON ---------- //
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),

            // ---------- HEADER ---------- //
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text("Campus Report",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue)),
                  SizedBox(height: 4),
                  Text("Sistema de Reportes",
                      style: TextStyle(color: Colors.black54)),
                ],
              ),
            ),

            const SizedBox(height: 20),
            const Divider(),

            // ---------- PROFILE PHOTO + NAME ---------- //
            ListTile(
              leading: CircleAvatar(
                radius: 26,
                backgroundColor: Colors.grey.shade300,
                backgroundImage: (userFoto != null && userFoto!.isNotEmpty)
                  ? NetworkImage(userFoto!)
                  : const AssetImage("assets/profile.jpg") as ImageProvider,
              ),
              title: Text(
                userName ?? "Cargando...",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: const Text("En línea"),
            ),

            const Divider(),

            // ---------- OPTIONS ---------- //
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text("Perfil"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProfilePage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text("Administrar mis reportes"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MyReportsPage()),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Configuración"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => SettingsPage()),
                );
              },
            ),

            const Spacer(),

            // ---------- FOOTER ---------- //
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "© 2025 Campus Report",
                style: TextStyle(color: Colors.black45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}