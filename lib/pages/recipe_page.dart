import 'dart:io';
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
  late Recipe _recipe;

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    RecipeDbHelper.addRecentRecipe(_recipe.id!);
  }

  Future<void> _updateRecipeField(String field, String value) async {
    // Update the recipe field
    setState(() {
      switch (field) {
        case 'preparationTime':
          _recipe = _recipe.copyWith(preparationTime: int.parse(value));
          break;
        case 'ingredients':
          _recipe = _recipe.copyWith(ingredients: value.split(', '));
          break;
        case 'instructions':
          _recipe = _recipe.copyWith(instructions: value);
          break;
      }
    });
    // Update the database
    await RecipeDbHelper.updateRecipe(_recipe);
  }

  Future<void> _editField(
      String title, String field, String initialValue) async {
    TextEditingController controller =
        TextEditingController(text: initialValue);

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar $title'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Ingresa $title',
            ),
            keyboardType: field == 'Tiempo de preparación'
                ? TextInputType.number
                : TextInputType.multiline,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                await _updateRecipeField(field, controller.text);
                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _recipe.name,
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
            _recipe.image.isNotEmpty
                ? (_recipe.image.startsWith("assets/")
                    ? Image.asset(
                        _recipe.image,
                        width: 50,
                        height: 450,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(_recipe.image),
                        width: 50,
                        height: 450,
                        fit: BoxFit.cover,
                      ))
                : const Icon(Icons.image), // Fallback in case of no image
            const SizedBox(height: 8),
            Text(
              "Tipo: ${_recipe.type}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _editField('tiempo de preparación',
                  'preparationTime', _recipe.preparationTime.toString()),
              child: Text(
                "Tiempo de preparación: ${_recipe.preparationTime} minutos",
                style: const TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _editField('ingredientes', 'ingredients',
                  _recipe.ingredients.join(', ')),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Ingredientes:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._recipe.ingredients.map((ingredient) => Text(
                        "• $ingredient",
                        style: const TextStyle(fontSize: 16),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _editField(
                  'instrucciones', 'instructions', _recipe.instructions),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Instrucciones:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _recipe.instructions,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
