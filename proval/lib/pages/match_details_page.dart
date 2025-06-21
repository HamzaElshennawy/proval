import 'package:flutter/material.dart';
import 'package:proval/models/match.dart';

class MatchDetailsPage extends StatelessWidget {
  final Match match;

  const MatchDetailsPage({super.key, required this.match});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget infoRow({
      required IconData icon,
      required String label,
      required String? value,
    }) {
      if (value == null || value.isEmpty || value == "N/A")
        return const SizedBox.shrink();
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
            // Teams and Score
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Team 1
                Column(
                  children: [
                    if (match.team1Logo != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(match.team1Logo!),
                        radius: 36,
                        backgroundColor: Colors.grey[200],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      match.team1 ?? "",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (match.flag1 != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          match.flag1!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 28),
                // Score
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(16),
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
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          "Map: ${match.currentMap!} (Map #${match.mapNumber ?? "?"})",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
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
                const SizedBox(width: 28),
                // Team 2
                Column(
                  children: [
                    if (match.team2Logo != null)
                      CircleAvatar(
                        backgroundImage: NetworkImage(match.team2Logo!),
                        radius: 36,
                        backgroundColor: Colors.grey[200],
                      ),
                    const SizedBox(height: 8),
                    Text(
                      match.team2 ?? "",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    if (match.flag2 != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          match.flag2!,
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 32),
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
                child: Image.network(
                  match.tournamentIcon!,
                  height: 48,
                  fit: BoxFit.contain,
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
                padding: const EdgeInsets.only(top: 8),
                child: InkWell(
                  onTap: () {
                    // Use url_launcher to open the link if desired
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.open_in_new, color: theme.colorScheme.primary),
                      const SizedBox(width: 6),
                      Text(
                        "View on VLR.gg",
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 24),
            // Map Details (if available)
            if (match.team1RoundCt != null ||
                match.team1RoundT != null ||
                match.team2RoundCt != null ||
                match.team2RoundT != null)
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        "Map Details",
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
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
