class ReportModel {
  final String id;
  final String usuario;
  final String avatarUrl;
  final String tiempo;
  final String ubicacion;
  final String estado;
  final String descripcion;
  final String categoria;
  final String imagenUrl;
  List likes;
  final int comments;

  ReportModel({
    required this.id,
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

  ReportModel copyWith({List<String>? likes}) {
    return ReportModel(
      id: id,
      usuario: usuario,
      avatarUrl: avatarUrl,
      tiempo: tiempo,
      ubicacion: ubicacion,
      estado: estado,
      descripcion: descripcion,
      categoria: categoria,
      imagenUrl: imagenUrl,
      likes: likes ?? this.likes,
      comments: comments,
    );
  }
}
