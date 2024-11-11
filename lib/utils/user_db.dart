import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:coffeebook/utils/recipe_list_db.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final String profilePic;
  final List<RecipeList> recipeLists;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.profilePic,
    required this.recipeLists,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'profilePic': profilePic,
      'recipeLists': recipeLists.map((list) => list.id).join(','),
    };
  }

  static User fromMap(Map<String, dynamic> map, List<RecipeList> recipeLists) {
    return User(
      id: map['id'],
      username: map['username'],
      email: map['email'],
      password: map['password'],
      profilePic: map['profilePic'],
      recipeLists: recipeLists,
    );
  }
}

class UserDbHelper {
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

        // Ensure recipe tables are also created
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

  // Insert User
  static Future<void> insertUser(User user) async {
    final db = await UserDbHelper.database();

    // Insert the user itself
    await db.insert(
      'users',
      user.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert each RecipeList associated with the user
    for (var recipeList in user.recipeLists) {
      await RecipeListDbHelper.insertRecipeList(recipeList);
    }
  }

  // Retrieve User by ID with RecipeLists
  static Future<User> getUser(int id) async {
    final db = await UserDbHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      // Fetch user's recipe lists
      List<RecipeList> userRecipeLists =
          await RecipeListDbHelper.getRecipeLists(id);
      return User.fromMap(maps.first, userRecipeLists);
    } else {
      throw Exception('User not found');
    }
  }

  // Update User
  static Future<void> updateUser(User user) async {
    final db = await UserDbHelper.database();

    // Update the user's information
    await db.update(
      'users',
      user.toMap(),
      where: 'id = ?',
      whereArgs: [user.id],
    );

    // Update each RecipeList associated with the user
    for (var recipeList in user.recipeLists) {
      await RecipeListDbHelper.updateRecipeList(recipeList);
    }
  }

  // Delete User
  static Future<void> deleteUser(int id) async {
    final db = await UserDbHelper.database();

    await db.delete(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
