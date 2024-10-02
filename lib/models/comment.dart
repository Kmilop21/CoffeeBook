import 'package:coffeebook/models/user.dart';

class Comment {
  final User user;
  final String text;

  Comment({required this.user, required this.text});
}
