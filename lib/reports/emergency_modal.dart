import 'package:flutter/material.dart';

class EmergencyModal extends StatelessWidget {
  const EmergencyModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                "Importante: Usa este formulario solo para emergencias reales y "
                "que requieran atención inmediata, como fugas, accidentes o riesgos de seguridad.",
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
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
              child: const TextField(
                maxLines: 4,
                decoration: InputDecoration(
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
                  isExpanded: true,
                  hint: const Text("Seleccionar"),
                  items: ["Edificio A", "Edificio B", "Norte"]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (value) {},
                ),
              ),
            ),

            const SizedBox(height: 14),

            // ---------- EVIDENCE PHOTO ---------- //
            const Text("Foto de evidencia (recomendado)"),
            const SizedBox(height: 8),
            Container(
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, style: BorderStyle.solid),

              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.upload, size: 32, color: const Color.fromARGB(255, 44, 44, 44)),
                    const SizedBox(height: 6),
                    Text(
                      "Haz clic para cargar una foto",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
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
                      backgroundColor: const Color.fromARGB(255, 220, 20, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {},
                    child: const Text(
                      "Reportar Emergencia",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: Colors.black),
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