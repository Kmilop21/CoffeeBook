import 'dart:io';
import 'package:flutter/material.dart';
import 'package:coffeebook/models/recipe_db.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';

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
  bool _isEditing = false; // New variable for edit mode
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _recipe = widget.recipe;
    RecipeDbHelper.addRecentRecipe(_recipe.id!);
  }

  void _toggleEditMode() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _updateRecipeField(String field, dynamic value) async {
    setState(() {
      switch (field) {
        case 'name':
          _recipe = _recipe.copyWith(name: value);
          break;
        case 'type':
          _recipe = _recipe.copyWith(type: value);
          break;
        case 'image':
          _recipe = _recipe.copyWith(image: value);
          break;
        case 'preparationTime':
          _recipe = _recipe.copyWith(preparationTime: int.parse(value));
          break;
        case 'ingredients':
          _recipe = _recipe.copyWith(ingredients: value);
          break;
        case 'instructions':
          _recipe = _recipe.copyWith(instructions: value);
          break;
        case 'products':
          _recipe = _recipe.copyWith(products: value);
          break;
      }
    });
    await RecipeDbHelper.updateRecipe(_recipe);
  }

  Future<void> _editField(
      String title, String field, String initialValue) async {
    if (!_isEditing) return;

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
              hintText: 'Ingresar $title',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _updateRecipeField(field, controller.text);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectImage() async {
    if (!_isEditing) return;

    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      await _updateRecipeField('image', pickedFile.path);
    }
  }

  Future<void> _takePhoto() async {
    if (!_isEditing) return;

    final pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      await _updateRecipeField('image', pickedFile.path);
    }
  }

  Future<void> _editIngredient(int index, String currentIngredient) async {
    if (!_isEditing) return;

    TextEditingController controller =
        TextEditingController(text: currentIngredient);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar ingrediente'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Ingresa ingrediente',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _recipe.ingredients[index] = controller.text;
                });
                Navigator.of(context).pop();
                _updateRecipeField('ingredients', _recipe.ingredients);
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _editProducts(int index, String currentProducts) async {
    if (!_isEditing) return;

    TextEditingController controller =
        TextEditingController(text: currentProducts);
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar productos'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Ingresa producto',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                setState(() {
                  _recipe.products[index] = controller.text;
                });
                Navigator.of(context).pop();
                _updateRecipeField('products', _recipe.products);
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
      backgroundColor: const Color.fromARGB(255, 241, 235, 216),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 146, 111, 102),
        title: const Text('Receta'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.remove_red_eye_outlined : Icons.edit),
            onPressed: _toggleEditMode,
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {
              // Generate the message text
              String message = '''
${widget.recipe.name}

Ingredientes:
${widget.recipe.ingredients.map((ingredient) => '- $ingredient').join('\n')}

Productos utilizados:
${widget.recipe.products.map((product) => '- $product').join('\n')}
''';

              // Share the message
              Share.share(message);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            GestureDetector(
              onTap: () => _editField('Nombre', 'name', _recipe.name),
              child: Text(
                _recipe.name,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  decoration: _isEditing ? TextDecoration.underline : null,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                if (_isEditing) {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.photo),
                            title: const Text('Seleccionar desde galería'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              await _selectImage();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.camera_alt),
                            title: const Text('Tomar foto'),
                            onTap: () async {
                              Navigator.of(context).pop();
                              await _takePhoto();
                            },
                          ),
                        ],
                      );
                    },
                  );
                }
              },
              child: _recipe.image.isNotEmpty
                  ? (_recipe.image.startsWith("assets/")
                      ? Image.asset(
                          _recipe.image,
                          height: 250,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(_recipe.image),
                          height: 250,
                          fit: BoxFit.cover,
                        ))
                  : const Icon(Icons.image, size: 100),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _editField('Veces preparadas', 'timesPrepared',
                  _recipe.timesMade.toString()),
              child: Row(
                children: [
                  const Text(
                    "Veces preparadas: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Bold for the label
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _recipe.timesMade.toString(),
                      style: TextStyle(
                        fontSize: 18,
                        decoration:
                            _isEditing ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () async {
                      setState(() {
                        RecipeDbHelper.incrementTimesMade(_recipe.id!);
                      });

                      // Reload the updated recipe data from the database to reflect the changes
                      _recipe = await RecipeDbHelper.getRecipeById(_recipe.id!);

                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _editField('Tipo', 'type', _recipe.type),
              child: Row(
                children: [
                  const Text(
                    "Tipo: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Bold for the label
                    ),
                  ),
                  Expanded(
                    child: Text(
                      _recipe.type,
                      style: TextStyle(
                        fontSize: 18,
                        decoration:
                            _isEditing ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                  if (_isEditing) const Icon(Icons.edit, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _editField('tiempo de preparación',
                  'preparationTime', _recipe.preparationTime.toString()),
              child: Row(
                children: [
                  const Text(
                    "Tiempo de preparación: ",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold, // Bold for the label
                    ),
                  ),
                  Expanded(
                    child: Text(
                      "${_recipe.preparationTime} minutos",
                      style: TextStyle(
                        fontSize: 18,
                        decoration:
                            _isEditing ? TextDecoration.underline : null,
                      ),
                    ),
                  ),
                  if (_isEditing) const Icon(Icons.edit, color: Colors.grey),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Ingredientes:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    if (_isEditing) const Icon(Icons.edit, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 8),
                ..._recipe.ingredients.asMap().entries.map((entry) {
                  int index = entry.key;
                  String ingredient = entry.value;
                  return GestureDetector(
                    onTap: () => _editIngredient(index, ingredient),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "• $ingredient",
                              style: TextStyle(
                                fontSize: 16,
                                decoration: _isEditing
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text("Productos utilizados:",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    if (_isEditing) const Icon(Icons.edit, color: Colors.grey),
                  ],
                ),
                const SizedBox(height: 8),
                ..._recipe.products.asMap().entries.map((entry) {
                  int index = entry.key;
                  String products = entry.value;
                  return GestureDetector(
                    onTap: () => _editProducts(index, products),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "• $products",
                              style: TextStyle(
                                fontSize: 16,
                                decoration: _isEditing
                                    ? TextDecoration.underline
                                    : null,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () => _editField(
                  'instrucciones', 'instructions', _recipe.instructions),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("Instrucciones:",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      if (_isEditing)
                        const Icon(Icons.edit, color: Colors.grey),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _recipe.instructions,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: _isEditing ? TextDecoration.underline : null,
                    ),
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
