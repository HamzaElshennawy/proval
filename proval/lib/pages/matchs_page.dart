import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:proval/providers/match_provider.dart';

class MatchsPage extends StatefulWidget {
  const MatchsPage({super.key});

  @override
  State<MatchsPage> createState() => _MatchsPageState();
}

class _MatchsPageState extends State<MatchsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => Provider.of<MatchProvider>(context, listen: false).fetchMatches(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matchProvider = context.watch<MatchProvider>();
    final matches = matchProvider.matches;

    return Scaffold(
      appBar: AppBar(title: const Text("Matchs Page")),
      body: matchProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : (matches == null || matches.isEmpty)
          ? const Center(child: Text("No matches found"))
          : ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];
                return ListTile(
                  title: Text("${match.team1} vs ${match.team2}"),
                  subtitle: Text(match.tournamentName ?? ""),
                );
              },
            ),
    );
  }
}
