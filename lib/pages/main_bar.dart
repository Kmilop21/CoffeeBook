import 'package:coffeebook/models/ingredient.dart';
import 'package:coffeebook/models/recipe_list.dart';
import 'package:coffeebook/utils/user_db.dart';
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
  late List<Widget> _pages;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // _pages = [
    //   HomePage(
    //     username: user1.username,
    //     recipeOfTheDay: recipe3,
    //     favoriteList: user1.recipeLists[1],
    //   ),
    //   BrowsePage(showBackButton: false, /*recipes: allRecipes,*/ user: user1),
    //   const CreateRecipePage(),
    //   ListsPage(user: user1),
    //   CartPage(),
    //   UserPage(user: user1),
    // ];
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
              icon: Icon(Icons.shopping_cart),
              // CircleAvatar(
              //   radius: 16,
              //   backgroundImage: /*AssetImage(user1.profilePic)*/,
              // ),
              label: 'camilo' //user1.username,
              ),
        ],
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple,
        unselectedLabelStyle: const TextStyle(color: Colors.purple),
      ),
    );
  }
}
