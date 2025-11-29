import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../utils/ask_permissions.dart';
import '../utils/app_messages.dart';
import '../../admin/api_service.dart';

class EmergencyModal extends StatefulWidget {
  const EmergencyModal({super.key});

  @override
  State<EmergencyModal> createState() => _EmergencyModalState();
}

class _EmergencyModalState extends State<EmergencyModal> {
  final List<File> _photos = [];

  // ---------- VARIABLES ---------- //
  final TextEditingController _descController = TextEditingController();
  String? _selectedEmergencyLocation;
  final List<String> _emLocations = ["Edificio A", "Edificio B", "Norte"];

  // ---------- PICK IMAGE ---------- //
  Future<void> _pickImage() async {
    bool permisos = await askPermissions();

    if (!permisos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Por favor otorga permisos para continuar"),
        ),
      );
      return;
    }

    if (_photos.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Máximo 3 fotos permitidas")),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text("Elegir de galería"),
              onTap: () async {
                Navigator.pop(context);
                final img = await ImagePicker().pickImage(
                  source: ImageSource.gallery,
                );
                if (img != null) {
                  setState(() => _photos.add(File(img.path)));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Tomar foto"),
              onTap: () async {
                Navigator.pop(context);
                final img = await ImagePicker().pickImage(
                  source: ImageSource.camera,
                );
                if (img != null) {
                  setState(() => _photos.add(File(img.path)));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------- SUBMIT REPORT ---------- //
  Future<void> _submitEmergencyReport() async {
    if (_descController.text.isEmpty ||
        _selectedEmergencyLocation == null ||
        _photos.isEmpty) {
      AppMessages().showError(
        context,
        "Por favor completa todos los campos obligatorios.",
      );
      return;
    }

    // ★ IMPORTANTE: Autor simulado (reemplazar luego con SharedPreferences)
    final String autorSimulado = "usuario_demo_123";

    // ★ Convertir fotos reales a URLs simuladas
    final List<String> fotosSimuladas = _photos
        .map((file) => "https://miapi.com/uploads/${file.path.split('/').last}")
        .toList();

    // ★ OBJETO DEL REPORTE ESPECIAL DE EMERGENCIA
    final Map<String, dynamic> data = {
      "autor": autorSimulado,
      "estatus": "Pendiente",
      "descripcion": _descController.text,
      "ubicacion": _selectedEmergencyLocation,
      "categoria": "emergencia", // ★ CAMBIO IMPORTANTE
      "foto": fotosSimuladas,
      "likes": [],
      "comentarios": [],
      "emergencia": true, // ★ CAMBIO IMPORTANTE
      "fecha": {
        "creacion": DateTime.now().toIso8601String(),
        "actualizacion": DateTime.now().toIso8601String(),
      },
    };

    try {
      final response = await ApiService.post("/reportes", data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // ★ NO mostramos el mensaje aquí
        Navigator.pop(context, {
          "status": "success",
          "mensaje": "Emergencia reportada correctamente",
        });
      } else {
        AppMessages().showError(context, "Error al enviar emergencia");
      }
    } catch (e) {
      AppMessages().showError(context, "Error: $e");
    }
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
            // ---------- TOP APP BAR ---------- //
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
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // ---------- IMPORTANT WARNING BOX ---------- //
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
                border: Border.all(color: Colors.black),
              ),
              child: TextField(
                controller: _descController,
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
                  value: _selectedEmergencyLocation,
                  isExpanded: true,
                  hint: const Text("Seleccionar"),
                  items: _emLocations
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedEmergencyLocation = val),
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
                child: _photos.isEmpty
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
                          itemCount: _photos.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (_, index) {
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.file(
                                    _photos[index],
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
                                      setState(() => _photos.removeAt(index));
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
