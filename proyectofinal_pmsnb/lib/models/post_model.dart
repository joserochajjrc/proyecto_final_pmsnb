class PostModel {
  String? nombre;
  String? descripcion;
  String? caloria;
  String? carbohidratos;
  String? grasas;
  String? proteina;
  String? tiempo;
  String? imagen;
  String? usuario;

  PostModel(
      {this.nombre,
      this.descripcion,
      this.caloria,
      this.carbohidratos,
      this.grasas,
      this.proteina,
      this.tiempo,
      this.imagen,
      this.usuario});

  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      nombre: map['nombre'],
      descripcion: map['descripcion'],
      caloria: map['caloria'],
      carbohidratos: map['carbohidratos'],
      grasas: map['grasas'],
      proteina: map['proteina'],
      tiempo: map['tiempo'],
      imagen: map['imagen'],
      usuario: map['usuario'],
    );
  }
}
