import 'package:coffeebook/utils/recipe_db.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _prepTimeController = TextEditingController();
  final List<String> _ingredients = [];
  final List<String> _products = [];
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _selectImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      final savedImage = await File(pickedFile.path).copy(imagePath);
      setState(() {
        _image = savedImage;
      });
    }
  }

  Future<void> _takePhoto() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final directory = await getApplicationDocumentsDirectory();
      final imagePath =
          '${directory.path}/${DateTime.now().millisecondsSinceEpoch}_${pickedFile.name}';
      final savedImage = await File(pickedFile.path).copy(imagePath);
      setState(() {
        _image = savedImage;
      });
    }
  }

  void _successMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Receta creada'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showAddIngredientDialog() {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir ingrediente'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: amountController,
                decoration: const InputDecoration(labelText: 'Cantidad'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _ingredients
                      .add("${nameController.text}, ${amountController.text}");
                });
                Navigator.of(context).pop();
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  void _showAddProductDialog() {
    final TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir producto'),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Nombre del producto'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _products.add(nameController.text);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }

  void _saveRecipeToDatabase() {
    if (_formKey.currentState!.validate()) {
      final newRecipe = Recipe(
        id: null,
        name: _nameController.text,
        instructions: _instructionsController.text,
        image: _image?.path ?? '',
        type: _typeController.text, // Get the type from the controller
        ingredients: _ingredients,
        products: _products,
        preparationTime:
            int.tryParse(_prepTimeController.text) ?? 0, // Parse the prep time
      );

      RecipeDbHelper.insertRecipe(newRecipe);
      _successMessage();
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear receta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nombre',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el nombre';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 18),
                const Text(
                  'Tipo de café',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tipo de café',
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Imagen de la receta: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    // Show the modal bottom sheet
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
                  },
                  child: _image != null
                      ? Image.file(
                          _image!,
                          width: 300,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 300,
                          height: 200,
                          color: Colors.grey[300],
                          child: const Icon(Icons.add_a_photo, size: 50),
                        ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Ingredientes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _ingredients.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _ingredients.length) {
                      return ListTile(
                        title: const Text("Añadir ingredientes"),
                        trailing: IconButton(
                            onPressed: () => _showAddIngredientDialog(),
                            icon: const Icon(Icons.add)),
                      );
                    } else {
                      return ListTile(
                        title: Text(_ingredients[index]),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Productos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: _products.length + 1,
                  itemBuilder: (context, index) {
                    if (index == _products.length) {
                      return ListTile(
                        title: const Text("Añadir productos"),
                        trailing: IconButton(
                            onPressed: () => _showAddProductDialog(),
                            icon: const Icon(Icons.add)),
                      );
                    } else {
                      return ListTile(
                        title: Text(_products[index]),
                      );
                    }
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Instrucciones',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _instructionsController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Instrucciones',
                    alignLabelWithHint: true,
                  ),
                  maxLines: 6,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese las instrucciones';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                const Text(
                  'Tiempo de preparación (minutos)',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _prepTimeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Tiempo de preparación',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el tiempo de preparación';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Ingrese un valor numérico';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveRecipeToDatabase,
                    child: const Text('Crear receta'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
