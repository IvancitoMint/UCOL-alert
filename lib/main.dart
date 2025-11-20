import 'package:flutter/material.dart';
import 'login_page.dart';
import 'signup_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),
      home: const LoginPage(), // Pantalla de login
      routes: {
        '/signup': (context) => const SignUpPage(),
      },
    );
  }
}