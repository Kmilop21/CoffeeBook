import 'package:coffeebook/models/ingredient.dart';
import 'package:coffeebook/models/recipe.dart';
import 'package:coffeebook/models/user.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class CreateRecipePage extends StatefulWidget {
  const CreateRecipePage({super.key});

  @override
  State<StatefulWidget> createState() => _CreateRecipePageState();
}

class _CreateRecipePageState extends State<CreateRecipePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();

  List<Ingredient> _ingredients = [];

  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear receta'),
        automaticallyImplyLeading: false,
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
                const SizedBox(height: 18),
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
                  'Imagen de la receta: ',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _pickImage,
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
                        title: Text(_ingredients[index].name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Cantidad: ${_ingredients[index].amount}'),
                            Text('Tipo: ${_ingredients[index].type}'),
                            Text(
                                'Precio: \$${_ingredients[index].price?.toStringAsFixed(2)}'),
                            Text(
                                'Vendedor: ${_ingredients[index].seller?.username ?? "No encontrado"}')
                          ],
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _successMessage();
                      }
                    },
                    child: const Text('Crear receta'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showAddIngredientDialog() {
    final TextEditingController _ingredientNameController =
        TextEditingController();
    final TextEditingController _ingredientAmountController =
        TextEditingController();
    final TextEditingController _ingredientTypeController =
        TextEditingController();
    final TextEditingController _ingredientPriceController =
        TextEditingController();
    final TextEditingController _ingredientSellerController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadir ingredientes'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _ingredientNameController,
                  decoration: const InputDecoration(
                      labelText: 'Nombre del ingrediente'),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _ingredientAmountController,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                ),
                TextField(
                  controller: _ingredientNameController,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                ),
                TextField(
                  controller: _ingredientNameController,
                  decoration: const InputDecoration(labelText: 'Precio'),
                ),
                TextField(
                  controller: _ingredientNameController,
                  decoration: const InputDecoration(labelText: 'Vendedor'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Cancel button
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Add the new ingredient to the list
                setState(
                  () {
                    _ingredients.add(Ingredient(
                        name: _ingredientNameController.text,
                        amount: _ingredientAmountController.text,
                        type: _ingredientTypeController.text,
                        price:
                            double.tryParse(_ingredientPriceController.text) ??
                                0.0,
                        seller: User(
                            username: _ingredientSellerController.text,
                            id: 0,
                            email: "",
                            password: "",
                            profilePic: "",
                            recipeLists: [])));
                  },
                );
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Añadir'),
            ),
          ],
        );
      },
    );
  }
}
