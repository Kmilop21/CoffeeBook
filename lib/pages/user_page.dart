import 'package:coffeebook/utils/user_db.dart';
import 'package:coffeebook/pages/recipe_page.dart';
import 'package:flutter/material.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key, required this.user});

  final User user;

  @override
  State<StatefulWidget> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Center(
              child: CircleAvatar(
                radius: 100,
                backgroundImage: AssetImage(widget.user.profilePic),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                widget.user.username,
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.yellow.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.orangeAccent),
                ),
                child: const Text(
                  'Calificación: 4.3/5',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.greenAccent),
                ),
                child: const Text(
                  'Favoritos: 2',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.blueAccent),
                ),
                child: const Text(
                  'Recetas: 1',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Receta más popular',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipePage(
                      user: widget.user,
                      recipe: widget.user.recipeLists.first.recipes.first,
                    ),
                  ),
                );
              },
              child: SizedBox(
                width: 350,
                height: 100,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.asset(
                          widget.user.recipeLists.first.recipes.first.image,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.user.recipeLists.first.recipes.first.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
