class Reporte {
  final String id;
  final String autor;
  final String estatus;
  final String descripcion;
  final String ubicacion;
  final String categoria;
  final List foto;
  final List likes;
  final List comentarios;
  final bool emergencia;
  final Fecha fecha;

  Reporte({
    required this.id,
    required this.autor,
    required this.estatus,
    required this.descripcion,
    required this.ubicacion,
    required this.categoria,
    required this.foto,
    required this.likes,
    required this.comentarios,
    required this.emergencia,
    required this.fecha,
  });

  factory Reporte.fromJson(Map<String, dynamic> json) {
    return Reporte(
      id: json['id'],
      autor: json['autor'],
      estatus: json['estatus'],
      descripcion: json['descripcion'],
      ubicacion: json['ubicacion'],
      categoria: json['categoria'],
      foto: json['foto'] ?? [],
      likes: json['likes'] ?? [],
      comentarios: json['comentarios'] ?? [],
      emergencia: json['emergencia'],
      fecha: Fecha.fromJson(json['fecha']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "autor": autor,
      "estatus": estatus,
      "descripcion": descripcion,
      "ubicacion": ubicacion,
      "categoria": categoria,
      "foto": foto,
      "likes": likes,
      "comentarios": comentarios,
      "emergencia": emergencia,
      "fecha": {
        "creacion": fecha.creacion.toString(),
        "actualizacion": fecha.actualizacion.toString(),
      },
    };
  }
}

class Fecha {
  final String creacion;
  final String actualizacion;

  Fecha({required this.creacion, required this.actualizacion});

  factory Fecha.fromJson(Map<String, dynamic> json) {
    return Fecha(
      creacion: json['creacion'].toString(),
      actualizacion: json['actualizacion'].toString(),
    );
  } 
}