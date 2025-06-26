import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:proval/api/news_api.dart';

class NewsItem {
  final String title;
  final String description;
  final String date;
  final String author;
  final String urlPath;

  NewsItem({
    required this.title,
    required this.description,
    required this.date,
    required this.author,
    required this.urlPath,
  });

  factory NewsItem.fromJson(Map<String, dynamic> json) {
    return NewsItem(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      date: json['date'] ?? '',
      author: json['author'] ?? '',
      urlPath: json['url_path'] ?? '',
    );
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late Future<List<NewsItem>> _newsFuture;

  @override
  void initState() {
    super.initState();
    _newsFuture = NewsApi.fetchNews();
  }

  Future<void> _openLink(String url) async {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      url = 'https://$url';
    }
    final uri = Uri.parse(url);
    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
      webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Valorant News'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<List<NewsItem>>(
        future: _newsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Failed to load news'));
          }
          final news = snapshot.data ?? [];
          if (news.isEmpty) {
            return const Center(child: Text("No news found"));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: news.length,
            separatorBuilder: (_, __) => const SizedBox(height: 22),
            itemBuilder: (context, index) {
              final item = news[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(26),
                  onTap: () => _openLink(item.urlPath),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: LinearGradient(
                        colors: theme.brightness == Brightness.dark
                            ? [
                                theme.colorScheme.primary.withOpacity(0.09),
                                theme.colorScheme.surface.withOpacity(0.98),
                              ]
                            : [
                                theme.colorScheme.primary.withOpacity(0.4),
                                theme.colorScheme.primary.withOpacity(0.4),
                              ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withOpacity(0.08),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 26,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title
                          Text(
                            item.title,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              color: theme.colorScheme.primary,
                              letterSpacing: 0.3,
                            ),
                          ),
                          // Description
                          if (item.description.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                item.description,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color: theme.brightness == Brightness.dark
                                      ? Colors.grey[200]
                                      : Colors.grey[900],
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          const SizedBox(height: 20),
                          // Date & Author Row
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_rounded,
                                size: 17,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 5),
                              Text(
                                item.date,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const Spacer(),
                              Icon(
                                Icons.person_rounded,
                                size: 17,
                                color: Colors.grey[500],
                              ),
                              const SizedBox(width: 5),
                              Text(
                                item.author,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Read More Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () => _openLink(item.urlPath),
                              icon: Icon(
                                Icons.open_in_new_rounded,
                                size: 19,
                                color: theme.colorScheme.primary,
                              ),
                              label: Text(
                                "Read on VLR.gg",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme.inversePrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                elevation: 0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
