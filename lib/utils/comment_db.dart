import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:coffeebook/utils/user_db.dart';

class Comment {
  final int? id; // Make ID nullable for cases where it's not set
  final User user;
  final String text;
  final int recipeId; // Reference to the Recipe this comment belongs to

  Comment({
    this.id,
    required this.user,
    required this.text,
    required this.recipeId, // The recipe this comment is for
  });

  // Convert Comment to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': user.id, // Store only the user ID
      'text': text,
      'recipeId': recipeId, // Store recipe ID
    };
  }

  // Create Comment from Map with User data
  static Comment fromMap(Map<String, dynamic> map, User user) {
    return Comment(
      id: map['id'],
      user: user,
      text: map['text'],
      recipeId: map['recipeId'],
    );
  }
}

class CommentDatabaseHelper {
  static Future<Database> database() async {
    return openDatabase(
      join(await getDatabasesPath(), 'coffeebook.db'),
      onCreate: (db, version) async {
        // Create Comment table with a foreign key to Recipe
        await db.execute('''
          CREATE TABLE comments(
            id INTEGER PRIMARY KEY,
            userId INTEGER,
            text TEXT,
            recipeId INTEGER,
            FOREIGN KEY (userId) REFERENCES users(id),
            FOREIGN KEY (recipeId) REFERENCES recipe_lists(id)
          )
        ''');
      },
      version: 1,
    );
  }

  // Insert Comment
  Future<void> insertComment(Comment comment) async {
    final db = await CommentDatabaseHelper.database();
    await db.insert(
      'comments',
      comment.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Get Comments for a specific Recipe
  Future<List<Comment>> getCommentsForRecipe(
      int recipeId, Future<User> Function(int) getUserById) async {
    final db = await CommentDatabaseHelper.database();
    final List<Map<String, dynamic>> maps = await db.query(
      'comments',
      where: 'recipeId = ?',
      whereArgs: [recipeId],
    );

    List<Comment> comments = [];
    for (var map in maps) {
      User user = await getUserById(map['userId']);
      comments.add(Comment.fromMap(map, user));
    }
    return comments;
  }

  // Delete Comment
  Future<void> deleteComment(int id) async {
    final db = await CommentDatabaseHelper.database();
    await db.delete(
      'comments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
