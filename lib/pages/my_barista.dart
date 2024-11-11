import 'dart:convert';
import 'package:coffeebook/pages/create_recipe_page.dart';
import 'package:coffeebook/pages/home_page.dart';
import 'package:coffeebook/pages/my_recipes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:coffeebook/utils/recipe_db.dart';

class SampleRecipe {
  final String name;
  final String instructions;
  final String image;
  final String type;
  final List<String> ingredients;
  final int preparationTime;

  SampleRecipe({
    required this.name,
    required this.instructions,
    required this.image,
    required this.type,
    required this.ingredients,
    required this.preparationTime,
  });

  factory SampleRecipe.fromMap(Map<String, dynamic> map) {
    return SampleRecipe(
      name: map['name'],
      instructions: map['instructions'],
      image: map['image'],
      type: map['type'],
      ingredients: List<String>.from(map['ingredients']),
      preparationTime: map['preparationTime'],
    );
  }
}

class MyBaristaPage extends StatefulWidget {
  final String username;

  const MyBaristaPage({
    super.key,
    required this.username,
  });

  @override
  MyBaristaPageState createState() => MyBaristaPageState();
}

class MyBaristaPageState extends State<MyBaristaPage> {
  List<SampleRecipe> sampleRecipes = [];

  @override
  void initState() {
    super.initState();
    loadSampleRecipes();
  }

  Future<void> loadSampleRecipes() async {
    final String jsonString =
        await rootBundle.loadString('assets/samples.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    setState(() {
      sampleRecipes = (jsonData['recipes'] as List)
          .map((data) => SampleRecipe.fromMap(data))
          .toList();
    });
  }

  Future<void> saveSampleRecipe(SampleRecipe sampleRecipe) async {
    // Create a new Recipe instance without specifying the ID, as it’s auto-incremented in the database
    final newRecipe = Recipe(
      id: null, // This will be auto-generated by the database
      name: sampleRecipe.name,
      instructions: sampleRecipe.instructions,
      image: sampleRecipe.image,
      type: sampleRecipe.type,
      ingredients: sampleRecipe.ingredients,
      preparationTime: sampleRecipe.preparationTime,
    );

    // Insert the new Recipe into the database
    await RecipeDbHelper.insertRecipe(newRecipe);

    // Optionally, display a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${sampleRecipe.name} added to your recipes!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Barista"),
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
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(username: 'Camilo'),
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
                    builder: (context) => MyBaristaPage(
                      username: widget.username,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: sampleRecipes.length,
          itemBuilder: (context, index) {
            final recipe = sampleRecipes[index];
            return _buildRecipeCard(recipe);
          },
        ),
      ),
    );
  }

  Widget _buildRecipeCard(SampleRecipe recipe) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              recipe.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              recipe.name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text("Tipo: ${recipe.type}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            Text("Tiempo de preparación: ${recipe.preparationTime} minutos",
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            const Text(
              "Ingredientes:",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ...recipe.ingredients.map((ingredient) => Text("• $ingredient")),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                saveSampleRecipe(recipe);
              },
              child: const Text("Guardar en mis recetas"),
            ),
          ],
        ),
      ),
    );
  }
}
