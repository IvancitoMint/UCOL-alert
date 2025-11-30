import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../utils/ask_permissions.dart';
import '../utils/app_messages.dart';
import '../../../api_service.dart'; // ★ IMPORTANTE: tu servicio de API

// ---------- FUNCIÓN PRIVADA DE SUBIDA A CLOUDINARY ----------
Future<String> uploadImageToCloudinary(File image) async {
  final uri = Uri.parse('https://api.cloudinary.com/v1_1/dilwitdws/image/upload');
  final request = http.MultipartRequest('POST', uri);

  request.fields['upload_preset'] = 'flutter_unsigned';
  request.files.add(await http.MultipartFile.fromPath('file', image.path));

  final response = await request.send();
  final resBody = await response.stream.bytesToString();
  final data = jsonDecode(resBody);

  return data['secure_url'];
} // URL de la imagen subida

class ReportModal extends StatefulWidget {
  const ReportModal({super.key});

  @override
  State<ReportModal> createState() => _ReportModalState();
}

class _ReportModalState extends State<ReportModal> {
  // ---------- VARIABLES ---------- //
  final List<File> _selectedImages = [];
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedLocation;
  String? _selectedCategory;

  final List<String> _locations = [
    "Direccion",
    "Auditorio",
    "Cubiculos PTC",
    "Edificio A",
    "Edificio B",
    "Edificio C",
    "Edificio D",
    "Edificio de Postgrado",
    "Laboratorio de Electromagnetismo",
    "Taller de Maquinas-Herramientas",
    "Laboratorio de Electroinica",
    "Laboratorio de Telefonia",
    "Laboratorio de Inteligencia Artificial",
    "Laboratorio de Mecanica",
    "P.B. Centro de Cómputo",
    "P.B. Cubiculos PTC",
    "Laboratorio de Microelectronica",
    "Laboratorio de Matematicas",
    "Centro de Cómputo",
    "Laboratorio de Ciencia de datos",
    "Laboratorio de Mecatronica",
    "Estacionamiento",
  ];

  final List<String> _categories = [
    "Mantenimiento",
    "Limpieza",
    "Seguridad",
    "Infraestructura",
    "Tecnología",
    "Otro",
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // ---------- PICK IMAGE ---------- //
  Future<void> _pickImage() async {
    // Aquí llamas tu función de permisos
    bool permisos = await askPermissions();
    if (!permisos) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Permisos requeridos"),
          content: Text("Por favor otorga permisos para continuar."),
        ),
      );
      return;
    }

    if (_selectedImages.length >= 3) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Límite alcanzado"),
          content: Text("Solo puedes subir hasta 3 imágenes."),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Elegir de galería"),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                  );
                  if (image != null) {
                    setState(() => _selectedImages.add(File(image.path)));
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Tomar foto"),
                onTap: () async {
                  Navigator.pop(context);
                  final image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                  );
                  if (image != null) {
                    setState(() => _selectedImages.add(File(image.path)));
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------- VALIDAR Y ENVIAR ---------- //
  Future<void> _submitReport() async {
    if (_descriptionController.text.isEmpty ||
        _selectedLocation == null ||
        _selectedCategory == null ||
        _selectedImages.isEmpty) {
      AppMessages().showError(
        context,
        "Por favor completa todos los campos obligatorios.",
      );
      return;
    }

    // ★ Autor simulado
    final String autorSimulado = "usuario_demo_123";

    // ★ Subimos todas las imágenes a Cloudinary y obtenemos sus URLs
    List<String> uploadedImageUrls = [];
    try {
      for (var imageFile in _selectedImages) {
        final url = await uploadImageToCloudinary(imageFile);
        uploadedImageUrls.add(url);
      }
    } catch (e) {
      AppMessages().showError(context, "Error subiendo imágenes: $e");
      return;
    }

    // ★ Armamos el objeto según tu backend
    final Map<String, dynamic> data = {
      "autor": autorSimulado,
      "estatus": "No revisado",
      "descripcion": _descriptionController.text,
      "ubicacion": _selectedLocation,
      "categoria": _selectedCategory,
      "foto": uploadedImageUrls,
      "likes": [],
      "comentarios": [],
      "emergencia": false,
      "fecha": {
        "creacion": DateTime.now().toIso8601String(),
        "actualizacion": DateTime.now().toIso8601String(),
      },
    };

    try {
      final response = await ApiService.post("/reportes", data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ★ IMPORTANTE: NO mostrar aquí AppMessages()
        Navigator.pop(context, {
          "status": "success",
          "mensaje": "Reporte creado correctamente",
        });
      } else {
        AppMessages().showError(context, "Error al crear el reporte");
      }
    } catch (e) {
      AppMessages().showError(context, "Error: $e");
    }
  }

  // ---------- UI ---------- //
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
                  "Crear Reporte",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context, "success"), // Close modal
                ),
              ],
            ),

            const SizedBox(height: 14),
            Text(
              "Completa el formulario para reportar un problema",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 20),

            // DESCRIPCIÓN
            const Text(
              "Descripción *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Describe el problema...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // LOCACIÓN + CATEGORÍA
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Ubicación *",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      _dropdown(
                        value: _selectedLocation,
                        items: _locations,
                        onChange: (v) => setState(() => _selectedLocation = v),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Categoría *",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      _dropdown(
                        value: _selectedCategory,
                        items: _categories,
                        onChange: (v) => setState(() => _selectedCategory = v),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // FOTOS
            const Text(
              "Fotos de evidencia (máx. 3) *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                padding: const EdgeInsets.all(12),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black),
                ),
                child: _selectedImages.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload,
                            size: 32,
                            color: Colors.grey.shade500,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            "Haz clic para cargar una foto",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      )
                    : SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(width: 10),
                          itemBuilder: (_, i) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _selectedImages[i],
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(
                                        () => _selectedImages.removeAt(i),
                                      );
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // BUTTONS
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitReport, // ★ ENVÍA REPORTE
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      "Publicar Reporte",
                      style: TextStyle(color: Colors.white),
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
                        borderRadius: BorderRadius.circular(10),
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

  // ---------- DROPDOWN REUSABLE ---------- //
  Widget _dropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChange,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: const Text("Seleccionar"),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChange,
        ),
      ),
    );
  }
}