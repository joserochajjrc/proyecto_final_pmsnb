import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyectofinal_pmsnb/models/recipe_model.dart';

class ApiSpoonacular {

  final URL = "https://api.spoonacular.com/recipes/complexSearch?apiKey=d47776a698df48a39433875326a61e92&addRecipeInformation=true";

  Future<List<RecipeModel>?> getAllRecipes() async{
    final response = await http.get(Uri.parse(URL));
    if(response.statusCode == 200){
      var recipe = jsonDecode(response.body)['results'] as List;
      var listRecipe = recipe.map((recipes) => RecipeModel.fromMap(recipes)).toList();
      print('hi');
      return listRecipe;
    }
    print('hi');
    return null;
  }
}