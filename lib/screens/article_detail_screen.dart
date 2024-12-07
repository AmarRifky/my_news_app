import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:my_news_app/models/article_model.dart';

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.urlToImage.isNotEmpty)
              Image.network(article.urlToImage),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.description,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                article.content ?? "No content available",
                style: TextStyle(fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () async {
                  if (article.url != null && await canLaunch(article.url!)) {
                    await launch(article.url!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Could not launch the article URL")),
                    );
                  }
                },
                child: Text('Read Full Article'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
