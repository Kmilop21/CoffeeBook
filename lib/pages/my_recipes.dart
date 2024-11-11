import 'dart:io';

import 'package:coffeebook/pages/create_recipe_page.dart';
import 'package:coffeebook/pages/home_page.dart';
import 'package:coffeebook/pages/my_barista.dart';
import 'package:coffeebook/pages/recipe_page.dart';
import 'package:flutter/material.dart';
import 'package:coffeebook/utils/recipe_db.dart';

class MyRecipesPage extends StatefulWidget {
  final String username;

  const MyRecipesPage({
    super.key,
    required this.username,
  });

  @override
  MyRecipesPageState createState() => MyRecipesPageState();
}

class MyRecipesPageState extends State<MyRecipesPage> {
  late Future<List<Recipe>> _recipes;

  @override
  void initState() {
    super.initState();
    fetchRecipes(); // Fetch the recipes from the database
  }

  Future<void> fetchRecipes() async {
    _recipes = RecipeDbHelper.getRecipes();
    setState(() {}); // Trigger UI update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mis recetas"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.brown,
              ),
              child: Text(
                'Bienvenido, ${widget.username}',
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomePage(username: widget.username),
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
                    builder: (context) =>
                        MyRecipesPage(username: widget.username),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.coffee),
              title: const Text('Crear receta'),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CreateRecipePage(username: widget.username),
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
                    builder: (context) =>
                        MyBaristaPage(username: widget.username),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Recipe>>(
        future: _recipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recetas disponibles.'));
          }

          List<Recipe> recipes = snapshot.data!;

          return ListView.builder(
            itemCount: recipes.length,
            itemBuilder: (context, index) {
              Recipe recipe = recipes[index];
              return Card(
                child: ListTile(
                  leading: recipe.image.isNotEmpty
                      ? (recipe.image.startsWith("assets/")
                          ? Image.asset(
                              recipe.image,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : Image.file(
                              File(recipe.image),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ))
                      : const Icon(Icons.image), // Fallback in case of no image
                  title: Text(recipe.name),
                  subtitle: Text(recipe.type),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RecipePage(recipe: recipe),
                      ),
                    ).then((_) {
                      fetchRecipes(); // Refresh recipes after returning
                    });
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
