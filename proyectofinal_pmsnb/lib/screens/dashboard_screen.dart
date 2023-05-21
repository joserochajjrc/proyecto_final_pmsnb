import 'package:flutter/material.dart';
import 'package:proyectofinal_pmsnb/models/recipe.api.dart';
import 'package:proyectofinal_pmsnb/models/recipe.dart';
import 'package:proyectofinal_pmsnb/widgets/recipe_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  late List<Recipe> _recipes;
  bool _isLoading = true;

  @override
  void initState(){
    super.initState();
    getRecipes();
  }

  Future<void> getRecipes() async{
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.restaurant_menu),
        SizedBox(width: 10,),
        Text('Bienvenido ')])
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage('https://raw.githubusercontent.com/obliviate-dan/Login-Form/master/img/avatar.png'),
              ),
              accountName: Text('José Juan Rocha Cisneros'), 
              accountEmail: Text('19031005@itcelaya.edu.mx')
            ),
          ],
        ),
      ),
      body: _isLoading ? Center(child: CircularProgressIndicator())
                       : ListView.builder(
                          itemCount: _recipes.length,
                          itemBuilder: (context, index) {
                            return RecipeCard(
                              title: _recipes[index].name, 
                              cookTime: _recipes[index].totalTime, 
                              rating: _recipes[index].rating.toString(), 
                              thumbnailUrl: _recipes[index].images
                            );
                          },
                       )
    );
  }
}