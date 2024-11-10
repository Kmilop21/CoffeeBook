import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:coffeebook/utils/user_db.dart';

class Product {
  final int? id; // Make ID nullable for cases where it's not set
  final String name;
  final String description;
  final double price;
  final User seller;
  final String image;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.seller,
    required this.image,
  });

  // Convert Product to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'sellerId': seller.id, // Store only the seller ID as a foreign key
      'image': image,
    };
  }

  // Create Product from Map with User data
  static Product fromMap(Map<String, dynamic> map, User seller) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
      seller: seller,
      image: map['image'],
    );
  }
}

class ProductDatabaseHelper {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'coffeebook.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE products(
            id INTEGER PRIMARY KEY,
            name TEXT,
            description TEXT,
            price REAL,
            sellerId INTEGER,  // Foreign key to reference User
            image TEXT,
            FOREIGN KEY (sellerId) REFERENCES users(id)
          )
        ''');
      },
      version: 1,
    );
  }

  // Insert Product
  Future<void> insertProduct(Product product) async {
    final db = await ProductDatabaseHelper.database();
    await db.insert(
      'products',
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all Products, fetching seller data for each
  Future<List<Product>> getProducts(
      Future<User> Function(int) getUserById) async {
    final db = await ProductDatabaseHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('products');

    // For each product map, fetch the seller using getUserById function
    List<Product> products = [];
    for (var map in maps) {
      User seller = await getUserById(map['sellerId']); // Fetch the user
      products.add(Product.fromMap(map, seller));
    }
    return products;
  }

  // Update Product
  Future<void> updateProduct(Product product) async {
    final db = await ProductDatabaseHelper.database();
    await db.update(
      'products',
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
    );
  }

  // Delete Product
  Future<void> deleteProduct(int id) async {
    final db = await ProductDatabaseHelper.database();
    await db.delete(
      'products',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
