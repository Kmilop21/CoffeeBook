import 'package:flutter/material.dart';
import 'package:coffeebook/utils/recipe_db.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;

  const RecipePage({
    super.key,
    required this.recipe,
  });

  @override
  RecipePageState createState() => RecipePageState();
}

class RecipePageState extends State<RecipePage> {
  @override
  void initState() {
    super.initState();
    RecipeDbHelper.addRecentRecipe(widget.recipe.id!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.recipe.name,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Image.asset(
              widget.recipe.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 8),
            Text(
              "Tipo: ${widget.recipe.type}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              "Calificación:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              "Tiempo de preparación: ${widget.recipe.preparationTime} minutos",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              "Ingredientes:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...widget.recipe.ingredients.map((ingredient) => Text(
                  "• $ingredient",
                  style: const TextStyle(fontSize: 16),
                )),
            const SizedBox(height: 16),
            const Text(
              "Instrucciones:",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.recipe.instructions,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
