import 'package:flutter/material.dart';
import 'login_user_page.dart';

class SignUpUserPage extends StatelessWidget {
  const SignUpUserPage({super.key});

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

            const SizedBox(height: 12),

            // ---------- PROFILE PHOTO ---------- //
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Sube una foto de perfil",
                    style: TextStyle(color: Colors.grey.shade600),
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
              child: const TextField(
                decoration: InputDecoration(
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
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Escribe tus apellidos",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------- LOCATION ---------- //
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true, // <--- IMPORTANTE
                            hint: const Text("Selecciona tu campus"),
                            items: ["Colima Norte", "Colima Central", "Villa de Álvarez", "Coquimatlán", "Tecomán", "Manzanillo", "Armería"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (value) {},
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // ---------- EMAIL ---------- //
            const Text(
              "Correo electrónico universitario *",
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),
            _inputBox(
              child: const TextField(
                decoration: InputDecoration(
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
              child: const TextField(
                obscureText: true,
                decoration: InputDecoration(
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginUserPage(),
                        ),
                      );
                    },
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

  // ---------- WIDGET REUSABLE PARA INPUTS ---------- //
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