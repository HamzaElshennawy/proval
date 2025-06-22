import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:proval/providers/match_provider.dart';
import 'package:provider/provider.dart';
import 'package:proval/pages/match_details_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String _matchType = "upcoming"; // Default to "upcoming"

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MatchProvider>(
        context,
        listen: false,
      ).fetchMatches(query: _matchType),
    );
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

  Widget _buildMatchesTab(BuildContext context) {
    final matchProvider = context.watch<MatchProvider>();
    final matches = matchProvider.matches;

    if (matchProvider.loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (matches == null || matches.isEmpty) {
      return const Center(child: Text("No matches found"));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: matches.length,
      itemBuilder: (context, index) {
        final match = matches[index];
        // UPCOMING MATCH CARD
        if (_matchType == "upcoming") {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MatchDetailsPage(match: match),
                ),
              );
            },
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Teams row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              if (match.flag1 != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    match.flag1!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              Text(
                                match.team1 ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Column(
                            children: [
                              Icon(
                                Icons.access_time,
                                color: Colors.orange[700],
                                size: 22,
                              ),
                              if (match.timeUntilMatch != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    match.timeUntilMatch!,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              if (match.flag2 != null)
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4),
                                  child: Text(
                                    match.flag2!,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ),
                              Text(
                                match.team2 ?? "",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Series and Event
                    if (match.matchSeries != null)
                      Text(
                        match.matchSeries!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (match.matchEvent != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          match.matchEvent!,
                          style: TextStyle(
                            fontSize: 15,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ),
                      ),
                    // Scheduled time
                    if (match.unixTimestamp != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 6),
                            Text(
                              "Scheduled: ${match.unixTimestamp!}",
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // External link
                    if (match.matchPage != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Row(
                          children: [
                            Icon(
                              Icons.open_in_new,
                              size: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                "View on VLR.gg",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  decoration: TextDecoration.underline,
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        } else if (_matchType == "live_score") {
          // LIVE MATCH CARD
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MatchDetailsPage(match: match),
                ),
              );
            },
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        // Team 1 logo and name
                        Column(
                          children: [
                            if (match.team1Logo != null)
                              CircleAvatar(
                                backgroundImage: NetworkImage(match.team1Logo!),
                                radius: 22,
                                backgroundColor: Colors.grey[200],
                              ),
                            const SizedBox(height: 6),
                            Text(
                              match.team1 ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        // Score and map
                        Column(
                          children: [
                            Text(
                              "${match.score1} : ${match.score2}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            if (match.currentMap != null)
                              Text(
                                "Map: ${match.currentMap}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey,
                                ),
                              ),
                            if (match.timeUntilMatch != null)
                              Text(
                                match.timeUntilMatch!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Colors.redAccent,
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        // Team 2 logo and name
                        Column(
                          children: [
                            if (match.team2Logo != null)
                              CircleAvatar(
                                backgroundImage: NetworkImage(match.team2Logo!),
                                radius: 22,
                                backgroundColor: Colors.grey[200],
                              ),
                            const SizedBox(height: 6),
                            Text(
                              match.team2 ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      match.matchEvent ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (match.matchSeries != null)
                      Text(
                        match.matchSeries!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                        ),
                      ),
                    if (match.matchPage != null)
                      TextButton(
                        onPressed: () {
                          // You can use url_launcher to open the link
                        },
                        child: const Text("View Match"),
                      ),
                  ],
                ),
              ),
            ),
          );
        } else {
          // RESULTS CARD
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MatchDetailsPage(match: match),
                ),
              );
            },
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 18,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Team 1 Name
                        Expanded(
                          child: Text(
                            match.team1 ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        // Score (centered)
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 6,
                                  horizontal: 18,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  "${match.score1} : ${match.score2}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 22,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Result",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Team 2 Name
                        Expanded(
                          child: Text(
                            match.team2 ?? "",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        if (match.tournamentIcon != null)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              match.tournamentIcon!,
                              width: 28,
                              height: 28,
                              fit: BoxFit.cover,
                            ),
                          ),
                        if (match.tournamentIcon != null)
                          const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            match.tournamentName ?? "",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.secondary,
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
                        style: TextStyle(
                          fontSize: 13,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                    ],
                    if (match.timeCompleted != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        match.timeCompleted!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildNewsTab(BuildContext context) {
    return const Center(
      child: Text(
        "News coming soon!",
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [
      _buildMatchesTab(context),
      _buildNewsTab(context),
      const Center(child: Text("Home", style: TextStyle(fontSize: 20))),
    ];

    Widget matchTypeTabBar = Container(
      margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Upcoming (first tab, default)
          Expanded(
            child: GestureDetector(
              onTap: () => _switchMatchType("upcoming"),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _matchType == "upcoming"
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Upcoming",
                    style: TextStyle(
                      color: _matchType == "upcoming"
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Live Matches (second tab)
          Expanded(
            child: GestureDetector(
              onTap: () => _switchMatchType("live_score"),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _matchType == "live_score"
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Live Matches",
                    style: TextStyle(
                      color: _matchType == "live_score"
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          // Results (third tab)
          Expanded(
            child: GestureDetector(
              onTap: () => _switchMatchType("results"),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: _matchType == "results"
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.18)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Results",
                    style: TextStyle(
                      color: _matchType == "results"
                          ? Theme.of(context).colorScheme.primary
                          : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text("ProVal"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          if (_selectedIndex == 0) matchTypeTabBar,
          Expanded(child: tabs[_selectedIndex]),
        ],
      ),
      bottomNavigationBar: Container(
        height: 91,
        margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
        decoration: BoxDecoration(
          color: Colors.transparent,
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.07),
              blurRadius: 16,
              offset: const Offset(0, -5),
            ),
          ],
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
          border: Border.all(color: Colors.white.withOpacity(0.30), width: 1.2),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: BottomNavigationBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              selectedItemColor: Theme.of(context).colorScheme.primary,
              unselectedItemColor: Colors.grey[500],
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
              iconSize: 30,
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Icon(Icons.sports_soccer),
                  ),
                  label: "Matches",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Icon(Icons.article),
                  ),
                  label: "News",
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Icon(Icons.home),
                  ),
                  label: "Home",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
