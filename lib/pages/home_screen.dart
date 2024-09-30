import 'package:coffeebook/models/recipe_list.dart';
import 'package:coffeebook/pages/lists_page.dart';
import 'package:coffeebook/models/user.dart';
import 'package:coffeebook/models/recipe.dart';
import 'package:coffeebook/pages/user_page.dart';
import 'package:flutter/material.dart';
import 'package:coffeebook/pages/browse_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  User user1 = User(
    id: 1,
    username: 'Camilo',
    email: 'cam.provoste@gmail.com',
    password: '1321',
    profilePic: 'assets/images/placeholder.png',
    recipeLists: [],
  );
  User user2 = User(
    id: 2,
    username: 'Benjamin',
    email: 'benjamin@gmail.com',
    password: 'abc',
    profilePic: 'assets/images/placeholder.png',
    recipeLists: [],
  );
  User user3 = User(
    id: 1,
    username: 'Felipe',
    email: 'felipe@gmail.com',
    password: '123',
    profilePic: 'assets/images/placeholder.png',
    recipeLists: [],
  );

  late List<Widget> _pages;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    //Recipes examples
    Recipe recipe1 = Recipe(
      id: 1,
      name: 'café bombóm de fresa',
      creator: user1,
      ingredients: '',
      instructions:
          'tritura 2 fresas maduras picadas\nAgrega 2 chucharadas de leche condensada\nIntegra muy bien',
      image: 'assets/images/placeholder.png',
    );
    Recipe recipe2 = Recipe(
      id: 2,
      name: 'café tiramisú',
      creator: user2,
      ingredients: '',
      instructions:
          'añadir a la licuadora 80 ml de leche de almendras, 2 cdas de queso crema ',
      image: 'assets/images/placeholder.png',
    );
    Recipe recipe3 = Recipe(
      id: 3,
      name: 'café tiramisú',
      creator: user3,
      ingredients: '',
      instructions:
          'añadir a la licuadora 80 ml de leche de almendras, 2 cdas de queso crema ',
      image: 'assets/images/placeholder.png',
    );

    RecipeList favouriteRecipes = RecipeList(
      id: 1,
      name: 'cafés favoritos',
      creator: user1,
      recipes: [recipe1, recipe2],
    );
    RecipeList recipesToTry = RecipeList(
      id: 2,
      name: 'recetas a intentar',
      creator: user1,
      recipes: [recipe3],
    );
    RecipeList createdRecipes = RecipeList(
      id: 1,
      name: 'Recetas creadas',
      creator: user1,
      recipes: [recipe1],
    );

    List<Recipe> allRecipes = [recipe1, recipe2, recipe3];

    user1.recipeLists.addAll([createdRecipes, favouriteRecipes, recipesToTry]);

    _pages = [
      const Center(
        child: Text('Home Page'),
      ),
      BrowsePage(showBackButton: false, recipes: allRecipes),
      const Center(
        child: Text('Añadir receta'),
      ),
      ListsPage(user: user1),
      UserPage(user: user1),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/add.svg',
              width: 32,
              height: 32,
            ),
            label: 'Añadir',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lists',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(user1.profilePic),
            ),
            label: 'User',
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple,
        unselectedLabelStyle: const TextStyle(color: Colors.purple),
      ),
    );
  }
}
