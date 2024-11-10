import 'package:coffeebook/utils/recipe_db.dart';
import 'package:coffeebook/pages/settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  final String username;

  const HomePage({
    super.key,
    required this.username,
  });

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Recipe? recipeOfTheDay;
  List<Recipe> recentRecipes = [];

  @override
  void initState() {
    super.initState();
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    // Fetch recent recipes from the database
    recentRecipes = await RecipeDbHelper.getRecentRecipes();

    setState(() {}); // Trigger UI update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('CoffeeBook'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${widget.username}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            if (recipeOfTheDay != null) ...[
              const Text(
                'Recipe of the Day',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => RecipePage(recipe: recipeOfTheDay!),
                  //     ),
                  //   );
                  // },
                  // child: RecipeCard(recipe: recipeOfTheDay!),
                  ),
            ],
            const SizedBox(height: 32),
            const Text(
              'Recently Viewed Recipes',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            if (recentRecipes.isNotEmpty)
              ...recentRecipes.map((recipe) => GestureDetector(
                  // onTap: () {
                  //   Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //       builder: (context) => RecipePage(recipe: recipe),
                  //     ),
                  //   );
                  // },
                  // child: RecipeCard(recipe: recipe),
                  )),
            if (recentRecipes.isEmpty)
              const Center(child: Text('No recent recipes')),
          ],
        ),
      ),
    );
  }
}

// Custom widget to display a recipe card
class RecipeCard extends StatelessWidget {
  final Recipe recipe;

  const RecipeCard({
    super.key,
    required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 350,
      height: 100,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Image.asset(
                recipe.image,
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
                    recipe.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rating: ${recipe.rating.toString()}',
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
