import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/state/app_state.dart';
import 'package:my_news_app/widgets/article_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Top Headlines'),
      ),
      body: appState.articles.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: appState.articles.length,
        itemBuilder: (context, index) {
          return ArticleCard(article: appState.articles[index]);
        },
      ),
    );
  }
}
