import 'package:coffeebook/models/ingredient.dart';
import 'package:coffeebook/models/recipe_list.dart';
import 'package:coffeebook/models/user.dart';
import 'package:coffeebook/models/recipe.dart';
import 'package:coffeebook/pages/cart_page.dart';
import 'package:coffeebook/pages/home_page.dart';
import 'package:coffeebook/pages/lists_page.dart';
import 'package:coffeebook/pages/user_page.dart';
import 'package:coffeebook/pages/browse_page.dart';
import 'package:coffeebook/pages/create_recipe_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';

class MainBar extends StatefulWidget {
  const MainBar({super.key, required this.title});

  final String title;

  @override
  State<MainBar> createState() => _MainBarState();
}

class _MainBarState extends State<MainBar> {
  User user1 = User(
    id: 1,
    username: 'Camilo',
    email: 'cam.provoste@gmail.com',
    password: '1321',
    profilePic: 'assets/images/pfp1.jpg',
    recipeLists: [],
  );
  User user2 = User(
    id: 2,
    username: 'Benjamin',
    email: 'benjamin@gmail.com',
    password: 'abc',
    profilePic: 'assets/images/pfp2.jpg',
    recipeLists: [],
  );
  User user3 = User(
    id: 1,
    username: 'Felipe',
    email: 'felipe@gmail.com',
    password: '123',
    profilePic: 'assets/images/pfp3.jpg',
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
      instructions:
          'Tritura 2 fresas maduras picadas\nAgrega 2 chucharadas de leche condensada\nIntegra muy bien...',
      image: 'assets/images/bombomfresa.jpg',
      rating: 2,
      type: 'Espresso',
      ingredients: [
        Ingredient(
            name: 'Fresas maduras',
            type: 'Fruta',
            price: 3000,
            seller: user2,
            amount: '2 unidades'),
        Ingredient(
            name: 'Leche condensada',
            type: 'Lacteo',
            price: 2500,
            seller: user3,
            amount: '2 cucharadas'),
        Ingredient(
            name: 'Leche',
            type: 'Lacteo',
            price: 1000,
            seller: user3,
            amount: '1/2 taza'),
        Ingredient(
            name: 'Café sello rojo',
            type: 'Café',
            price: 8000,
            seller: user3,
            amount: '100 ml'),
      ],
    );
    Recipe recipe2 = Recipe(
      id: 2,
      name: 'café tiramisú',
      creator: user2,
      instructions:
          'Añadir a la licuadora 80 ml de leche de almendras\n Añadir 2 cdas de queso crema...',
      image: 'assets/images/cafetiramisu.jpg',
      rating: 3.5,
      type: 'Filtrado',
      ingredients: [
        Ingredient(
          name: 'Queso crema',
          type: 'Lacteo',
          price: 3000,
          seller: user2,
          amount: '2 cdas',
        ),
        Ingredient(
          name: 'Leche de almendras',
          type: 'Lacteo',
          price: 2000,
          seller: user2,
          amount: '80 ml',
        ),
        Ingredient(
          name: 'Miel',
          type: 'Dulce',
          price: 2000,
          seller: user2,
          amount: '1 cda',
        ),
        Ingredient(
          name: 'Cacao en polvo',
          type: 'Cacao en polvo',
          price: 2000,
          seller: user2,
          amount: 'Al gusto',
        ),
        Ingredient(
          name: 'Hielo',
          type: 'Hielo',
          price: 1500,
          seller: user2,
          amount: 'Al gusto',
        ),
        Ingredient(
          name: 'Café Matiz Ámbar',
          type: 'Café',
          price: 5000,
          seller: user2,
          amount: '100 g',
        ),
        Ingredient(
          name: 'Agua',
          type: 'Liquido',
          price: 0.0,
          seller: user2,
          amount: '300 ml',
        ),
        Ingredient(
          name: 'Galletas Ducales Tentación',
          type: 'Agregado',
          price: 2000,
          seller: user2,
          amount: 'Para decorar',
        ),
      ],
    );
    Recipe recipe3 = Recipe(
      id: 3,
      name: 'Mimosa frappé de café',
      creator: user3,
      instructions:
          'En una licuadora, agrega 1 taza de cascos de mandarina congelados\nAgrega 2 oz de vino proseco y licúa...',
      image: 'assets/images/mimosafrappe.jpg',
      rating: 4.9,
      type: 'Iced Coffee',
      ingredients: [
        Ingredient(
          name: 'Cascos de mandarina congelados',
          type: 'Fruta',
          price: 4000,
          seller: user3,
          amount: '1 taza',
        ),
        Ingredient(
          name: 'Vino prosecco',
          type: 'Alcohol',
          price: 11000,
          seller: user3,
          amount: '2 oz',
        ),
        Ingredient(
          name: 'Café Matiz Escarlata',
          type: 'Cafe',
          price: 5000,
          seller: user3,
          amount: '1/3 taza',
        ),
      ],
    );

    RecipeList favouriteRecipes = RecipeList(
      id: 1,
      name: 'Cafés favoritos',
      creator: user1,
      recipes: [recipe1, recipe2],
    );
    RecipeList recipesToTry = RecipeList(
      id: 2,
      name: 'Recetas a intentar',
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
    user2.recipeLists.addAll([createdRecipes, favouriteRecipes, recipesToTry]);
    user3.recipeLists.addAll([createdRecipes, favouriteRecipes, recipesToTry]);

    _pages = [
      HomePage(
        username: user1.username,
        recipeOfTheDay: recipe3,
        favoriteList: user1.recipeLists[1],
      ),
      BrowsePage(showBackButton: false, recipes: allRecipes, user: user1),
      const CreateRecipePage(),
      ListsPage(user: user1),
      CartPage(),
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
            label: 'Inicio',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
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
            label: 'Listas',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage(user1.profilePic),
            ),
            label: user1.username,
          ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple,
        unselectedLabelStyle: const TextStyle(color: Colors.purple),
      ),
    );
  }
}
