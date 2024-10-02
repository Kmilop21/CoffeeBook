import 'package:coffeebook/models/user.dart';

class Product {
  final int id;
  final String name;
  final String description;
  final double price;
  final User seller;
  final String image;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.seller,
    required this.image,
  });
}
