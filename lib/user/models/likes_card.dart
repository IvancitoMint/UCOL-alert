import 'package:flutter/material.dart';
import 'likes_model.dart';

class LikesModal extends StatelessWidget {
  final List<LikeUser> likes;

  const LikesModal({super.key, required this.likes});

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

          // ---------- LISTA DE LIKES ----------
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: likes.length,
              separatorBuilder: (_, __) => Divider(height: 1),
              itemBuilder: (_, i) {
                final u = likes[i];
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
