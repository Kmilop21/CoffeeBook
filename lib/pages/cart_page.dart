import 'package:coffeebook/models/ingredient.dart';
import 'package:coffeebook/models/product.dart';
import 'package:coffeebook/models/user.dart';
import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final Ingredient ingrediente = Ingredient(
    name: 'Cascos de mandarina congelados',
    type: 'Fruta',
    price: 4000,
    seller: User(
      id: 1,
      username: 'Felipe',
      email: 'felipe@gmail.com',
      password: '123',
      profilePic: 'assets/images/pfp3.jpg',
      recipeLists: [],
    ),
    amount: '1 taza',
  );

  final Product sampleProduct = Product(
      id: 1,
      name: 'Filtro de nylon',
      description: 'A high-quality coffee machine for espresso lovers.',
      price: 5700,
      seller: User(
        id: 1,
        username: 'Felipe',
        email: 'felipe@gmail.com',
        password: '123',
        profilePic: 'assets/images/pfp3.jpg',
        recipeLists: [],
      ),
      image: 'assets/images/filtro.jpg');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingredientes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              child: ListTile(
                title: Text(ingrediente.name),
                subtitle: Text('Valor: \$${ingrediente.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Productos',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Card(
              elevation: 4,
              child: ListTile(
                leading: Image.asset(
                  sampleProduct.image,
                  width: 50,
                  height: 50,
                ),
                title: Text(sampleProduct.name),
                subtitle: Text('Valor: \$${sampleProduct.price}'),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {},
                ),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Show confirmation dialog
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Comprado'),
                      content: const Text('Gracias por su compra'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Comprar'),
            ),
          ],
        ),
      ),
    );
  }
}
