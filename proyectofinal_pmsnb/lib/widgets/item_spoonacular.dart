import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/models/recipe_model.dart';

class ItemSpoonacular extends StatelessWidget {
  const ItemSpoonacular({super.key, required this.recipeModel});

  final RecipeModel recipeModel;

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
      fit: BoxFit.cover,
      placeholder: const AssetImage('assets/progress.gif'),
      image: NetworkImage(
        recipeModel.image.toString()
      ),
    );
  }
}