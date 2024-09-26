import 'package:coffeebook/models/user.dart';

class Ingredient {
  final int id;
  final String name;
  final String description;
  final String type;
  final double price;
  final User seller;

  Ingredient({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.price,
    required this.seller,
  });
}
