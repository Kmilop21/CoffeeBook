import 'package:coffeebook/models/user.dart';

class Recipe {
  final int id;
  final String name;
  final User creator;
  final String ingredients;
  final String instructions;
  final String image;

  Recipe({
    required this.id,
    required this.name,
    required this.creator,
    required this.ingredients,
    required this.instructions,
    required this.image,
  });
}
