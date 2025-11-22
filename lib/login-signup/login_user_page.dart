import 'package:flutter/material.dart';
import '../home_page.dart';

class LoginUserPage extends StatelessWidget {
  const LoginUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    final accountController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('Bienvenido usuario', textAlign: TextAlign.center,
                style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Inicia sesión para continuar',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade700)),
              const SizedBox(height: 40),

              TextField(
                controller: accountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Número de cuenta'),
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
                      borderRadius: BorderRadius.circular(16)),
                  ),
                  onPressed: () {
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                    //print('Cuenta: \${accountController.text}');
                  },
                  child: const Text('Iniciar sesión',
                    style: TextStyle(color: Colors.white, fontSize: 17)),
                ),
              ),
              const SizedBox(height: 25),

              GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/signup'),
                child: Text('¿No tienes cuenta? Crear nueva cuenta',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey.shade900,
                    decoration: TextDecoration.underline)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}