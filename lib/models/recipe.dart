import 'package:coffeebook/models/ingredient.dart';
import 'package:coffeebook/models/user.dart';

class Recipe {
  final int id;
  final String name;
  final User creator;
  final String instructions;
  final String image;
  final double rating;
  final String type;
  final List<Ingredient> ingredients;

  Recipe({
    required this.id,
    required this.name,
    required this.creator,
    required this.instructions,
    required this.image,
    required this.rating,
    required this.type,
    required this.ingredients,
  });
}
