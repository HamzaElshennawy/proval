class Match {
  final String? team1;
  final String? team2;
  final String? flag1;
  final String? flag2;
  final String? score1;
  final String? score2;
  final String? roundInfo;
  final String? tournamentName;
  final String? tournamentIcon;
  final String? timeCompleted;
  final String? matchPage;

  // New fields for live_score
  final String? team1Logo;
  final String? team2Logo;
  final String? team1RoundCt;
  final String? team1RoundT;
  final String? team2RoundCt;
  final String? team2RoundT;
  final String? mapNumber;
  final String? currentMap;
  final String? timeUntilMatch;
  final String? matchEvent;
  final String? matchSeries;
  final String? unixTimestamp;

  Match({
    this.team1,
    this.team2,
    this.flag1,
    this.flag2,
    this.score1,
    this.score2,
    this.roundInfo,
    this.tournamentName,
    this.tournamentIcon,
    this.timeCompleted,
    this.matchPage,
    // New fields
    this.team1Logo,
    this.team2Logo,
    this.team1RoundCt,
    this.team1RoundT,
    this.team2RoundCt,
    this.team2RoundT,
    this.mapNumber,
    this.currentMap,
    this.timeUntilMatch,
    this.matchEvent,
    this.matchSeries,
    this.unixTimestamp,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      team1: json['team1'],
      team2: json['team2'],
      flag1: json['flag1'],
      flag2: json['flag2'],
      score1: json['score1'],
      score2: json['score2'],
      roundInfo: json['round_info'],
      tournamentName: json['tournament_name'] ?? json['match_event'],
      tournamentIcon: json['tournament_icon'],
      timeCompleted: json['time_completed'],
      matchPage: json['match_page'],
      // New fields for live_score
      team1Logo: json['team1_logo'],
      team2Logo: json['team2_logo'],
      team1RoundCt: json['team1_round_ct'],
      team1RoundT: json['team1_round_t'],
      team2RoundCt: json['team2_round_ct'],
      team2RoundT: json['team2_round_t'],
      mapNumber: json['map_number'],
      currentMap: json['current_map'],
      timeUntilMatch: json['time_until_match'],
      matchEvent: json['match_event'],
      matchSeries: json['match_series'],
      unixTimestamp: json['unix_timestamp'],
    );
  }
}
