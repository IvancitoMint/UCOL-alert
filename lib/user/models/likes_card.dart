import 'package:flutter/material.dart';
import 'likes_model.dart';

class LikesModal extends StatefulWidget {
  final List<LikeUser> likes;

  const LikesModal({super.key, required this.likes});

  @override
  State<LikesModal> createState() => _LikesModalState();
}

class _LikesModalState extends State<LikesModal> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ----- Handle bar -----
          Container(
            width: 50,
            height: 5,
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Text(
              "Personas a las que les gustó",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),

          // ----- LISTA DE USUARIOS -----
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.likes.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (_, i) {
                final u = widget.likes[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(u.photoUrl),
                  ),
                  title: Text(u.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}