import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/state/app_state.dart';
import 'package:my_news_app/widgets/article_card.dart';

class CategoryScreen extends StatelessWidget {
  final List<String> categories = [
    'Business',
    'Entertainment',
    'General',
    'Health',
    'Science',
    'Sports',
    'Technology',
  ];

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      body: ListView(
        children: categories.map((category) {
          return ListTile(
            title: Text(category),
            onTap: () {
              appState.fetchArticlesByCategory(category.toLowerCase());
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    appBar: AppBar(
                      title: Text('$category News'),
                    ),
                    body: appState.articles.isEmpty
                        ? Center(child: CircularProgressIndicator())
                        : ListView.builder(
                      itemCount: appState.articles.length,
                      itemBuilder: (context, index) {
                        return ArticleCard(article: appState.articles[index]);
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
