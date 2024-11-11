import 'package:coffeebook/utils/user_db.dart';
import 'package:coffeebook/pages/recipe_page.dart';
import 'package:coffeebook/utils/recipe_db.dart';
import 'package:flutter/material.dart';

class BrowsePage extends StatefulWidget {
  //final List<Recipe> recipes;
  final User user;
  final bool showBackButton;

  const BrowsePage({
    super.key,
    //required this.recipes,
    required this.user,
    this.showBackButton = true,
  });

  @override
  State<StatefulWidget> createState() => _BrowsePageState();
}

class _BrowsePageState extends State<BrowsePage> {
  final TextEditingController _searchController = TextEditingController();

  List<Recipe> _recipes = [];
  List<Recipe> _filteredRecipes = [];
  String? _selectedType;
  bool _isLoading = true;
  final List<String> _types = [
    'All',
    'Espresso',
    'Filtrado',
    'Iced Coffee',
  ];

  @override
  void initState() {
    super.initState();
    //_filteredRecipes = widget.recipes;
    _loadRecipes();
    _searchController.addListener(_filterRecipes);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterRecipes);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadRecipes() async {
    try {
      // Fetch recipes from the database
      List<Recipe> recipes = await RecipeDbHelper.getRecipes();
      setState(() {
        _recipes = recipes;
        _filteredRecipes = recipes;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading recipes: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterRecipes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecipes = _recipes.where((recipe) {
        final nameLower = recipe.name.toLowerCase();
        final typeMatches = _selectedType == null ||
            _selectedType == 'All' ||
            recipe.type == _selectedType;
        return nameLower.contains(query) && typeMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: widget.showBackButton,
        title: const Text('Buscar recetas'),
      ),
      body: Column(
        children: [
          _searchBar(),
          _typeDropdown(),
          Expanded(child: _isLoading ? _loadingIndicator() : _recipeList()),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search recipes',
          border: InputBorder.none,
          suffixIcon: IconButton(
            onPressed: () {
              _searchController.clear();
              _filterRecipes();
            },
            icon: const Icon(Icons.clear),
          ),
        ),
      ),
    );
  }

  Widget _typeDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: DropdownButton<String>(
        value: _selectedType ?? 'All',
        items: _types.map((String type) {
          return DropdownMenuItem(
            value: type,
            child: Text(type),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            _selectedType = newValue;
            _filterRecipes();
          });
        },
      ),
    );
  }

  Widget _loadingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _recipeList() {
    return ListView.separated(
      itemCount: _filteredRecipes.length,
      itemBuilder: (context, index) {
        final recipe = _filteredRecipes[index];
        return ListTile(
          leading: Image.asset(
            recipe.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(recipe.name),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecipePage(
                  recipe: recipe,
                ),
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
