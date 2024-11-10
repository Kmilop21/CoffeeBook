import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:coffeebook/utils/user_db.dart';

class Recipe {
  final int id;
  final String name;
  final User creator;
  final String instructions;
  final String image;
  final double rating;
  final String type;
  final List<String> ingredients; //format: name, amount
  final int preparationTime; //minutes

  Recipe({
    required this.id,
    required this.name,
    required this.creator,
    required this.instructions,
    required this.image,
    required this.rating,
    required this.type,
    required this.ingredients,
    required this.preparationTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'creator': creator.id,
      'instructions': instructions,
      'image': image,
      'rating': rating,
      'type': type,
      'ingredients': ingredients.join('|'),
      'preparationTime': preparationTime,
    };
  }

  static Future<Recipe> fromMap(Map<String, dynamic> map) async {
    // Fetch User based on creator_id
    final creator = await UserDbHelper.getUser(map['creator_id']);
    // Fetch Ingredient list based on comma-separated IDs
    final ingredients = (map['ingredients'] as String).split('|');

    return Recipe(
      id: map['id'],
      name: map['name'],
      creator: creator,
      instructions: map['instructions'],
      image: map['image'],
      rating: map['rating'],
      type: map['type'],
      ingredients: ingredients,
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
          creator_id INTEGER,
          instructions TEXT,
          image TEXT,
          rating REAL,
          type TEXT,
          ingredients TEXT,
          preparationTime INTEGER,
          FOREIGN KEY (creator_id) REFERENCES users(id)
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

  static Future<List<Recipe>> getRecipes() async {
    final db = await RecipeDbHelper.database();
    final List<Map<String, dynamic>> maps = await db.query('recipes');
    List<Recipe> recipes = [];

    for (var map in maps) {
      // Fetch the User object based on the creator ID
      final creatorId = map['creator'] as int;
      final user = await UserDbHelper.getUser(creatorId);

      final ingredients = (map['ingredients'] as String).split('|');

      // Create the Recipe instance
      recipes.add(Recipe(
        id: map['id'],
        name: map['name'],
        creator: user,
        instructions: map['instructions'],
        image: map['image'],
        rating: map['rating'],
        type: map['type'],
        ingredients: ingredients,
        preparationTime: map['preparationTime'],
      ));
    }

    return recipes;
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

  // Add a recipe to the recent list
  static Future<void> addRecentRecipe(int recipeId) async {
    final db = await RecipeDbHelper.database();

    // Insert with a timestamp
    await db.insert(
      'recent_recipes',
      {
        'recipe_id': recipeId,
        'opened_at': DateTime.now().millisecondsSinceEpoch
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

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
    return Future.wait(
        recentMaps.map((map) async => await Recipe.fromMap(map)).toList());
  }
}
