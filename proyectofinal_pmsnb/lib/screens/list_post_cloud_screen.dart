import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/models/post_model.dart';
import 'package:proyectofinal_pmsnb/screens/detail_post.dart';

import '../services/post_collection_fb.dart';
import '../widgets/item_post.dart';

class ListPostCloudScreen extends StatefulWidget {
  const ListPostCloudScreen({super.key});

  @override
  State<ListPostCloudScreen> createState() => _ListPostCloudScreenState();
}

class _ListPostCloudScreenState extends State<ListPostCloudScreen> {
  PostCollection? postCollection;

  @override
  void initState() {
    postCollection = PostCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: postCollection!.getAllPost(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final nombre = snapshot.data!.docs[index].get('nombre');
                final tiempo = snapshot.data!.docs[index].get('tiempo');
                final imagen = snapshot.data!.docs[index].get('imagen');
                final caloria = snapshot.data!.docs[index].get('caloria');
                final carbohidratos =
                    snapshot.data!.docs[index].get('carbohidratos');
                final descripcion =
                    snapshot.data!.docs[index].get('descripcion');
                final grasas = snapshot.data!.docs[index].get('grasas');
                final proteina = snapshot.data!.docs[index].get('proteina');
                final usuario = snapshot.data!.docs[index].get('usuario');
                final categoria = snapshot.data!.docs[index].get('categoria');

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => DetailPost(
                          postModel: PostModel(
                            nombre: nombre,
                            tiempo: tiempo,
                            imagen: imagen,
                            caloria: caloria,
                            carbohidratos: carbohidratos,
                            descripcion: descripcion,
                            grasas: grasas,
                            proteina: proteina,
                            usuario: usuario,
                            categoria: categoria,
                          ),
                        ),
                      ),
                    );
                  },
                  child: ItemPostWidget(
                    postModel: PostModel(
                      nombre: nombre,
                      tiempo: tiempo,
                      imagen: imagen,
                      caloria: caloria.toString(),
                      carbohidratos: carbohidratos.toString(),
                      descripcion: descripcion,
                      grasas: grasas.toString(),
                      proteina: proteina.toString(),
                      usuario: usuario,
                    ),
                  ),
                );
              });
        } else if (snapshot.hasError) {
          return Center(
            child: Text('Algo salio mal'),
          );
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
