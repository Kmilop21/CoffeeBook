import 'package:coffeebook/models/user.dart';

class Ingredient {
  final String name;
  final String type;
  final double price;
  final User seller;
  final String amount;

  Ingredient({
    required this.name,
    required this.type,
    required this.price,
    required this.seller,
    required this.amount,
  });
}
