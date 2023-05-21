import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectofinal_pmsnb/models/recipe.dart';

class RecipeApi{

  static Future<List<Recipe>> getRecipe() async{
     var uri = Uri.https('yummly2.p.rapidapi.com', '/feeds/list',
        {"limit": "24", "start": "0"});

    final response = await http.get(uri, headers: {
      'X-RapidAPI-Key': '38081c71a7msh0843bcc40e1529dp107041jsnb47b99ef0bc0',
      'X-RapidAPI-Host': 'yummly2.p.rapidapi.com'
    });

    Map data = jsonDecode(response.body);
    List _temp = [];

    for (var i in data['feed']) {
      _temp.add(i['content']['details']);
    }

    return Recipe.recipesFromSnapshot(_temp);
  }
}