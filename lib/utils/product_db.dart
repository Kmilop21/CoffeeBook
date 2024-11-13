import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Product {
  final int? id; // Nullable ID for cases where it's not set
  final String name;
  final String description;
  final double price;
  final String image;

  Product({
    this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });

  // Convert Product to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'image': image,
    };
  }

  // Create Product from Map
  static Product fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      price: map['price'],
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
            image TEXT
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

  // Get all Products
  Future<List<Product>> getProducts() async {
    final db = await ProductDatabaseHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('products');
    return List.generate(maps.length, (i) => Product.fromMap(maps[i]));
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
