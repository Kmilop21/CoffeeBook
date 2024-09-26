import 'package:coffeebook/models/recipe.dart';
import 'package:coffeebook/models/user.dart';
import 'package:coffeebook/pages/recipe_page.dart';
import 'package:flutter/material.dart';

class BrowsePage extends StatefulWidget {
  const BrowsePage({
    super.key,
    /*required this.title*/
  });

  //final String title;

  @override
  State<StatefulWidget> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final List<Recipe> _recipes = [
    Recipe(
      id: 1,
      name: 'café bombóm de fresa',
      creator: User(
          id: 1,
          username: 'felipe',
          email: 'felipe@gmail.com',
          password: '123',
          recipes: []),
      ingredients: '',
      instructions:
          'tritura 2 fresas maduras picadas\nAgrega 2 chucharadas de leche condensada\nIntegra muy bien',
      image: 'assets/images/placeholder.png',
    ),
    Recipe(
      id: 2,
      name: 'café tiramisú',
      creator: User(
          id: 1,
          username: 'benjamin',
          email: 'benjamin@gmail.com',
          password: 'abc',
          recipes: [[]]),
      ingredients: '',
      instructions:
          'añadir a la licuadora 80 ml de leche de almendras, 2 cdas de queso crema ',
      image: 'assets/images/placeholder.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: _recipeList(),
    );
  }

  Widget _recipeList() {
    return ListView.separated(
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        final recipe = _recipes[index];
        return ListTile(
          leading: Image.asset(
            recipe.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(recipe.name),
          subtitle: Text(recipe.creator.username),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(recipe: recipe),
              ),
            );
          },
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
    );
  }
}
