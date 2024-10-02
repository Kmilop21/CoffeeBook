import 'package:coffeebook/models/user.dart';

class Ingredient {
  final String name;
  final String? type;
  final double? price;
  final User? seller;
  final String amount;

  Ingredient({
    required this.name,
    this.type,
    this.price,
    this.seller,
    required this.amount,
  });
}
