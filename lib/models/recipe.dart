import 'package:coffeebook/models/ingredient.dart';
import 'package:coffeebook/models/user.dart';

class Recipe {
  final int id;
  final String name;
  final User creator;
  final String instructions;
  final String image;
  final List<Ingredient> ingredientProduct;

  Recipe({
    required this.id,
    required this.name,
    required this.creator,
    required this.instructions,
    required this.image,
    required this.ingredientProduct,
  });
}
