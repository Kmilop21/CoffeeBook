import 'package:coffeebook/models/user.dart';
import 'package:coffeebook/pages/browse_page.dart';
import 'package:flutter/material.dart';

class ListsPage extends StatefulWidget {
  const ListsPage({
    super.key,
    required this.user,
  });

  final User user;

  @override
  State<StatefulWidget> createState() => _ListsPageState();
}

class _ListsPageState extends State<ListsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _recipeList(),
    );
  }

  Widget _recipeList() {
    return ListView.separated(
      itemCount: widget.user.recipeLists.length,
      itemBuilder: (context, index) {
        final recipeList = widget.user.recipeLists[index];
        return ListTile(
          leading: Image.asset(
            recipeList.recipes.first.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
          title: Text(recipeList.name),
          subtitle: Text(recipeList.creator.username),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BrowsePage(
                  recipes: recipeList.recipes,
                  showBackButton: true,
                  user: widget.user,
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
