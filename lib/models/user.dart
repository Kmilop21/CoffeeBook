import 'package:coffeebook/models/recipe.dart';

class User {
  final int id;
  final String username;
  final String email;
  final String password;
  final List<List<Recipe>> recipes;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.recipes,
  });
}
