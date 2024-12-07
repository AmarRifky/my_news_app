import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/state/app_state.dart';
import 'package:my_news_app/widgets/article_card.dart';

class BookmarkScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: appState.bookmarkedArticles.isEmpty
          ? Center(child: Text('No bookmarks yet'))
          : ListView.builder(
        itemCount: appState.bookmarkedArticles.length,
        itemBuilder: (context, index) {
          return ArticleCard(article: appState.bookmarkedArticles[index]);
        },
      ),
    );
  }
}
