import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proval/pages/news_page.dart';

class NewsApi {
  static Future<List<NewsItem>> fetchNews() async {
    final response = await http.get(
      Uri.parse('https://vlrggapi.vercel.app/news'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List segments = data['data']['segments'];
      return segments.map((e) => NewsItem.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}
