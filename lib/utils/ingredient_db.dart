import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Ingredient {
  final int? id;
  final String name;
  final String? type;
  final double? price;
  final String amount;

  Ingredient({
    this.id,
    required this.name,
    this.type,
    this.price,
    required this.amount,
  });

  // Convert Ingredient to Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'price': price,
      'amount': amount,
    };
  }

  // Create Ingredient from Map
  static Ingredient fromMap(Map<String, dynamic> map) {
    return Ingredient(
      id: map['id'],
      name: map['name'],
      type: map['type'],
      price: map['price'] != null ? map['price'] as double : null,
      amount: map['amount'],
    );
  }
}

class IngredientDBHelper {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'coffeebook.db'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE ingredients(
            id INTEGER PRIMARY KEY,
            name TEXT,
            type TEXT,
            price REAL,
            amount TEXT
          )
        ''');
      },
      version: 1,
    );
  }

  // Insert Ingredient
  Future<void> insertIngredient(Ingredient ingredient) async {
    final db = await IngredientDBHelper.database();
    await db.insert(
      'ingredients',
      ingredient.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get all Ingredients
  Future<List<Ingredient>> getIngredients() async {
    final db = await IngredientDBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('ingredients');

    return List.generate(maps.length, (i) {
      return Ingredient.fromMap(maps[i]);
    });
  }

  // Get Ingredients by a list of IDs
  static Future<List<Ingredient>> getIngredientsByIds(List<int> ids) async {
    final db = await IngredientDBHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'ingredients',
      where: 'id IN (${ids.join(',')})',
    );

    return maps.map((map) => Ingredient.fromMap(map)).toList();
  }

  // Update Ingredient
  Future<void> updateIngredient(Ingredient ingredient) async {
    final db = await IngredientDBHelper.database();
    await db.update(
      'ingredients',
      ingredient.toMap(),
      where: 'id = ?',
      whereArgs: [ingredient.id],
    );
  }

  // Delete Ingredient
  Future<void> deleteIngredient(int id) async {
    final db = await IngredientDBHelper.database();
    await db.delete(
      'ingredients',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
