import 'package:flutter/material.dart';
//import 'package:flutter_html/flutter_html.dart';
import 'package:proyectofinal_pmsnb/models/ingredients_model.dart';
import 'package:proyectofinal_pmsnb/models/recipe_model.dart';
import 'package:proyectofinal_pmsnb/network/api_spoonacular.dart';

class detailsRecipe extends StatefulWidget {
  const detailsRecipe({Key? key, required this.recipeModel}) : super(key: key);

  final RecipeModel recipeModel;

  @override
  State<detailsRecipe> createState() => _detailsRecipeState();
}

class _detailsRecipeState extends State<detailsRecipe> {
  final ApiSpoonacular apiSpoonacular = ApiSpoonacular();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  title: Text(widget.recipeModel.title.toString()),
                  expandedHeight: 320,
                  flexibleSpace: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                                widget.recipeModel.image.toString()))),
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                    ),
                  ),
                  pinned: true,
                  bottom: TabBar(
                      labelColor: Colors.white,
                      indicatorWeight: 4,
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            'Details',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Ingredients',
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      ]),
                )
              ];
            },
            body: TabBarView(
              children: <Widget>[
                Container(
                    color: Colors.orange.withOpacity(0.3),
                    child: ListView(
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      children: <Widget>[
                        Text(
                          widget.recipeModel.title.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: Text(widget.recipeModel.summary.toString()),
                          //child: Html(data: '<div>'+ widget.recipeModel.summary.toString()+'</div>', style: {'div':Style(fontSize: FontSize(16))},),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    )),
                Container(
                    color: Colors.orange.withOpacity(0.3),
                    child: ListView(
                        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                        children: <Widget>[
                          Text(
                            widget.recipeModel.title.toString(),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Column(
                            children: [
                              Container(
                                height: 15,
                                width: 15,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                              ),
                              FutureBuilder<List<ingredientsModel>>(
                                future: apiSpoonacular.getIngredients(
                                    widget.recipeModel.id.toString()),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<ingredientsModel>?>
                                        snapshot) {
                                  if (snapshot.hasData) {
                                    return SizedBox(
                                      height: 300,
                                      child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        itemCount: snapshot.data!.length,
                                        itemBuilder: (context, index) {
                                          return Text(snapshot.data![index].name
                                              .toString());
                                        },
                                      ),
                                    );
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                      child: Text('Algo salio mal :()'),
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ],
                          )
                        ]))
              ],
            ),
          )),
    );
  }
}
