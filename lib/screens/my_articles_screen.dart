import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/state/app_state.dart';
import 'package:my_news_app/widgets/article_card.dart';
import 'package:my_news_app/models/article_model.dart';

class MyArticlesScreen extends StatefulWidget {
  @override
  _MyArticlesScreenState createState() => _MyArticlesScreenState();
}

class _MyArticlesScreenState extends State<MyArticlesScreen> {
  Map<String, bool> _isAlphabeticalMap = {};

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    List<String> sortedCategories = appState.categories.keys.toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('My Articles'),
      ),
      body: ListView(
        children: sortedCategories.map((categoryName) {
          _isAlphabeticalMap[categoryName] ??= true;

          List<Article> articles = List<Article>.from(appState.categories[categoryName]!);
          articles.sort((a, b) {
            if (_isAlphabeticalMap[categoryName]!) {
              return a.title!.toLowerCase().compareTo(b.title!.toLowerCase());
            } else {
              DateTime dateA = a.date ?? DateTime(2000);
              DateTime dateB = b.date ?? DateTime(2000);
              return dateA.compareTo(dateB);
            }
          });

          return ExpansionTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(categoryName),
                ),
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _showRenameCategoryDialog(context, appState, categoryName);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    appState.deleteCategory(categoryName);
                  },
                ),
              ],
            ),
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.sort_by_alpha),
                    onPressed: () {
                      setState(() {
                        _isAlphabeticalMap[categoryName] = true;
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: () {
                      setState(() {
                        _isAlphabeticalMap[categoryName] = false;
                      });
                    },
                  ),
                ],
              ),
              ...articles.map((article) => ArticleCard(article: article)).toList(),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showRenameCategoryDialog(BuildContext context, AppState appState, String categoryName) {
    final _renameController = TextEditingController(text: categoryName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Rename Category'),
          content: TextField(
            controller: _renameController,
            decoration: InputDecoration(hintText: 'New Category Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                appState.renameCategory(categoryName, _renameController.text);
                Navigator.of(context).pop();
              },
              child: Text('Rename'),
            ),
          ],
        );
      },
    );
  }
}
