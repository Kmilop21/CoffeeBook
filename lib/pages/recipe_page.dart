import 'package:flutter/material.dart';
import 'package:coffeebook/models/recipe.dart';

class RecipePage extends StatefulWidget {
  final Recipe recipe;

  const RecipePage({super.key, required this.recipe});

  @override
  State<RecipePage> createState() => _RecipePage();
}

class _RecipePage extends State<RecipePage> {
  int _rating = 0;

  Widget _buildStars(int index) {
    return IconButton(
      icon: Image.asset(
        index < _rating
            ? 'assets/icons/StarFull.png'
            : 'assets/icons/StarEmpty.png',
        width: 30,
        height: 30,
      ),
      onPressed: () {
        setState(() {
          _rating = index + 1;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.recipe.image, fit: BoxFit.cover),
            const SizedBox(height: 16),
            Text(
              widget.recipe.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: AssetImage(widget.recipe.creator.profilePic),
                ),
                const SizedBox(width: 5),
                Text(
                  //'Por: ${widget.recipe.creator.username}',
                  widget.recipe.creator.username,
                  style: const TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: List.generate(5, (index) => _buildStars(index)),
            ),
            Text(
              widget.recipe.instructions,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
