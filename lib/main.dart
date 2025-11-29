import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'login_main_page.dart';
import 'reportes_provider.dart';

// ----- GLOBALS -----
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final String ip = "http://192.168.1.82:8000/";

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ReportesProvider())],
      child: const MyApp(),
    ),
  );
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

      // Página inicial
      home: const LoginMainPage(),

      routes: {'/login': (context) => const LoginMainPage()},
    );
  }
}
