import 'dart:io';
import 'package:flutter/material.dart';

import '../utils/ask_permissions.dart';
import '../utils/image_picker_helper.dart';
import '../utils/app_messages.dart';

class SignUpUserPage extends StatefulWidget {
  const SignUpUserPage({super.key});

  @override
  State<SignUpUserPage> createState() => _SignUpUserPageState();
}

class _SignUpUserPageState extends State<SignUpUserPage> {
  // ---------- CONTROLLERS AND VARIABLES ---------- //
  File? selectedImage;
  final TextEditingController nombresController = TextEditingController();
  final TextEditingController apellidosController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? _selectedCampus;
  final List<String> _campuses = [
    "Colima Norte",
    "Colima Central",
    "Villa de Álvarez",
    "Coquimatlán",
    "Tecomán",
    "Manzanillo",
    "Armería"
  ];

  // ---------- SUBMIT FUNCTION ---------- //
  void _submitSignUp() {
    if (selectedImage == null ||
        nombresController.text.isEmpty ||
        apellidosController.text.isEmpty ||
        correoController.text.isEmpty ||
        passwordController.text.isEmpty ||
        _selectedCampus == null) {
      AppMessages().showError(context, "Por favor completa todos los campos requeridos.");
      return;
    }

    // ----------- USER DATA READY ----------- //
    final Map<String, dynamic> userData = {
      "foto": selectedImage,
      "nombres": nombresController.text.trim(),
      "apellidos": apellidosController.text.trim(),
      "correo": correoController.text.trim(),
      "password": passwordController.text.trim(),
      "campus": _selectedCampus,
    };

    print("Datos del usuario listos para enviar: $userData");

    Navigator.pop(context, "success");

    // Aquí luego podrás hacer tu POST al backend

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------- HEADER ---------- //
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Crear cuenta",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 6),

            // ---------- PROFILE PHOTO ---------- //
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    backgroundImage:
                        selectedImage != null ? FileImage(selectedImage!) : null,
                    child: selectedImage == null
                        ? const Icon(Icons.person, size: 50, color: Colors.white)
                        : null,
                  ),
                  const SizedBox(height: 6),
                  ElevatedButton(
                    onPressed: () async {
                      bool permisosConcedidos = await askPermissions();

                      if (!permisosConcedidos) {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Permisos requeridos"),
                            content: const Text("Por favor otorga permisos para continuar."),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("OK"),
                              ),
                            ],
                          ),
                        );
                        return;
                      }

                      ImagePickerHelper.showImageOptions(
                        context: context,
                        onImageSelected: (image) {
                          setState(() {
                            selectedImage = image;
                          });
                        },
                      );
                    },
                    child: const Text("Subir foto"),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------- FIRST NAMES ---------- //
            const Text(
              "Nombres *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _inputBox(
              child: TextField(
                controller: nombresController,
                decoration: const InputDecoration(
                  hintText: "Escribe tus nombres",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- LAST NAMES ---------- //
            const Text(
              "Apellidos *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _inputBox(
              child: TextField(
                controller: apellidosController,
                decoration: const InputDecoration(
                  hintText: "Escribe tus apellidos",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- LOCATION ---------- //
            const Text(
              "Campus de residencia *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedCampus,
                  isExpanded: true,
                  hint: const Text("Selecciona tu campus"),
                  items: _campuses
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCampus = value;
                    });
                  },
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- EMAIL ---------- //
            const Text(
              "Correo electrónico universitario *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _inputBox(
              child: TextField(
                controller: correoController,
                decoration: const InputDecoration(
                  hintText: "ejemplo@ucol.mx",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- PASSWORD ---------- //
            const Text(
              "Contraseña *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _inputBox(
              child: TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: "Escribe tu contraseña",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 22),

            // ---------- BUTTONS ---------- //
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitSignUp,   // <<--- SE USA LA FUNCIÓN
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Crear cuenta",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Cancelar",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------- INPUT BOX REUSABLE ----------
  Widget _inputBox({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: child,
    );
  }
}
