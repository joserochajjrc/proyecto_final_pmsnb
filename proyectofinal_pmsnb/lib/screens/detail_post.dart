import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../models/post_model.dart';

class DetailPost extends StatefulWidget {
  const DetailPost({Key? key, required this.postModel}) : super(key: key);

  final PostModel postModel;

  @override
  State<DetailPost> createState() => _DetailPost();
}

class _DetailPost extends State<DetailPost> {
  @override
  Widget build(BuildContext context) {
    final calorias = int.parse(widget.postModel.caloria!);
    final carbohidratos = int.parse(widget.postModel.carbohidratos!);
    final grasas = int.parse(widget.postModel.grasas!);
    final proteinas = int.parse(widget.postModel.proteina!);
    final total = calorias + carbohidratos + grasas + proteinas + 0.01;

    final pCalorias = calorias / total;
    final pCarbohidratos = carbohidratos / total;
    final pGrasas = grasas / total;
    final pProteinas = proteinas / total;

    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text(widget.postModel.nombre.toString()),
                  expandedHeight: 320,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                widget.postModel.imagen.toString()))),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  pinned: true,
                )
              ];
            },
            body: Container(
                color: Colors.orange.withOpacity(0.3),
                child: ListView(
                  padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.postModel.nombre.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.postModel.categoria.toString(),
                        ),
                      ],
                    ),
                    Text(widget.postModel.tiempo.toString()),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(widget.postModel.descripcion.toString()),
                    const SizedBox(
                      height: 30,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Calorias'),
                            LinearPercentIndicator(
                              width: 250,
                              lineHeight: 8,
                              percent: pCalorias,
                              progressColor: Colors.blue,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Carbohidratos'),
                            LinearPercentIndicator(
                              width: 250,
                              lineHeight: 8,
                              percent: pCarbohidratos,
                              progressColor: Colors.green,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Grasas'),
                            LinearPercentIndicator(
                              width: 250,
                              lineHeight: 8,
                              percent: pGrasas,
                              progressColor: Colors.orange,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Proteina'),
                            LinearPercentIndicator(
                              width: 250,
                              lineHeight: 8,
                              percent: pProteinas,
                              progressColor: Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                )),
          )),
    );
  }
}
