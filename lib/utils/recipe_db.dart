import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Recipe {
  final int? id;
  final String name;
  final String instructions;
  final String image;
  final String type;
  final List<String> ingredients; //format: name, amount
  final int preparationTime; //minutes

  Recipe({
    required this.id,
    required this.name,
    required this.instructions,
    required this.image,
    required this.type,
    required this.ingredients,
    required this.preparationTime,
  });

  Recipe copyWith({
    int? id,
    String? name,
    String? instructions,
    String? image,
    String? type,
    List<String>? ingredients,
    int? preparationTime,
  }) {
    return Recipe(
      id: id ?? this.id,
      name: name ?? this.name,
      instructions: instructions ?? this.instructions,
      image: image ?? this.image,
      type: type ?? this.type,
      ingredients: ingredients ?? this.ingredients,
      preparationTime: preparationTime ?? this.preparationTime,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'instructions': instructions,
      'image': image,
      'type': type,
      'ingredients': ingredients.join('|'),
      'preparationTime': preparationTime,
    };
  }

  // Create a Recipe from a database Map
  static Recipe fromMap(Map<String, dynamic> map) {
    return Recipe(
      id: map['id'],
      name: map['name'],
      instructions: map['instructions'],
      image: map['image'],
      type: map['type'],
      ingredients: (map['ingredients'] as String).split('|'), // Convert to list
      preparationTime: map['preparationTime'],
    );
  }
}

class RecipeDbHelper {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'recipes_database.db'),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE recipes(
          id INTEGER PRIMARY KEY,
          name TEXT,
          instructions TEXT,
          image TEXT,
          type TEXT,
          ingredients TEXT,
          preparationTime INTEGER
        )
        ''');

        await db.execute('''
        CREATE TABLE recent_recipes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          recipe_id INTEGER,
          opened_at INTEGER,
          FOREIGN KEY (recipe_id) REFERENCES recipes(id)
        )
        ''');
      },
      version: 1,
    );
  }

  static Future<void> insertRecipe(Recipe recipe) async {
    final db = await RecipeDbHelper.database();
    await db.insert(
      'recipes',
      recipe.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve all recipes from the database
  static Future<List<Recipe>> getRecipes() async {
    final db = await RecipeDbHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('recipes');

    // Convert each map to a Recipe object
    return maps.map((map) => Recipe.fromMap(map)).toList();
  }

  static Future<Recipe> getRecipeById(int recipeId) async {
    final db = await RecipeDbHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [recipeId],
    );

    if (maps.isNotEmpty) {
      return Recipe.fromMap(maps.first);
    } else {
      throw Exception('Recipe not found');
    }
  }

  static Future<void> updateRecipe(Recipe recipe) async {
    final db = await RecipeDbHelper.database();
    await db.update(
      'recipes',
      recipe.toMap(),
      where: 'id = ?',
      whereArgs: [recipe.id],
    );
  }

  static Future<void> deleteRecipe(int id) async {
    final db = await RecipeDbHelper.database();
    await db.delete(
      'recipes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> addRecentRecipe(int recipeId) async {
    final db = await RecipeDbHelper.database();

    // Check if the recipe is already in the recent_recipes table
    final existingRecipe = await db.query(
      'recent_recipes',
      where: 'recipe_id = ?',
      whereArgs: [recipeId],
    );

    if (existingRecipe.isNotEmpty) {
      // If it exists, update the 'opened_at' timestamp
      await db.update(
        'recent_recipes',
        {
          'opened_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'recipe_id = ?',
        whereArgs: [recipeId],
      );
    } else {
      // If not, insert a new entry
      await db.insert(
        'recent_recipes',
        {
          'recipe_id': recipeId,
          'opened_at': DateTime.now().millisecondsSinceEpoch
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    // Limit recent recipes to 3, deleting older entries
    await db.delete(
      'recent_recipes',
      where:
          'id NOT IN (SELECT id FROM recent_recipes ORDER BY opened_at DESC LIMIT 3)',
    );
  }

  // Retrieve the 3 most recent recipes
  static Future<List<Recipe>> getRecentRecipes() async {
    final db = await RecipeDbHelper.database();

    final List<Map<String, dynamic>> recentMaps = await db.rawQuery('''
      SELECT r.*
      FROM recent_recipes rr
      JOIN recipes r ON rr.recipe_id = r.id
      ORDER BY rr.opened_at DESC
      LIMIT 3
    ''');

    // Convert maps to Recipe objects
    return recentMaps.map((map) => Recipe.fromMap(map)).toList();
  }
}
