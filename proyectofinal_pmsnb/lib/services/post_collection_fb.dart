import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_model.dart';

class PostCollection {
  FirebaseFirestore? _firestore;
  CollectionReference? _postCollection;

  PostCollection() {
    _firestore = FirebaseFirestore.instance;
    _postCollection = _firestore!.collection('recetas');
  }

  Future<void> insert(PostModel postModel) async {
    return _postCollection!.doc().set(
      {
        'nombre': postModel.nombre,
        'caloria': postModel.caloria,
        'carbohidratos': postModel.carbohidratos,
        'descripcion': postModel.descripcion,
        'grasas': postModel.grasas,
        'imagen': postModel.imagen,
        'proteina': postModel.proteina,
        'usuario': postModel.usuario,
        'tiempo': postModel.tiempo
      },
    );
  }

  Stream<QuerySnapshot> getAllPost() {
    return _postCollection!.snapshots();
  }
}
