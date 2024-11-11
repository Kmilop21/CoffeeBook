import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:coffeebook/utils/recipe_db.dart';

class RecipeList {
  final int id;
  final String name;
  final List<Recipe> recipes;

  RecipeList({
    required this.id,
    required this.name,
    required this.recipes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'recipes': recipes.map((recipe) => recipe.id).join(','),
    };
  }

  static RecipeList fromMap(Map<String, dynamic> map, List<Recipe> recipes) {
    return RecipeList(
      id: map['id'],
      name: map['name'],
      recipes: recipes,
    );
  }
}

class RecipeListDbHelper {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'coffeebook.db'),
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE users(
          id INTEGER PRIMARY KEY,
          username TEXT,
          email TEXT,
          password TEXT,
          profilePic TEXT,
          recipeLists TEXT
        )''');

        await db.execute('''CREATE TABLE recipes(
          id INTEGER PRIMARY KEY,
          name TEXT,
          instructions TEXT,
          image TEXT,
          rating REAL,
          type TEXT,
          ingredients TEXT,
          preparationTime INTEGER
        )''');

        await db.execute('''CREATE TABLE recipe_lists(
          id INTEGER PRIMARY KEY,
          name TEXT,
          recipes TEXT
        )''');

        await db.execute('''CREATE TABLE recipe_lists_recipes(
          recipeListId INTEGER,
          recipeId INTEGER,
          FOREIGN KEY (recipeListId) REFERENCES recipe_lists(id),
          FOREIGN KEY (recipeId) REFERENCES recipes(id)
        )''');
      },
      version: 1,
    );
  }

  // Insert RecipeList
  static Future<void> insertRecipeList(RecipeList recipeList) async {
    final db = await RecipeListDbHelper.database();
    await db.insert(
      'recipe_lists',
      recipeList.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert recipe_list to recipe mappings in the junction table
    for (Recipe recipe in recipeList.recipes) {
      await db.insert(
        'recipe_lists_recipes',
        {'recipeListId': recipeList.id, 'recipeId': recipe.id},
      );
    }
  }

  static Future<List<RecipeList>> getRecipeLists(int userId) async {
    final db = await RecipeListDbHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'recipe_lists',
      whereArgs: [userId],
    );

    List<RecipeList> recipeLists = [];
    for (var map in maps) {
      final List<Map<String, dynamic>> recipeMaps = await db.query(
        'recipe_lists_recipes',
        where: 'recipeListId = ?',
        whereArgs: [map['id']],
      );

      List<Recipe> recipes = [];
      for (var recipeMap in recipeMaps) {
        recipes.add(await getRecipe(recipeMap['recipeId']));
      }

      recipeLists.add(RecipeList.fromMap(map, recipes));
    }
    return recipeLists;
  }

  //Quering the recipes table with a recipeID
  static Future<Recipe> getRecipe(int recipeId) async {
    final db = await RecipeListDbHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'recipes',
      where: 'id = ?',
      whereArgs: [recipeId],
    );

    if (maps.isNotEmpty) {
      return Recipe(
        id: maps.first['id'],
        name: maps.first['name'],
        instructions: maps.first['instructions'],
        image: maps.first['image'],
        rating: maps.first['rating'],
        type: maps.first['type'],
        ingredients:
            maps.first['ingredients'].split(','), // Convert back to List
        preparationTime: maps.first['preparationTime'],
      );
    } else {
      throw Exception('Recipe not found');
    }
  }

  // Update RecipeList
  static Future<void> updateRecipeList(RecipeList recipeList) async {
    final db = await RecipeListDbHelper.database();
    await db.update(
      'recipe_lists',
      recipeList.toMap(),
      where: 'id = ?',
      whereArgs: [recipeList.id],
    );

    // Update recipes in the junction table
    await db.delete('recipe_lists_recipes',
        where: 'recipeListId = ?', whereArgs: [recipeList.id]);
    for (Recipe recipe in recipeList.recipes) {
      await db.insert(
        'recipe_lists_recipes',
        {'recipeListId': recipeList.id, 'recipeId': recipe.id},
      );
    }
  }

  // Delete RecipeList
  static Future<void> deleteRecipeList(int id) async {
    final db = await RecipeListDbHelper.database();
    await db.delete('recipe_lists', where: 'id = ?', whereArgs: [id]);
    await db.delete('recipe_lists_recipes',
        where: 'recipeListId = ?', whereArgs: [id]);
  }
}
