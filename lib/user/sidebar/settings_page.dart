import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notifications = true;
  bool showName = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Configuración"),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Notificaciones",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                CheckboxListTile(
                  title: const Text("Recibir notificaciones de nuevos reportes"),
                  value: notifications,
                  onChanged: (v) => setState(() => notifications = v!),
                ),
                const Divider(),
                
                const Text("Idioma",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField(
                  initialValue: "Español",
                  items: const [
                    DropdownMenuItem(value: "Español", child: Text("Español")),
                    DropdownMenuItem(value: "Inglés", child: Text("Inglés")),
                  ],
                  onChanged: (v) {},
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: child,
    );
  }
}