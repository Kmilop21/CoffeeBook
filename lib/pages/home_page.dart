import 'dart:io';

import 'package:coffeebook/utils/recipe_db.dart';
import 'package:coffeebook/pages/recipe_page.dart';
import 'package:coffeebook/pages/my_barista.dart';
import 'package:coffeebook/pages/my_recipes.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<Recipe> recentRecipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    recentRecipes = await RecipeDbHelper.getRecentRecipes();
    setState(() {}); // Update the UI with the latest data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CoffeeBook'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.brown,
              ),
              child: Text(
                'Menú',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 48,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.coffee),
              title: const Text('Mis recetas'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyRecipesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.coffee),
              title: const Text('Mi Barista'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const MyBaristaPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 32),
            const Text(
              'Recetas recientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if (recentRecipes.isNotEmpty)
              ...recentRecipes.map((recipe) => GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipePage(
                            recipe: recipe,
                          ),
                        ),
                      ).then((_) {
                        fetchRecipes();
                      });
                    },
                    child: RecipeCard(recipe: recipe),
                  )),
            if (recentRecipes.isEmpty)
              const Center(child: Text('No hay recetas recientes')),
          ],
        ),
      ),
    );
  }
}

// Custom widget to display a recipe card
class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 100,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              recipe.image.isNotEmpty
                  ? (recipe.image.startsWith("assets/")
                      ? SizedBox(
                          width: 75,
                          height: 75,
                          child: Image.asset(
                            recipe.image,
                            fit: BoxFit.cover,
                          ),
                        )
                      : SizedBox(
                          width: 75,
                          height: 75,
                          child: File(recipe.image).existsSync()
                              ? Image.file(
                                  File(recipe.image),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/images/placeholder.png',
                                  fit: BoxFit.cover,
                                ),
                        ))
                  : const Icon(Icons.image,
                      size: 100), // Fallback icon if no image
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
