import 'package:flutter/material.dart';
import '../models/report_model.dart';

import 'likes_model.dart';
import 'likes_card.dart';

import '../../reportes_provider.dart';
import 'package:provider/provider.dart';

class ReportCard extends StatelessWidget {
  final ReportModel report;

  const ReportCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- USER HEADER ---------- //
          Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(report.avatarUrl),
                radius: 22,
              ),
              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    report.usuario,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${report.tiempo.split("T")[0]} ${report.tiempo.split("T")[1].substring(0, 5)}",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.circle, size: 4),
                      const SizedBox(width: 6),
                      Text(
                        report.ubicacion,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3CD),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  report.estado,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF996F00),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Text(report.descripcion, style: const TextStyle(fontSize: 15)),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade50,
            ),
            child: Text(
              report.categoria,
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ),

          const SizedBox(height: 16),

          if (report.imagenUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  report.imagenUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Si la imagen falla, NO muestra nada (evita overflow)
                    return const SizedBox.shrink();
                  },
                ),
              ),
            )
          else
            const SizedBox.shrink(),

          const SizedBox(height: 12),

          GestureDetector(
            onLongPress: () async {
              final provider = Provider.of<ReportesProvider>(
                context,
                listen: false,
              );
              final usuarios = await provider.cargarUsuariosDeLikes(
                report.likes,
              );

              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => LikesModal(likes: usuarios),
              );
            },
            child: Row(
              children: [
                Icon(
                  Icons.thumb_up_alt_outlined,
                  size: 22,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text("${report.likes.length}"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
