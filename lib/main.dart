import 'package:flutter/material.dart';
import 'login_main_page.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// Variable global para la IP
final String ip = "http://192.168.100.25:8000/";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Login App',
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.grey),
      ),

      // ---------- LOGIN PAGE AS HOME SCREEN ---------- //
      home: const LoginMainPage(),
      routes: {'/login': (context) => const LoginMainPage()},
    );
  }
}
