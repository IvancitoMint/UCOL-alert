class ReportModel {
  final String usuario;
  final String avatarUrl;
  final String tiempo;
  final String ubicacion;
  final String estado;
  final String descripcion;
  final String categoria;
  final String imagenUrl;
  final int likes;
  final int comments;

  ReportModel({
    required this.usuario,
    required this.avatarUrl,
    required this.tiempo,
    required this.ubicacion,
    required this.estado,
    required this.descripcion,
    required this.categoria,
    required this.imagenUrl,
    required this.likes,
    required this.comments,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      usuario: json["usuario"],
      avatarUrl: json["avatarUrl"],
      tiempo: json["tiempo"],
      ubicacion: json["ubicacion"],
      estado: json["estado"],
      descripcion: json["descripcion"],
      categoria: json["categoria"],
      imagenUrl: json["imagenUrl"],
      likes: json["likes"],
      comments: json["comments"],
    );
  }
}