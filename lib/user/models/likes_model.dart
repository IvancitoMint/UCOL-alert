class LikeUser {
  final String name;
  final String photoUrl;

  LikeUser({required this.name, required this.photoUrl});

  factory LikeUser.fromJson(Map<String, dynamic> json) {
    return LikeUser(name: json["nombre"], photoUrl: json["foto_perfil"]);
  }
}
