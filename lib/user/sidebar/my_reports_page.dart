import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../main.dart';
import '../utils/app_messages.dart';
import '../utils/session_manager.dart';

class MyReportsPage extends StatefulWidget {
  const MyReportsPage({super.key});

  @override
  State<MyReportsPage> createState() => _MyReportsPageState();
}

class _MyReportsPageState extends State<MyReportsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis Reportes"),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 6),
            ],
          ),
          child: const Center(
            child: Text(
              "No hay reportes para mostrar",
              style: TextStyle(color: Colors.black54),
            ),
          ),
        ),
      ),
    );
  }
}
