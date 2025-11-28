import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../utils/ask_permissions.dart';
import '../utils/app_messages.dart';

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
    "Edificio A", "Edificio B", "Edificio C", "Edificio D", "Estacionamiento",
    ];
  final List<String> _categories = [
    "Mantenimiento",
    "Limpieza",
    "Seguridad",
    "Infraestructura",
    "Tecnología",
    "Otro"
  ];

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  // ---------- PICK IMAGE ---------- //
  Future<void> _pickImage() async {
    bool permisos = await askPermissions();
    if (!permisos) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Permisos requeridos",style: TextStyle(fontWeight: FontWeight.bold),),
          content: Text("Por favor otorga permisos para continuar."),
        ),
      );
      return;
    }

    if (_selectedImages.length >= 3) {
      showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          title: Text("Límite alcanzado",style: TextStyle(fontWeight: FontWeight.bold),),
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
                  final image =
                      await ImagePicker().pickImage(source: ImageSource.gallery);
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
                  final image =
                      await ImagePicker().pickImage(source: ImageSource.camera);
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
  void _submitReport() {
    if (_descriptionController.text.isEmpty ||
        _selectedLocation == null ||
        _selectedCategory == null ||
        _selectedImages.isEmpty) {
          AppMessages().showError(context, "Por favor completa todos los campos obligatorios.");
      return; 
    }
  /// ----------- PRINT USER DATA ---------- //
    final nuevoReporte = {
      "descripcion": _descriptionController.text,
      "ubicacion": _selectedLocation,
      "categoria": _selectedCategory,
      "imagenes": _selectedImages,
    };

    print("Datos del reporte: $nuevoReporte");

    Navigator.pop(context, "success");

  // ---------- AQUÍ IRÍA LA LÓGICA DE ENVÍO DEL REPORTE ---------- //
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
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 14),
            Text(
              "Completa el formulario para reportar un problema",
              style: TextStyle(color: Colors.grey.shade600),
            ),

            const SizedBox(height: 20),

            // ---------- DESCRIPCIÓN ---------- //
            const Text("Descripción *", style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black),
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

            // ---------- LOCATION & CATEGORY ---------- //
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Ubicación *",
                          style: TextStyle(fontWeight: FontWeight.w600)),
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
                      const Text("Categoría *",
                          style: TextStyle(fontWeight: FontWeight.w600)),
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

            // ---------- IMÁGENES ---------- //
            const Text("Fotos de evidencia (máx. 3) *",
                style: TextStyle(fontWeight: FontWeight.w600)),
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
                          Icon(Icons.upload, size: 32, color: Colors.grey.shade500),
                          const SizedBox(height: 5),
                          Text("Haz clic para cargar una foto",
                              style: TextStyle(color: Colors.grey.shade600)),
                        ],
                      )
                    : SizedBox(
                        height: 120,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _selectedImages.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
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
                                      setState(() => _selectedImages.removeAt(i));
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(Icons.close,
                                          color: Colors.white, size: 18),
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
                    onPressed: _submitReport,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text("Publicar Reporte",
                        style: TextStyle(color: Colors.white)),
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
                    child:
                        const Text("Cancelar", style: TextStyle(color: Colors.black)),
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
