import 'package:flutter/material.dart';
import 'package:my_news_app/models/article_model.dart';
import 'package:my_news_app/services/api_service.dart';
import 'package:my_news_app/helper/database_helper.dart';

class AppState extends ChangeNotifier {
  List<Article> _articles = [];
  List<Article> _bookmarkedArticles = [];
  List<Map<String, dynamic>> _historyArticles = [];
  Map<String, List<Article>> _categories = {};
  bool _isLoading = false;
  String _errorMessage = '';
  bool _darkMode = false;

  final DatabaseHelper _dbHelper = DatabaseHelper();

  List<Article> get articles => _articles;
  List<Map<String, dynamic>> get historyArticles => _historyArticles;
  List<Article> get bookmarkedArticles => _bookmarkedArticles;
  Map<String, List<Article>> get categories => _categories;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get darkMode => _darkMode;

  Future<void> fetchArticles() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<Article> fetchedArticles = await ApiService().fetchArticles();
      _articles = fetchedArticles.where((article) => article.urlToImage.isNotEmpty).toList();
      print('Articles updated in state: ${_articles.length}');
    } catch (e) {
      _errorMessage = 'Failed to load articles';
      print('Error fetching articles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchArticlesByCategory(String category) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<Article> fetchedArticles = await ApiService().fetchArticlesByCategory(category);
      _articles = fetchedArticles.where((article) => article.urlToImage.isNotEmpty).toList();
      print('Articles fetched for category: $category, Count: ${_articles.length}');
    } catch (e) {
      _errorMessage = 'Failed to load articles for category $category';
      print('Error fetching articles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchArticles(String query) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      List<Article> fetchedArticles = await ApiService().searchArticles(query);
      _articles = fetchedArticles.where((article) => article.urlToImage.isNotEmpty).toList();
      print('Search results updated in state: ${_articles.length}');
    } catch (e) {
      _errorMessage = 'Failed to search articles';
      print('Error searching articles: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void toggleBookmark(Article article) {
    if (_bookmarkedArticles.contains(article)) {
      _bookmarkedArticles.remove(article);
      _dbHelper.deleteArticle(article.id!);
    } else {
      _bookmarkedArticles.add(article);
      _dbHelper.insertArticle(article.toMap());
    }
    notifyListeners();
  }

  void addBookmark(Article article) {
    _bookmarkedArticles.add(article);
    _dbHelper.insertArticle(article.toMap());
    notifyListeners();
  }

  void removeBookmark(Article article) {
    _bookmarkedArticles.remove(article);
    _dbHelper.deleteArticle(article.id!);
    notifyListeners();
  }

  void addToHistory(Article article) {
    _historyArticles.add({
      'article': article,
      'datetime': DateTime.now(),
    });
    _dbHelper.insertArticle(article.toMap());
    notifyListeners();
  }

  void removeFromHistory(Article article) {
    _historyArticles.removeWhere((item) => item['article'] == article);
    _dbHelper.deleteArticle(article.id!);
    notifyListeners();
  }

  void clearHistory() {
    _historyArticles.clear();
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void addCategory(String categoryName) {
    if (!_categories.containsKey(categoryName)) {
      _categories[categoryName] = [];
      _dbHelper.insertCategory({'name': categoryName});
      notifyListeners();
    }
  }

  void addArticleToCategory(String categoryName, Article article) {
    if (_categories.containsKey(categoryName)) {
      _categories[categoryName]!.add(article);
      _dbHelper.insertCategoryArticle({'categoryId': categoryName, 'articleId': article.id!});
      notifyListeners();
    }
  }

  void removeArticleFromCategory(String categoryName, Article article) {
    if (_categories.containsKey(categoryName)) {
      _categories[categoryName]!.remove(article);
      _dbHelper.deleteArticle(article.id!);
      notifyListeners();
    }
  }

  void renameCategory(String oldName, String newName) {
    if (_categories.containsKey(oldName) && !_categories.containsKey(newName)) {
      _categories[newName] = _categories.remove(oldName)!;
      notifyListeners();
    }
  }

  void deleteCategory(String categoryName) {
    _categories.remove(categoryName);
    notifyListeners();
  }
}
