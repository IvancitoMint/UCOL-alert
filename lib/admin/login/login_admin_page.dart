import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../home_page.dart';
import '../../user/utils/app_messages.dart';
import '../../main.dart';
import '../../audio_management.dart';

class LoginAdminPage extends StatefulWidget {
  const LoginAdminPage({super.key});

  @override
  State<LoginAdminPage> createState() => _LoginAdminPageState();
}

class _LoginAdminPageState extends State<LoginAdminPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() async {
    final account = emailController.text.trim();
    final password = passwordController.text.trim();

    if (account.isEmpty || password.isEmpty) {
      AppMessages().showError(context, "Por favor completa todos los campos para iniciar sesión.");
      return;
    }else{
      /// ----------- PRINT USER DATA ---------- //
      final userData = {
        "email": emailController.text,
        "password": passwordController.text,
      };
      
      final url = Uri.parse("${ip}users/admin");
      final res = await http.post(url, headers: {"Content-Type": "application/x-www-form-urlencoded"}, body: userData);

      if (res.statusCode == 401) {
        AppMessages().showError(context, "Error en las credenciales.");
        playError();
        return;
      }
      
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminMain()),
      );

      playSuccess();
      AppMessages().showSuccess(context, "Bienvenido, administrador.");
    }

    // Aquí iría lógica real de autenticación del administrador

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Bienvenido administrador',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              Text(
                'Inicia sesión para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 40),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
              ),
              const SizedBox(height: 20),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Contraseña'),
              ),
              const SizedBox(height: 30),

              SizedBox(
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: _login,
                  child: const Text(
                    'Iniciar sesión',
                    style: TextStyle(color: Colors.white, fontSize: 17),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}