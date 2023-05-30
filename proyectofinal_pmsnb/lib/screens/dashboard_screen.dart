import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:proyectofinal_pmsnb/models/recipe_model.dart';
import 'package:proyectofinal_pmsnb/models/user_model.dart';
import 'package:proyectofinal_pmsnb/network/api_spoonacular.dart';
import 'package:proyectofinal_pmsnb/screens/details_recipe.dart';
import 'package:proyectofinal_pmsnb/screens/post_screen.dart';
import 'package:proyectofinal_pmsnb/services/email_authentication.dart';
import 'package:proyectofinal_pmsnb/screens/list_post_cloud_screen.dart';
import 'package:proyectofinal_pmsnb/widgets/item_spoonacular.dart';

import '../provider/theme_provider.dart';
import '../services/push_notification_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  void _toggleTheme(theme) {
    final settings = Provider.of<ThemeProvider>(context, listen: false);
    settings.toggleTheme(theme);
  }

  //late List<Recipe> _recipes;
  //bool _isLoading = true;

  ApiSpoonacular? apiSpoonacular;

  EmailAuth emailAuth = EmailAuth();

  File? _image;

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this._image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print('Failed to pick image: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    //getRecipes();
    apiSpoonacular = ApiSpoonacular();
  }

  /*Future<void> getRecipes() async{
    _recipes = await RecipeApi.getRecipe();
    setState(() {
      _isLoading = false;
    });
  }*/

  @override
  Widget build(BuildContext context) {
    ThemeProvider theme = Provider.of<ThemeProvider>(context);
    final user = FirebaseAuth.instance.currentUser!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            children: [
              Icon(Icons.restaurant_menu),
              SizedBox(
                width: 10,
              ),
              Text('Bienvenido '),
            ],
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                    Text(
                      ' Inicio',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.group,
                      color: Colors.white,
                    ),
                    Text(
                      ' Social',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        /*body: _isLoading ? Center(child: CircularProgressIndicator())
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
                       )*/
        body: TabBarView(
          children: [
            FutureBuilder(
              future: apiSpoonacular!.getAllRecipes(),
              builder: (context, AsyncSnapshot<List<RecipeModel>?> snapshot) {
                if (snapshot.data != null) {
                  return InkWell(
                    onTap: () {},
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      padding: const EdgeInsets.all(10),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        mainAxisSpacing: 10,
                        childAspectRatio: 2,
                        crossAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        if (snapshot.hasData) {
                          RecipeModel model = snapshot.data![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          detailsRecipe(
                                            recipeModel: model,
                                          )));
                            },
                            child: ItemSpoonacular(
                                recipeModel: snapshot.data![index]),
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
                  );
                } else {
                  return Container();
                }
              },
            ),

            //ListPostCloudScreen(),
            ListPostCloudScreen(),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              GestureDetector(
                onTap: () {
                  getImage(ImageSource.gallery);
                },
              ),
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: user.photoURL != null
                      ? NetworkImage(user.photoURL!)
                      : const NetworkImage(
                          'https://raw.githubusercontent.com/obliviate-dan/Login-Form/master/img/avatar.png'),
                ),
                accountName: user.displayName != null
                    ? Text(user.displayName!)
                    : Container(),
                accountEmail:
                    user.email != null ? Text(user.email!) : Container(),
              ),
              ListTile(
                onTap: () {
                  emailAuth.signOut();
                  Navigator.pushNamed(context, '/login');
                },
                horizontalTitleGap: 0.0,
                leading: const Icon(Icons.add_to_home_screen),
                title: const Text(
                  'Cerrar Sesión',
                  style: TextStyle(fontSize: 16),
                ),
                trailing: const Icon(Icons.chevron_right),
              ),
              DropdownButtonFormField<String>(
                  isExpanded: true,
                  value: theme.getTheme(),
                  decoration: const InputDecoration(
                    labelText: 'Tema',
                    prefixIcon: Icon(Icons.color_lens),
                  ),
                  items: <String>['light', 'eco'].map((i) {
                    return DropdownMenuItem(
                        value: i,
                        child: Text(
                          i,
                        ));
                  }).toList(),
                  hint: const Text('Tema'),
                  //padding: const EdgeInsets.symmetric(horizontal: 10),
                  onChanged: (value) {
                    if (value == 'light') {
                      _toggleTheme('light');
                    }
                    if (value == 'eco') {
                      _toggleTheme('eco');
                    }
                  }),
            ],
          ),
        ),
        /*body: _isLoading ? Center(child: CircularProgressIndicator())
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
                         )*/
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: ((context) => PostScreen(
                      token: '',
                    )),
              ),
            );
          },
          label: const Text('Publicar'),
          icon: const Icon(Icons.food_bank),
        ),
      ),
    );
  }
}
