import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../reportes_provider.dart';
import 'package:provider/provider.dart';
import '../../models.dart';

import '../utils/ask_permissions.dart';
import '../utils/app_messages.dart';
import '../../../api_service.dart';

class EmergencyModal extends StatefulWidget {
  const EmergencyModal({super.key});

  @override
  State<EmergencyModal> createState() => _EmergencyModalState();
}

class _EmergencyModalState extends State<EmergencyModal> {
  // ---------- VARIABLES ---------- //
  final List<File> _selectedImages = [];
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedLocation;
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

  // ---------- SUBMIT REPORT ---------- //
  Future<void> _submitEmergencyReport() async {
    if (_descriptionController.text.isEmpty ||
        _selectedLocation == null ||
        _selectedImages.isEmpty) {
      AppMessages().showError(
        context,
        "Por favor completa todos los campos obligatorios.",
      );
      return;
    }

    final String autorSimulado = "usuario_demo_123";

    // ---------- SUBIR IMÁGENES ---------- //
    List<String> uploadedImageUrls = [];
    try {
      for (var imageFile in _selectedImages) {
        final url = await _uploadImageToCloudinary(imageFile);
        uploadedImageUrls.add(url);
      }
    } catch (e) {
      AppMessages().showError(context, "Error subiendo imágenes: $e");
      return;
    }

    // ---------- CREAR JSON PARA API ---------- //
    final Map<String, dynamic> data = {
      "autor": autorSimulado,
      "estatus": "No revisado",
      "descripcion": _descriptionController.text,
      "ubicacion": _selectedLocation,
      "categoria": "emergencia", // <-- en minúsculas si así es tu backend
      "foto": uploadedImageUrls,
      "likes": [],
      "comentarios": [],
      "emergencia": true,
      "fecha": {
        "creacion": DateTime.now().toIso8601String(),
        "actualizacion": DateTime.now().toIso8601String(),
      },
    };

    try {
      // 1. Enviar a la API
      final response = await ApiService.post("/reportes", data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // 2. Convertir respuesta a modelo
        final nuevoReporte = Reporte.fromJson(jsonDecode(response.body));

        // 3. Agregar al Provider para actualización en tiempo real
        Provider.of<ReportesProvider>(
          context,
          listen: false,
        ).agregarReporte(nuevoReporte);

        // 4. Salir del modal
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

  // ---------- FUNCIÓN PRIVADA DE SUBIDA A CLOUDINARY ----------
  Future<String> _uploadImageToCloudinary(File image) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/dilwitdws/image/upload',
    );
    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] = 'flutter_unsigned';
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();
    final resBody = await response.stream.bytesToString();
    final data = jsonDecode(resBody);

    return data['secure_url'];
  } // URL de la imagen subida

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
                  "Reporte de Emergencia",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () =>
                      Navigator.pop(context, "success"), // Close modal
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ---------- WARNING BOX ---------- //
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: const Text(
                "Importante: Usa este formulario solo para emergencias reales que "
                "requieran atención inmediata, como fugas, accidentes o riesgos de seguridad.",
                style: TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ---------- DESCRIPTION ---------- //
            const Text(
              "¿Qué está sucediendo? *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
              child: TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Describe la emergencia...",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ---------- LOCATION ---------- //
            const Text(
              "Ubicación *",
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
                  value: _selectedLocation,
                  isExpanded: true,
                  hint: const Text("Seleccionar"),
                  items: _locations
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => setState(() => _selectedLocation = val),
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ---------- EVIDENCE PHOTO ---------- //
            const Text(
              "Foto de evidencia (mín. 1, máx. 3)",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),

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
                        children: [
                          Icon(
                            Icons.upload,
                            size: 32,
                            color: Colors.grey.shade600,
                          ),
                          const SizedBox(height: 6),
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
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _selectedImages[index],
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
                                        () => _selectedImages.removeAt(index),
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

            // ---------- BUTTONS ---------- //
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: _submitEmergencyReport,
                    child: const Text(
                      "Reportar Emergencia",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
}
