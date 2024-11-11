import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:coffeebook/utils/recipe_db.dart';

class SampleRecipe {
  final String name;
  final String instructions;
  final String image;
  final double rating;
  final String type;
  final List<String> ingredients;
  final int preparationTime;

  SampleRecipe({
    required this.name,
    required this.instructions,
    required this.image,
    required this.rating,
    required this.type,
    required this.ingredients,
    required this.preparationTime,
  });

  factory SampleRecipe.fromMap(Map<String, dynamic> map) {
    return SampleRecipe(
      name: map['name'],
      instructions: map['instructions'],
      image: map['image'],
      rating: (map['rating'] as num).toDouble(),
      type: map['type'],
      ingredients: List<String>.from(map['ingredients']),
      preparationTime: map['preparationTime'],
    );
  }
}

class MyBaristaPage extends StatefulWidget {
  const MyBaristaPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Barista"),
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
            Text("Calificación: ${recipe.rating} / 5",
                style: const TextStyle(fontSize: 16)),
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
                // Add logic to save to database
              },
              child: const Text("Guardar en mis recetas"),
            ),
          ],
        ),
      ),
    );
  }
}
