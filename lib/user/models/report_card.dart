import 'package:flutter/material.dart';
import '../models/report_model.dart';

import 'likes_card.dart';

import '../../reportes_provider.dart';
import 'package:provider/provider.dart';
import '../../models.dart';

import '../utils/session_manager.dart';

class ReportCard extends StatefulWidget {
  final ReportModel reportUi;
  final Report reportBackend;
  final String currentUserId;

  const ReportCard({
    super.key,
    required this.reportUi,
    required this.reportBackend,
    required this.currentUserId,
  });

  @override
  State<ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<ReportCard> {
  String? userName;
  String? userFoto;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final name = await SessionManagerUser.getUserName();
    final foto = await SessionManagerUser.getUserFoto();

    setState(() {
      userName = name;
      userFoto = foto;
      
    });
  }
  
  void _toggleLike(BuildContext context) async {
    final provider = Provider.of<ReportesProvider>(context, listen: false);

    final String usuarioId = widget.currentUserId; // Obtén el id real

    List<String> nuevosLikes = List.from(widget.reportBackend.likes);

    if (nuevosLikes.contains(usuarioId)) {
      nuevosLikes.remove(usuarioId);
    } else {
      nuevosLikes.add(usuarioId);
    }

    // Llamar al provider con el reporte del backend
    await provider.updateLikes(widget.reportBackend, nuevosLikes);
  }

  @override
  Widget build(BuildContext context) {
    final report = widget.reportBackend; // más corto para usar abajo

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
                backgroundImage: NetworkImage(widget.reportUi.avatarUrl),
                radius: 22,
              ),
              const SizedBox(width: 12),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.reportUi.usuario,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        "${widget.reportUi.tiempo.split("T")[0]} ${widget.reportUi.tiempo.split("T")[1].substring(0, 5)}",
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.circle, size: 4),
                      const SizedBox(width: 6),
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
                          widget.reportUi.estado,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF996F00),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              Text(
                report.ubicacion,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          Text(widget.reportUi.descripcion, style: const TextStyle(fontSize: 15)),

          const SizedBox(height: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.blue.shade50,
            ),
            child: Text(
              widget.reportUi.categoria,
              style: TextStyle(color: Colors.blue.shade700),
            ),
          ),

          const SizedBox(height: 16),

          if (widget.reportUi.imagenUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                height: 200,
                width: double.infinity,
                child: Image.network(
                  widget.reportUi.imagenUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
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
                widget.reportUi.likes,
              );

              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                builder: (_) => LikesModal(likes: usuarios),
              );
            },
            child: GestureDetector(
              onTap: () => _toggleLike(context),
              child: Row(
                children: [
                  Icon(
                    widget.reportUi.likes.contains("ID_DEL_USUARIO_LOGEADO")
                        ? Icons.thumb_up
                        : Icons.thumb_up_alt_outlined,
                    size: 22,
                    color: Colors.blue,
                  ),
                  const SizedBox(width: 4),
                  Text("${widget.reportUi.likes.length}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}