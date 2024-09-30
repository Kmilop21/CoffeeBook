import 'package:coffeebook/models/recipe.dart';
import 'package:coffeebook/models/recipe_list.dart';

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
}
