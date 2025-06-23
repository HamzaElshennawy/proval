//import 'dart:convert';
//import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:proval/providers/match_provider.dart';
import 'package:provider/provider.dart';
import 'package:proval/pages/match_details_page.dart';
import 'package:proval/pages/news_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _matchType = "upcoming";
  //List<NewsItem> _newsList = [];
  //bool _newsLoading = true;
  //String? _newsError;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MatchProvider>(
        context,
        listen: false,
      ).fetchMatches(query: _matchType);
    });
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    setState(() {
      //_newsLoading = true;
      //_newsError = null;
    });
    try {
      final response = await http.get(
        Uri.parse('https://vlrggapi.vercel.app/news'),
      );
      if (response.statusCode == 200) {
        //final data = json.decode(response.body);
        //final List segments = data['data']['segments'];
        setState(() {
          //_newsList = segments.map((e) => NewsItem.fromJson(e)).toList();
          //_newsLoading = false;
        });
      } else {
        setState(() {
          //_newsError = 'Failed to load news (${response.statusCode})';
          //_newsLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        //_newsError = 'Failed to load news';
        //_newsLoading = false;
      });
    }
  }

  void _switchMatchType(String type) {
    if (_matchType == type) return;
    setState(() {
      _matchType = type;
    });
    Provider.of<MatchProvider>(
      context,
      listen: false,
    ).fetchMatches(query: type);
  }

  Widget _buildMatchTypeButton(
    BuildContext context,
    String type,
    String label,
  ) {
    final theme = Theme.of(context);
    final bool selected = _matchType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => _switchMatchType(type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.surfaceVariant,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: selected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.outline.withOpacity(0.2),
              width: selected ? 2 : 1,
            ),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: selected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.3,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMatchesTab(BuildContext context) {
    final matchProvider = context.watch<MatchProvider>();
    final matches = matchProvider.matches;
    final error = matchProvider.error;
    final theme = Theme.of(context);

    Widget matchTypeBar = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.8),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildMatchTypeButton(context, "upcoming", "Upcoming"),
            const SizedBox(width: 8),
            _buildMatchTypeButton(context, "live", "Live"),
            const SizedBox(width: 8),
            _buildMatchTypeButton(context, "results", "Completed"),
          ],
        ),
      ),
    );

    if (matchProvider.loading) {
      return Column(
        children: [
          matchTypeBar,
          const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      );
    }

    if (error != null && error.isNotEmpty) {
      return Column(
        children: [
          matchTypeBar,
          Expanded(
            child: Center(
              child: Text(
                error == '504'
                    ? 'Server timeout. Please try again later.'
                    : error,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      );
    }

    if (matches == null || matches.isEmpty) {
      return Column(
        children: [
          matchTypeBar,
          const Expanded(child: Center(child: Text("No matches found"))),
        ],
      );
    }

    return Column(
      children: [
        matchTypeBar,
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 22),
            itemBuilder: (context, index) {
              final match = matches[index];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(26),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MatchDetailsPage(match: match),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      gradient: LinearGradient(
                        colors: [
                          theme.colorScheme.primary.withOpacity(0.09),
                          theme.colorScheme.surface.withOpacity(0.98),
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
                          Row(
                            children: [
                              if (match.team1Logo != null)
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    match.team1Logo!,
                                  ),
                                  radius: 18,
                                  backgroundColor: Colors.grey[200],
                                ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  match.team1 ?? "",
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                match.score1 ?? "-",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                ":",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                match.score2 ?? "-",
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  match.team2 ?? "",
                                  textAlign: TextAlign.end,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.primary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              if (match.team2Logo != null)
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    match.team2Logo!,
                                  ),
                                  radius: 18,
                                  backgroundColor: Colors.grey[200],
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              if (match.tournamentIcon != null)
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Image.network(
                                    match.tournamentIcon!,
                                    height: 22,
                                    width: 22,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                              Expanded(
                                child: Text(
                                  match.tournamentName ?? "",
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.secondary,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (match.roundInfo != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              match.roundInfo!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (match.timeCompleted != null) ...[
                            const SizedBox(height: 6),
                            Text(
                              match.timeCompleted!,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                          if (match.timeUntilMatch != null) ...[
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(
                                  Icons.schedule,
                                  size: 16,
                                  color: theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  match.timeUntilMatch!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                          const SizedBox(height: 14),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MatchDetailsPage(match: match),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.open_in_new_rounded,
                                size: 18,
                                color: theme.colorScheme.primary,
                              ),
                              label: Text(
                                "Details",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    theme.colorScheme.inversePrimary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
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
          ),
        ),
      ],
    );
  }

  //Widget _buildNewsTab(BuildContext context) {
  //  return const NewsPage();
  //}

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [_buildMatchesTab(context), const NewsPage()];

    return Scaffold(
      appBar: AppBar(
        title: const Text("ProVal"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_esports),
            label: "Matches",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: "News"),
        ],
      ),
    );
  }
}
