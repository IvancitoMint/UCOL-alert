import 'package:flutter/material.dart';

import 'profile_page.dart';
import 'my_reports_page.dart';
import 'settings_page.dart';
//import 'sidebar/help_page.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});
  
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

            // ----------PROFILE PHOTO---------- //
            ListTile(
              leading: const CircleAvatar(
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
              title: const Text("María González"),
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
                  context, MaterialPageRoute(builder: (_) => ProfilePage()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: const Text("Administrar mis reportes"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) => MyReportsPage()));
              },
            ),

            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Configuración"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SettingsPage()));
              },
            ),

            const Spacer(),

            // ---------- FOOTER ---------- //
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text("© 2025 Campus Report",
                  style: TextStyle(color: Colors.black45)),
            ),
          ],
        ),
      ),
    );
  }
}