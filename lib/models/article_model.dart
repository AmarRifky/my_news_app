class Article {
  final int? id;
  final String title;
  final String description;
  final String urlToImage;
  final String? content; // New field for article content
  final String? url;     // New field for the original article URL
  final DateTime? date;

  Article({
    this.id,
    required this.title,
    required this.description,
    required this.urlToImage,
    this.content,
    this.url,
    this.date,
  });

  // Convert an Article into a Map for database storage. The keys must correspond to the column names in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'urlToImage': urlToImage,
      'content': content,
      'url': url,
      'date': date?.toIso8601String(),
    };
  }

  // Create an Article instance from JSON
  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] as int?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      urlToImage: json['urlToImage'] as String? ?? '',
      content: json['content'] as String? ?? '', // Extract content
      url: json['url'] as String? ?? '',         // Extract URL
      date: json['publishedAt'] != null ? DateTime.parse(json['publishedAt']) : null,
    );
  }
}
