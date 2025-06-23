import 'package:flutter/material.dart';
import 'package:proval/models/match.dart';
import 'package:url_launcher/url_launcher.dart';

class MatchDetailsPage extends StatelessWidget {
  final Match match;

  const MatchDetailsPage({super.key, required this.match});

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

    Widget infoRow({
      required IconData icon,
      required String label,
      required String? value,
    }) {
      if (value == null || value.isEmpty || value == "N/A") {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(icon, size: 20, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            Text(
              "$label: ",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: Text(
                value,
                style: theme.textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('${match.team1 ?? ""} vs ${match.team2 ?? ""}'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Teams and Score Card
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: theme.colorScheme.surfaceVariant.withOpacity(0.85),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 28,
                  horizontal: 16,
                ),
                child: Row(
                  children: [
                    // Team 1
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          if (match.team1Logo != null)
                            CircleAvatar(
                              backgroundImage: NetworkImage(match.team1Logo!),
                              radius: 36,
                              backgroundColor: Colors.grey[200],
                            ),
                          const SizedBox(height: 10),
                          Text(
                            match.team1 ?? "",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (match.flag1 != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                match.flag1!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Score and Map
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 28,
                            ),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary.withOpacity(
                                0.13,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Text(
                              "${match.score1 ?? "-"} : ${match.score2 ?? "-"}",
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          if (match.currentMap != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Map: ${match.currentMap!} ${match.mapNumber != null ? "(#${match.mapNumber})" : ""}",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          if (match.timeUntilMatch != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                match.timeUntilMatch!,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Team 2
                    Expanded(
                      flex: 3,
                      child: Column(
                        children: [
                          if (match.team2Logo != null)
                            CircleAvatar(
                              backgroundImage: NetworkImage(match.team2Logo!),
                              radius: 36,
                              backgroundColor: Colors.grey[200],
                            ),
                          const SizedBox(height: 10),
                          Text(
                            match.team2 ?? "",
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.primary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (match.flag2 != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                match.flag2!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Event & Tournament
            if (match.matchEvent != null)
              infoRow(
                icon: Icons.emoji_events,
                label: "Event",
                value: match.matchEvent,
              ),
            if (match.tournamentIcon != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    match.tournamentIcon!,
                    height: 48,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            if (match.tournamentName != null)
              infoRow(
                icon: Icons.emoji_events_outlined,
                label: "Tournament",
                value: match.tournamentName,
              ),
            if (match.matchSeries != null)
              infoRow(
                icon: Icons.flag,
                label: "Series",
                value: match.matchSeries,
              ),
            if (match.roundInfo != null)
              infoRow(
                icon: Icons.sports,
                label: "Round",
                value: match.roundInfo,
              ),
            if (match.timeCompleted != null)
              infoRow(
                icon: Icons.check_circle,
                label: "Completed",
                value: match.timeCompleted,
              ),
            if (match.unixTimestamp != null)
              infoRow(
                icon: Icons.schedule,
                label: "Start",
                value: match.unixTimestamp,
              ),
            if (match.matchPage != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: ElevatedButton.icon(
                  onPressed: () => _openLink("vlr.gg${match.matchPage!}"),
                  icon: const Icon(Icons.open_in_new),
                  label: const Text("View on VLR.gg"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.inversePrimary,
                    foregroundColor: theme.colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 28),
            // Map Details (if available)
            if (match.team1RoundCt != null ||
                match.team1RoundT != null ||
                match.team2RoundCt != null ||
                match.team2RoundT != null)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    children: [
                      Text(
                        "Map Details",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                match.team1 ?? "",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("CT: ${match.team1RoundCt ?? "-"}"),
                              Text("T: ${match.team1RoundT ?? "-"}"),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                match.team2 ?? "",
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("CT: ${match.team2RoundCt ?? "-"}"),
                              Text("T: ${match.team2RoundT ?? "-"}"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
