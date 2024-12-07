import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/models/article_model.dart';
import 'package:my_news_app/screens/article_detail_screen.dart';
import 'package:my_news_app/state/app_state.dart';
import 'package:my_news_app/screens/add_to_category_dialog.dart';

class ArticleCard extends StatelessWidget {
  final Article article;

  ArticleCard({required this.article});

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    final iconColor = Theme.of(context).iconTheme.color;

    return GestureDetector(
      onTap: () {
        appState.addToHistory(article); // Add to history
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              article.urlToImage.isNotEmpty ? article.urlToImage : 'https://via.placeholder.com/150',
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error); // Fallback in case loading fails
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      article.title,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      appState.bookmarkedArticles.contains(article)
                          ? Icons.bookmark
                          : Icons.bookmark_border,
                      color: iconColor, // Adapt to current theme
                    ),
                    onPressed: () {
                      appState.toggleBookmark(article);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            appState.bookmarkedArticles.contains(article)
                                ? 'Added to bookmarks'
                                : 'Removed from bookmarks',
                          ),
                        ),
                      );
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.add,
                      color: iconColor,
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AddToCategoryDialog(article: article),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(article.description),
            ),
          ],
        ),
      ),
    );
  }
}
