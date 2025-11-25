class Reporte {
  final String id;
  final String categoria;
  final String descripcion;
  final String usuario;
  final String fecha;
  final String tipo; // "normal" o "urgente"
  final String detalles;

  Reporte({
    required this.id,
    required this.categoria,
    required this.descripcion,
    required this.usuario,
    required this.fecha,
    required this.tipo,
    required this.detalles,
  });
}

List<Reporte> reportesDemo = [
  Reporte(
    id: "1",
    categoria: "Basura",
    descripcion: "Acumulación de basura en la calle",
    usuario: "Juan Pérez",
    fecha: "2025-11-20",
    tipo: "normal",
    detalles: "Hay bolsas acumuladas desde hace 3 días en la esquina.",
  ),

  Reporte(
    id: "2",
    categoria: "Fuga de agua",
    descripcion: "Fuga fuerte en tubería",
    usuario: "Ana López",
    fecha: "2025-11-20",
    tipo: "urgente",
    detalles: "La fuga está esparciendo agua hacia toda la calle.",
  ),

  Reporte(
    id: "3",
    categoria: "El felpudo",
    descripcion: "Me quiero detonar al fercho",
    usuario: "Kitian",
    fecha: "2025-11-20",
    tipo: "urgente",
    detalles: "Tiene un culito bien paradito",
  ),
];