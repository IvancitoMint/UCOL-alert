import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        elevation: 0,
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircleAvatar(
                radius: 45,
                backgroundImage: AssetImage("assets/profile.jpg"),
              ),
              SizedBox(height: 10),
              Text("María González",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Estudiante"),
              Divider(height: 30),
              Text("0  Reportes   |   0  Resueltos   |   0  Me gusta"),
            ],
          ),
        ),
      ),
    );
  }
}
