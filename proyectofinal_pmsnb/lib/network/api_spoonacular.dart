import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyectofinal_pmsnb/models/ingredients_model.dart';
import 'package:proyectofinal_pmsnb/models/recipe_model.dart';

class ApiSpoonacular {

  final URL = "https://api.spoonacular.com/recipes/complexSearch?apiKey=d47776a698df48a39433875326a61e92&addRecipeInformation=true&number=100";

  Future<List<RecipeModel>?> getAllRecipes() async{
    final response = await http.get(Uri.parse(URL));
    if(response.statusCode == 200){
      var recipe = jsonDecode(response.body)['results'] as List;
      var listRecipe = recipe.map((recipes) => RecipeModel.fromMap(recipes)).toList();
      return listRecipe;
    }
    return null;
  }

  Future<List<ingredientsModel>> getIngredients(String id) async {
    final URL =
        'https://api.spoonacular.com/recipes/${id}/ingredientWidget.json?apiKey=d47776a698df48a39433875326a61e92';
    final response = await http.get(Uri.parse(URL));
    if (response.statusCode == 200) {
      var recipe = jsonDecode(response.body)['ingredients'] as List;
      var listRecipe = recipe.map((ingredients) => ingredientsModel.fromJson(ingredients)).toList();
      return listRecipe;
    } else {
      throw Exception('Hubo un error :()');
    }
  }
}