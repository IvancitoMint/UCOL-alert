import 'package:flutter/material.dart';

import 'signup_user_page.dart';
import '../home_page.dart';
import '../utils/app_messages.dart';

class LoginUserPage extends StatefulWidget {
  const LoginUserPage({super.key});

  @override
  State<LoginUserPage> createState() => _LoginUserPageState();
}

class _LoginUserPageState extends State<LoginUserPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void _login() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      AppMessages().showError(context, "Por favor completa todos los campos para iniciar sesión.");
      return;
    }else{
      /// ----------- PRINT USER DATA ---------- //
      final nuevosInicioDeSesion = {
        "email": emailController.text,
        "password": passwordController.text,
      };
      print("Inicio de sesion: $nuevosInicioDeSesion");
      
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    }
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
              const Text('Bienvenido usuario',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),

              Text('Inicia sesión para continuar',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade700)),
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
                  child: const Text('Iniciar sesión',
                      style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              ),

              const SizedBox(height: 25),

              GestureDetector(
                onTap: () async {
                  final result = await showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (_) => const SignUpUserPage(),
                  );

                  if (result == "success") {
                    AppMessages().showSuccess(context, "Cuenta creada correctamente.");
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    '¿No tienes cuenta? Crear nueva cuenta',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade900,
                      decoration: TextDecoration.underline,
                    ),
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
