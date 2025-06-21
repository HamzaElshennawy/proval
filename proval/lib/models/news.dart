class News {
  final String title;
  final String description;
  final String date;
  final String author;
  final String urlPath;

  News({
    required this.title,
    required this.description,
    required this.date,
    required this.author,
    required this.urlPath,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      title: json['title'],
      description: json['description'],
      date: json['date'],
      author: json['author'],
      urlPath: json['url_path'],
    );
  }
}
