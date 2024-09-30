import 'package:coffeebook/models/user.dart';
import 'package:coffeebook/models/recipe.dart';

class RecipeList {
  final int id;
  final String name;
  final User creator;
  final List<Recipe> recipes;

  RecipeList({
    required this.id,
    required this.name,
    required this.creator,
    required this.recipes,
  });
}
