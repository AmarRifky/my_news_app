import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'my_news_app.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
      'CREATE TABLE articles(id INTEGER PRIMARY KEY, title TEXT, description TEXT, urlToImage TEXT, publishedAt TEXT)',
    );
    await db.execute(
      'CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT)',
    );
    await db.execute(
      'CREATE TABLE category_articles(id INTEGER PRIMARY KEY, categoryId INTEGER, articleId INTEGER, FOREIGN KEY(categoryId) REFERENCES categories(id), FOREIGN KEY(articleId) REFERENCES articles(id))',
    );
  }

  Future<void> insertArticle(Map<String, dynamic> article) async {
    final db = await database;
    await db.insert('articles', article, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCategory(Map<String, dynamic> category) async {
    final db = await database;
    await db.insert('categories', category, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> insertCategoryArticle(Map<String, dynamic> categoryArticle) async {
    final db = await database;
    await db.insert('category_articles', categoryArticle, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getArticles() async {
    final db = await database;
    return await db.query('articles');
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return await db.query('categories');
  }

  Future<List<Map<String, dynamic>>> getArticlesByCategory(int categoryId) async {
    final db = await database;
    return await db.rawQuery('SELECT * FROM articles INNER JOIN category_articles ON articles.id = category_articles.articleId WHERE category_articles.categoryId = ?', [categoryId]);
  }

  Future<void> deleteArticle(int id) async {
    final db = await database;
    await db.delete('articles', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteCategory(int id) async {
    final db = await database;
    await db.delete('categories', where: 'id = ?', whereArgs: [id]);
  }
}
