import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/state/app_state.dart';
import 'package:my_news_app/widgets/article_card.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Search Articles'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    appState.searchArticles(_searchController.text);
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: appState.articles.isEmpty
                ? Center(child: Text('No results found'))
                : ListView.builder(
              itemCount: appState.articles.length,
              itemBuilder: (context, index) {
                return ArticleCard(article: appState.articles[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
