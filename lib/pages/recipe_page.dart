import 'package:coffeebook/models/comment.dart';
import 'package:coffeebook/models/ingredient.dart';
import 'package:coffeebook/models/product.dart';
import 'package:coffeebook/models/user.dart';
import 'package:coffeebook/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:coffeebook/models/recipe.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;
  final User user;

  const RecipePage({super.key, required this.recipe, required this.user});

  @override
  State<RecipePage> createState() => _RecipePage();
}

class _RecipePage extends State<RecipePage> {
  int _rating = 0;
  final List<Comment> _comments = [];
  final TextEditingController _commentController = TextEditingController();

  final User user2 = User(
    id: 4,
    username: 'Matias',
    email: 'mati@gmail.com',
    password: '123',
    profilePic: 'assets/images/pfp4.jpg',
    recipeLists: [],
  );

  late final Product sampleProduct;

  Widget _buildStars(int index) {
    return IconButton(
      icon: Image.asset(
        index < _rating
            ? 'assets/icons/StarFull.png'
            : 'assets/icons/StarEmpty.png',
        width: 30,
        height: 30,
      ),
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
      },
    );
  }

  void showIngredientDetails(BuildContext context, Ingredient ingredient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(ingredient.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Cantidad: ${ingredient.amount}'),
              Text('Tipo: ${ingredient.type}'),
              Text('Precio: ${ingredient.price}'),
              Text(
                  'Vendedor: ${ingredient.seller?.username ?? "No especificado"}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addIngredientToCart(context, ingredient);
              },
              child: const Text(
                'Añadir al carrito',
                style: TextStyle(fontSize: 15),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cerrar',
                style: TextStyle(fontSize: 15),
              ),
            ),
          ],
        );
      },
    );
  }

  void _addToList(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agregar a lista'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.user.recipeLists.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.user.recipeLists[index].name),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                            'Añadido a:  ${widget.user.recipeLists[index].name}'),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            )
          ],
        );
      },
    );
  }

  void _shareRecipe(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Receta compartida'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            )
          ],
        );
      },
    );
  }

  void _deleteRecipe(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Receta eliminada'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            )
          ],
        );
      },
    );
  }

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        _comments
            .add(Comment(user: widget.user, text: _commentController.text));
        _commentController.clear();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    sampleProduct = Product(
        id: 1,
        name: 'Filtro de nylon',
        description: 'A high-quality coffee machine for espresso lovers.',
        price: 5700,
        seller: user2,
        image: 'assets/images/filtro.jpg');
    _comments.add(Comment(user: user2, text: 'Muy bueno, lo recomiendo mucho'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          IconButton(
            onPressed: () => _deleteRecipe(context),
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () => _addToList(context),
            icon: const Icon(Icons.add),
          ),
          IconButton(
            onPressed: () => _shareRecipe(context),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.recipe.image, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              widget.recipe.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(widget.recipe.creator.profilePic),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UserPage(user: widget.recipe.creator),
                        ));
                  },
                  child: Text(
                    widget.recipe.creator.username,
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                )
              ],
            ),
            Row(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: List.generate(5, (index) => _buildStars(index)),
                ),
                const SizedBox(width: 5),
                Text(
                  '${widget.recipe.rating}/5',
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                )
              ],
            ),
            const Text(
              'Ingredientes: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.recipe.ingredientProduct.map((ingredient) {
                return GestureDetector(
                  onTap: () => showIngredientDetails(context, ingredient),
                  child: Row(
                    children: [
                      const Icon(Icons.circle, size: 12),
                      const SizedBox(width: 4),
                      Text(
                        '${ingredient.name} (${ingredient.amount})',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            const Text(
              'Instrucciones: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              widget.recipe.instructions,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            const Text(
              'Productos relacionados: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _showProductDetails(context, sampleProduct),
              child: Row(
                children: [
                  Image.asset(
                    sampleProduct.image,
                    width: 40,
                    height: 40,
                  ),
                  const Icon(Icons.local_offer, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    '${sampleProduct.name} - \$${sampleProduct.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            const Text(
              'Comentarios: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Display existing comments
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _comments.length,
              itemBuilder: (context, index) {
                final comment = _comments[index];
                return ListTile(
                  title: Text(comment.user.username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(comment.text),
                );
              },
            ),
            const SizedBox(height: 16),
            // Input field for new comments
            TextField(
              controller: _commentController,
              decoration: const InputDecoration(
                labelText: 'Escribe un comentario...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _addComment,
              child: const Text('Agregar Comentario'),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductDetails(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(product.name),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                product.image,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              Text('Descripción: ${product.description}'),
              Text('Precio: ${product.price}'),
              Text('Vendedor: ${product.seller.username}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _addToCart(context, product);
              },
              child: const Text('Agregar al carrito'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            )
          ],
        );
      },
    );
  }

  void _addToCart(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadido al carrito'),
          content: Text('${product.name} ha sido añadido al carrito'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            )
          ],
        );
      },
    );
  }

  void _addIngredientToCart(BuildContext context, Ingredient ingredient) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Añadido al carrito'),
          content: Text('${ingredient.name} ha sido añadido al carrito.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('Cerrar'),
            )
          ],
        );
      },
    );
  }
}
