import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_news_app/state/app_state.dart';
import 'package:my_news_app/widgets/article_card.dart';
import 'package:my_news_app/screens/article_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool _isDescending = true;

  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);

    List<Map<String, dynamic>> sortedHistoryArticles = List.from(appState.historyArticles);
    sortedHistoryArticles.sort((a, b) {
      final dateA = a['datetime'] as DateTime;
      final dateB = b['datetime'] as DateTime;
      return _isDescending ? dateB.compareTo(dateA) : dateA.compareTo(dateB);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
        actions: [
          IconButton(
            icon: Icon(Icons.sort),
            onPressed: () {
              setState(() {
                _isDescending = !_isDescending;
              });
            },
            tooltip: _isDescending ? 'Sort: Newest to Oldest' : 'Sort: Oldest to Newest',
          ),
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Clear All History'),
                    content: Text('Are you sure you want to clear all history?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text('Clear'),
                        onPressed: () {
                          appState.clearHistory();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: sortedHistoryArticles.isEmpty
          ? Center(child: Text('No history yet'))
          : ListView.builder(
        itemCount: sortedHistoryArticles.length,
        itemBuilder: (context, index) {
          final historyItem = sortedHistoryArticles[index];
          final article = historyItem['article'];
          final datetime = historyItem['datetime'] as DateTime;

          return Dismissible(
            key: Key(article.title),
            onDismissed: (direction) {
              appState.removeFromHistory(article);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Article removed from history'),
                ),
              );
            },
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 32,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            secondaryBackground: Container(
              color: Colors.red,
              alignment: Alignment.centerRight,
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Delete',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 8),
                  Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 32,
                  ),
                ],
              ),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(article: article),
                  ),
                );
              },
              child: ListTile(
                title: ArticleCard(article: article),
                subtitle: Text(
                  'Viewed on: ${datetime.toLocal().toString().split(' ')[0]} at ${datetime.toLocal().toString().split(' ')[1].substring(0, 5)}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
