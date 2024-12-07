import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:my_news_app/models/article_model.dart';

class ApiService {
  final String apiKey = '30d0a035092940c9a02700e6aca6ba10';
  final String apiUrl = 'https://newsapi.org/v2/top-headlines?country=us&apiKey=';
  final String searchUrl = 'https://newsapi.org/v2/everything?q=';

  Future<List<Article>> fetchArticles() async {
    print('Fetching articles...');
    final response = await http.get(Uri.parse(apiUrl + apiKey));

    if (response.statusCode == 200) {
      print('Articles fetched successfully');
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];

      print('API Response: $json'); // Print the API response

      List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();
      print('Parsed articles: ${articles.length}');
      return articles;
    } else {
      print('Failed to load articles');
      throw Exception('Failed to load articles');
    }
  }

  Future<List<Article>> searchArticles(String query) async {
    print('Searching articles...');
    final response = await http.get(Uri.parse(searchUrl + query + '&apiKey=' + apiKey));

    if (response.statusCode == 200) {
      print('Search results fetched successfully');
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];

      print('Search API Response: $json'); // Print the search API response

      List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();
      print('Parsed search articles: ${articles.length}');
      return articles;
    } else {
      print('Failed to search articles');
      throw Exception('Failed to search articles');
    }
  }

  Future<List<Article>> fetchArticlesByCategory(String category) async {
    final String categoryUrl = 'https://newsapi.org/v2/top-headlines?country=us&category=$category&apiKey=$apiKey';
    final response = await http.get(Uri.parse(categoryUrl));

    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(response.body);
      List<dynamic> body = json['articles'];

      print('Category API Response: $json'); // Print the category API response

      List<Article> articles = body.map((dynamic item) => Article.fromJson(item)).toList();
      print('Parsed category articles: ${articles.length}');
      return articles;
    } else {
      print('Failed to load articles for category');
      throw Exception('Failed to load articles for category');
    }
  }
}
