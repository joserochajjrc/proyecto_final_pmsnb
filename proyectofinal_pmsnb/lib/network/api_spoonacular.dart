import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:proyectofinal_pmsnb/models/ingredients_model.dart';
import 'package:proyectofinal_pmsnb/models/recipe_model.dart';

class ApiSpoonacular {

  final URL = "https://api.spoonacular.com/recipes/complexSearch?apiKey=9140c37d8fe94e0bbbee048a1f79a803&addRecipeInformation=true";

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
        'https://api.spoonacular.com/recipes/${id}/ingredientWidget.json?apiKey=9140c37d8fe94e0bbbee048a1f79a803';
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